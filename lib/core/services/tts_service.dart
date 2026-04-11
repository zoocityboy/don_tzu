import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:edge_tts/edge_tts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  bool _isInitialized = false;
  final Map<String, String> _audioFiles = {};

  bool get isSpeaking => _audioPlayer.state == PlayerState.playing;
  bool get isMuted => _audioPlayer.volume == 0;

  final AudioPlayer _audioPlayer = AudioPlayer(playerId: 'tts_player')
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.mediaPlayer)
    ..setVolume(1);

  void toggleMute() {
    if (isMuted) {
      _audioPlayer.setVolume(1);
    } else {
      _audioPlayer.setVolume(0);
      stop();
    }
  }

  Future<String> _getVoiceForLocale(String languageCode) async {
    final voices = await listVoices();
    // for (final voice in voices) {
    //   print('${voice.shortName} (${voice.gender}, ${voice.locale})');
    // }

    final voice = voices.firstWhere(
      (v) => v.locale.startsWith(languageCode),
      orElse: () => voices.firstWhere(
        (v) => v.locale.startsWith('en'),
        orElse: () => voices.first,
      ),
    );
    final selectedVoice = voice.shortName;
    print(
      'Selected TTS voice: $selectedVoice for language code: $languageCode',
    );
    return voice.shortName;
  }

  Future<void> _generateAudioFile(
    String id,
    String text,
    String filePath,
    String languageCode,
  ) async {
    final voice = await _getVoiceForLocale(languageCode);

    final tts = Communicate(
      text: text,
      voice: voice,
      rate: '-10%',
      pitch: '-20Hz',
      volume: '+0%',
      sentenceBoundary: true,
      wordBoundary: true,
    );

    await tts.save(filePath);
    print('Generated TTS audio for $id at $filePath');
    print(
      'TTS generation completed for $id with voice $voice and language $languageCode',
    );
    print(
      'TTS generation completed for $id with voice $voice and language $languageCode',
    );
  }

  Future<void> initWithChapters(List<MapEntry<String, String>> chapters) async {
    if (_isInitialized) return;

    try {
      final fullLocale =
          Intl.defaultLocale ?? Platform.localeName.split('_').first;
      final languageCode = fullLocale.contains('-')
          ? fullLocale.split('-').first
          : fullLocale;

      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/$languageCode');
      if (!audioDir.existsSync()) {
        await audioDir.create(recursive: true);
      }
      final voices = await listVoices();
      for (final voice in voices) {
        print('${voice.shortName} (${voice.gender}, ${voice.locale})');
      }

      for (final chapter in chapters) {
        final filePath = '${audioDir.path}/${chapter.key}.mp3';
        final file = File(filePath);

        if (!file.existsSync()) {
          await _generateAudioFile(
            chapter.key,
            chapter.value,
            filePath,
            languageCode,
          );
        }
        _audioFiles[chapter.key] = filePath;
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS init error: $e');
      _isInitialized = true;
    }
  }

  Future<void> playChapter(String chapterId) async {
    if (isMuted) return;

    final filePath = _audioFiles[chapterId];

    if (filePath == null) return;

    await stop();

    try {
      final source = DeviceFileSource(
        filePath,
        mimeType: filePath.endsWith('.mp3') ? 'audio/mpeg' : 'audio/wav',
      );
      _audioPlayer.setSourceDeviceFile(
        filePath,
        mimeType: filePath.endsWith('.mp3') ? 'audio/mpeg' : 'audio/wav',
      );
      _audioPlayer.play(source, mode: PlayerMode.mediaPlayer);
      debugPrint('Playing TTS for chapter $chapterId source: $source ');
      // _currentProcess = await Process.start('afplay', [filePath]);
      // await _currentProcess!.exitCode;
    } catch (e) {
      debugPrint('TTS play error: $filePath $e');
    } finally {}
  }

  Future<void> speak(String text) async {}

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  void dispose() {
    stop();
    _audioPlayer.dispose();
  }
}
