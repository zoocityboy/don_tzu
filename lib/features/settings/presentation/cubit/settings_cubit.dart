import 'dart:async';

import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  String toString() {
    return 'SettingsState(themeMode: $themeMode, backgroundMusicEnabled: $backgroundMusicEnabled, ttsReaderEnabled: $ttsReaderEnabled, language: $language)';
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource _settingsStorage;
  late final StreamSubscription<dynamic> _settingsSubscription;

  /// Get supported languages from AppLocalizations - dynamically from supported locales
  static List<Map<String, String>> get supportedLanguages {
    return AppLocalizations.supportedLocales.map((locale) {
      final code = locale.languageCode;
      return {'code': code, 'name': _getLanguageName(code)};
    }).toList();
  }

  static String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'cs':
        return 'Čeština';
      case 'de':
        return 'Deutsch';
      case 'hu':
        return 'Magyar';
      case 'pl':
        return 'Polski';
      case 'sk':
        return 'Slovenčina';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      default:
        return code;
    }
  }

  SettingsCubit({required SettingsLocalDataSource settingsStorage})
    : _settingsStorage = settingsStorage,
      super(_toState(settingsStorage.readSettings())) {
    _settingsSubscription = _settingsStorage.watch().listen((_) {
      _syncFromStorage();
    });
  }

  static SettingsState _toState(UserSettings settings) {
    return SettingsState(
      themeMode: settings.themeMode,
      backgroundMusicEnabled: settings.backgroundMusicEnabled,
      ttsReaderEnabled: settings.ttsReaderEnabled,
      language: settings.language,
    );
  }

  void _syncFromStorage() {
    final nextState = _toState(_settingsStorage.readSettings());
    if (nextState.themeMode == state.themeMode &&
        nextState.backgroundMusicEnabled == state.backgroundMusicEnabled &&
        nextState.ttsReaderEnabled == state.ttsReaderEnabled &&
        nextState.language == state.language) {
      return;
    }
    emit(nextState);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _settingsStorage.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setBackgroundMusic(bool enabled) async {
    await _settingsStorage.setBackgroundMusicEnabled(enabled);
    emit(state.copyWith(backgroundMusicEnabled: enabled));
  }

  Future<void> setTtsReader(bool enabled) async {
    await _settingsStorage.setTtsReaderEnabled(enabled);
    emit(state.copyWith(ttsReaderEnabled: enabled));
  }

  Future<bool> setLanguage(String languageCode) async {
    await _settingsStorage.setLanguage(languageCode);
    emit(state.copyWith(language: languageCode));
    return true;
  }

  bool get ttsReaderEnabled => state.ttsReaderEnabled;

  @override
  Future<void> close() async {
    await _settingsSubscription.cancel();
    return super.close();
  }
}
