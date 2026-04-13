import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserSettings extends Equatable {
  final ThemeMode themeMode;
  final String language;
  final bool backgroundMusicEnabled;
  final bool ttsReaderEnabled;

  const UserSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'en',
    this.backgroundMusicEnabled = true,
    this.ttsReaderEnabled = true,
  });

  UserSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? backgroundMusicEnabled,
    bool? ttsReaderEnabled,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      backgroundMusicEnabled:
          backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      ttsReaderEnabled: ttsReaderEnabled ?? this.ttsReaderEnabled,
    );
  }

  static const UserSettings defaultSettings = UserSettings();

  @override
  List<Object?> get props => [
    themeMode,
    language,
    backgroundMusicEnabled,
    ttsReaderEnabled,
  ];
}
