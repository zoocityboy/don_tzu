import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/audio_music_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
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
  final AudioMusicCubit _audioMusicCubit;
  final TtsCubit _ttsCubit;
  final UserSettings _settings;

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
    _ttsCubit.toggleMute(
      enabled: !enabled,
    ); // toggleMute with enabled=true mutes
  }

  Future<bool> setLanguage(String languageCode) async {
    emit(state.copyWith(language: languageCode));
    return true;
  }

  bool get ttsReaderEnabled => state.ttsReaderEnabled;
}
