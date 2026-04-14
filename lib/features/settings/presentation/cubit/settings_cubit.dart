import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/audio_music_cubit.dart';

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
  final AudioMusicCubit _audioMusicCubit;
  final TtsCubit _ttsCubit;
  final UserSettings _settings;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'cs', 'name': 'Čeština'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'hu', 'name': 'Magyar'},
    {'code': 'pl', 'name': 'Polski'},
    {'code': 'sk', 'name': 'Slovenčina'},
  ];

  SettingsCubit({
    required AudioMusicCubit audioMusicCubit,
    required TtsCubit ttsCubit,
    UserSettings? settings,
  }) : _audioMusicCubit = audioMusicCubit,
       _ttsCubit = ttsCubit,
       _settings = settings ?? UserSettings.defaultSettings,
       super(const SettingsState()) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    emit(
      SettingsState(
        themeMode: _settings.themeMode,
        backgroundMusicEnabled: _settings.backgroundMusicEnabled,
        ttsReaderEnabled: _settings.ttsReaderEnabled,
        language: _settings.language,
      ),
    );
    _applySettings();
  }

  void _applySettings() {
    if (state.backgroundMusicEnabled) {
      _audioMusicCubit.play('sound/walen-lonely-samurai.mp3');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setBackgroundMusic(bool enabled) async {
    emit(state.copyWith(backgroundMusicEnabled: enabled));
    if (enabled) {
      await _audioMusicCubit.play('sound/walen-lonely-samurai.mp3');
    } else {
      await _audioMusicCubit.stop();
    }
  }

  Future<void> setTtsReader(bool enabled) async {
    emit(state.copyWith(ttsReaderEnabled: enabled));
    _ttsCubit.toggleMute();
  }

  Future<bool> setLanguage(String languageCode) async {
    emit(state.copyWith(language: languageCode));
    return true;
  }

  bool get ttsReaderEnabled => state.ttsReaderEnabled;
}
