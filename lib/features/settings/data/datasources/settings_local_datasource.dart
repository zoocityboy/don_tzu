import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/core/services/audio_player_service.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';
import 'package:art_of_deal_war/core/services/tts_audio_player.dart';

const String _boxName = 'settings';
const String _keyThemeMode = 'theme_mode';
const String _keyLanguage = 'language';
const String _keyBackgroundMusic = 'background_music';
const String _keyTtsReader = 'tts_reader';

abstract class SettingsLocalDataSource {
  Future<UserSettings> getSettings();
  Future<void> saveSettings(UserSettings settings);
  Future<void> clearSettings();
  Future<void> playBackgroundMusic();
  Future<void> stopBackgroundMusic();
  Future<void> setTtsEnabled(bool enabled);
  Future<bool> checkAndGenerateTts(
    String languageCode,
    List<MapEntry<String, String>> chapters,
  );
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final AudioPlayerService _audioPlayerService;
  final TtsService _ttsService;
  final TtsAudioPlayer _ttsAudioPlayer;

  SettingsLocalDataSourceImpl({
    required AudioPlayerService audioPlayerService,
    required TtsService ttsService,
    required TtsAudioPlayer ttsAudioPlayer,
  }) : _audioPlayerService = audioPlayerService,
       _ttsService = ttsService,
       _ttsAudioPlayer = ttsAudioPlayer;

  Future<Box> get _box => Hive.openBox(_boxName);

  @override
  Future<UserSettings> getSettings() async {
    final box = await _box;
    return UserSettings(
      themeMode:
          ThemeMode.values[box.get(_keyThemeMode, defaultValue: 0) as int],
      language: box.get(_keyLanguage, defaultValue: 'en') as String,
      backgroundMusicEnabled:
          box.get(_keyBackgroundMusic, defaultValue: true) as bool,
      ttsReaderEnabled: box.get(_keyTtsReader, defaultValue: true) as bool,
    );
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    final box = await _box;
    await box.put(_keyThemeMode, settings.themeMode.index);
    await box.put(_keyLanguage, settings.language);
    await box.put(_keyBackgroundMusic, settings.backgroundMusicEnabled);
    await box.put(_keyTtsReader, settings.ttsReaderEnabled);
  }

  @override
  Future<void> clearSettings() async {
    final box = await _box;
    await box.clear();
  }

  @override
  Future<void> playBackgroundMusic() async {
    _audioPlayerService.play('sound/walen-lonely-samurai.mp3');
  }

  @override
  Future<void> stopBackgroundMusic() async {
    await _audioPlayerService.stop();
  }

  @override
  Future<void> setTtsEnabled(bool enabled) async {
    if (enabled) {
      _ttsAudioPlayer.unmute();
    } else {
      _ttsAudioPlayer.mute();
    }
  }

  @override
  Future<bool> checkAndGenerateTts(
    String languageCode,
    List<MapEntry<String, String>> chapters,
  ) async {
    final texts = chapters
        .map(
          (e) => TtsTextModel(id: e.key, text: e.value, language: languageCode),
        )
        .toList();
    await _ttsService.generateForLanguage(languageCode, texts);
    return _ttsService.isLanguageReady(languageCode);
  }
}
