import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/features/settings/domain/repositories/settings_repository.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool backgroundMusicEnabled;
  final bool ttsReaderEnabled;
  final String language;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.backgroundMusicEnabled = true,
    this.ttsReaderEnabled = true,
    this.language = 'en',
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? backgroundMusicEnabled,
    bool? ttsReaderEnabled,
    String? language,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      backgroundMusicEnabled:
          backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      ttsReaderEnabled: ttsReaderEnabled ?? this.ttsReaderEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'cs', 'name': 'Čeština'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'hu', 'name': 'Magyar'},
    {'code': 'pl', 'name': 'Polski'},
    {'code': 'sk', 'name': 'Slovenčina'},
  ];

  SettingsCubit({
    required SettingsRepository repository,
  }) : _repository = repository,
       super(const SettingsState());

  Future<void> loadSettings() async {
    try {
      final settings = await _repository.getSettings();
      emit(
        SettingsState(
          themeMode: settings.themeMode,
          backgroundMusicEnabled: settings.backgroundMusicEnabled,
          ttsReaderEnabled: settings.ttsReaderEnabled,
          language: settings.language,
        ),
      );
      _applySettings(settings);
    } on Exception catch (_) {
      emit(const SettingsState());
    }
  }

  void _applySettings(UserSettings settings) {
    if (settings.backgroundMusicEnabled) {
      _repository.playBackgroundMusic();
    } else {
      _repository.stopBackgroundMusic();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = _toUserSettings(state);
    await _repository.saveSettings(current.copyWith(themeMode: mode));
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setBackgroundMusic(bool enabled) async {
    final current = _toUserSettings(state);
    await _repository.saveSettings(
      current.copyWith(backgroundMusicEnabled: enabled),
    );
    emit(state.copyWith(backgroundMusicEnabled: enabled));

    if (enabled) {
      await _repository.playBackgroundMusic();
    } else {
      await _repository.stopBackgroundMusic();
    }
  }

  Future<void> setTtsReader(bool enabled) async {
    final current = _toUserSettings(state);
    await _repository.saveSettings(current.copyWith(ttsReaderEnabled: enabled));
    await _repository.setTtsEnabled(enabled);
    emit(state.copyWith(ttsReaderEnabled: enabled));
  }

  Future<bool> setLanguage(String languageCode) async {
    final current = _toUserSettings(state);
    await _repository.saveSettings(current.copyWith(language: languageCode));
    emit(state.copyWith(language: languageCode));
    return true;
  }

  bool get ttsReaderEnabled => state.ttsReaderEnabled;

  UserSettings _toUserSettings(SettingsState state) {
    return UserSettings(
      themeMode: state.themeMode,
      language: state.language,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      ttsReaderEnabled: state.ttsReaderEnabled,
    );
  }
}
