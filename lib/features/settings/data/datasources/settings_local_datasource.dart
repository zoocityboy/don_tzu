import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class SettingsLocalDataSource {
  static const String boxName = 'settings';
  static const String themeModeKey = 'theme_mode';
  static const String backgroundMusicEnabledKey = 'background_music_enabled';
  static const String ttsReaderEnabledKey = 'tts_reader_enabled';
  static const String languageKey = 'language';

  final Box<dynamic> _box;

  const SettingsLocalDataSource(this._box);

  Stream<BoxEvent> watch({String? key}) => _box.watch(key: key);

  UserSettings readSettings() {
    return UserSettings(
      themeMode: _readThemeMode(),
      language:
          (_box.get(languageKey) as String?) ??
          UserSettings.defaultSettings.language,
      backgroundMusicEnabled:
          (_box.get(backgroundMusicEnabledKey) as bool?) ??
          UserSettings.defaultSettings.backgroundMusicEnabled,
      ttsReaderEnabled:
          (_box.get(ttsReaderEnabledKey) as bool?) ??
          UserSettings.defaultSettings.ttsReaderEnabled,
    );
  }

  Future<void> writeSettings(UserSettings settings) {
    return _box.putAll({
      themeModeKey: settings.themeMode.name,
      languageKey: settings.language,
      backgroundMusicEnabledKey: settings.backgroundMusicEnabled,
      ttsReaderEnabledKey: settings.ttsReaderEnabled,
    });
  }

  Future<void> setThemeMode(ThemeMode mode) {
    return _box.put(themeModeKey, mode.name);
  }

  Future<void> setBackgroundMusicEnabled(bool enabled) {
    return _box.put(backgroundMusicEnabledKey, enabled);
  }

  Future<void> setTtsReaderEnabled(bool enabled) {
    return _box.put(ttsReaderEnabledKey, enabled);
  }

  Future<void> setLanguage(String languageCode) {
    return _box.put(languageKey, languageCode);
  }

  ThemeMode _readThemeMode() {
    final storedValue = _box.get(themeModeKey) as String?;
    return switch (storedValue) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => UserSettings.defaultSettings.themeMode,
    };
  }
}