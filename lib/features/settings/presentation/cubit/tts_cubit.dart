import 'dart:io';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class TtsState {
  final bool isPlaying;
  final bool isMuted;
  final bool isReady;
  final String? currentChapterId;
  final String? currentLanguage;
  final Map<String, Map<String, String>> audioFiles;
  final Exception? error;

  const TtsState({
    this.isPlaying = false,
    this.isMuted = false,
    this.isReady = false,
    this.currentChapterId,
    this.currentLanguage,
    this.audioFiles = const {},
    this.error,
  });

  TtsState copyWith({
    bool? isPlaying,
    bool? isMuted,
    bool? isReady,
    String? currentChapterId,
    String? currentLanguage,
    Map<String, Map<String, String>>? audioFiles,
    Exception? error,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      isReady: isReady ?? this.isReady,
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      audioFiles: audioFiles ?? this.audioFiles,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'TtsState(isPlaying: $isPlaying, isMuted: $isMuted, isReady: $isReady, currentChapterId: $currentChapterId, currentLanguage: $currentLanguage, audioFiles: ${audioFiles.keys.toList()}, error: $error)';
  }
}

class TtsCubit extends Cubit<TtsState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'tts_player');
  final FlutterTts _tts = FlutterTts();
  final Map<String, bool> _initialized = {};

  TtsCubit() : super(const TtsState()) {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setSharedInstance(true);
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);

    _tts.setStartHandler(() {
      AppLogger.debug('TTS started');
    });

    _tts.setCompletionHandler(() {
      AppLogger.debug('TTS completed');
      emit(state.copyWith(isPlaying: false, currentChapterId: null));
    });

    _tts.setErrorHandler((msg) {
      AppLogger.error('TTS error: $msg');
      emit(
        state.copyWith(isPlaying: false, error: Exception('TTS error: $msg')),
      );
    });

    _tts.setCancelHandler(() {
      AppLogger.debug('TTS cancelled');
    });

    emit(state.copyWith(isReady: true));
    AppLogger.info('TTS initialized');
  }

  bool isLanguageReady(String language) {
    return _initialized[language.split('-').first] ?? false;
  }

  String? getFilePath(String chapterId, String language) {
    final lang = language.split('-').first;
    final langAudioFiles = state.audioFiles[lang];
    if (langAudioFiles == null) {
      AppLogger.warning('No audio files for language: $lang');
      return null;
    }
    final path = langAudioFiles[chapterId];
    if (path == null) {
      AppLogger.warning(
        'No audio file for chapter: $chapterId in language: $lang',
      );
      return null;
    }
    if (!File(path).existsSync()) {
      AppLogger.warning('Audio file does not exist: $path');
      return null;
    }
    return path;
  }

  Future<void> generateForLanguage(
    String language,
    List<TtsTextModel> texts,
  ) async {
    final lang = language.split('-').first;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/$lang');
      await audioDir.create(recursive: true);

      final audioFiles = <String, String>{};

      for (final text in texts) {
        final filePath = '${audioDir.path}/${text.id}.mp3';
        audioFiles[text.id] = filePath;
      }

      final updatedFiles = Map<String, Map<String, String>>.from(
        state.audioFiles,
      );
      updatedFiles[lang] = audioFiles;

      _initialized[lang] = true;
      AppLogger.info(
        'TTS paths registered for language: $lang with ${audioFiles.length} files',
      );
      emit(state.copyWith(audioFiles: updatedFiles, isReady: true));
    } catch (e) {
      AppLogger.error('TTS error for $lang', e);
      emit(
        state.copyWith(
          isReady: false,
          error: e is Exception ? e : Exception('Unknown error'),
        ),
      );
    }
  }

  Future<void> speak(String text, String language) async {
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  Future<void> play(String chapterId, String language) async {
    AppLogger.info(
      'TTS play requested: chapterId=$chapterId, language=$language',
    );

    try {
      await stop();

      final filePath = getFilePath(chapterId, language);
      if (filePath == null) {
        AppLogger.error('TTS: No file path for chapter: $chapterId');
        return;
      }

      AppLogger.info('TTS playing: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        AppLogger.error('TTS file does not exist: $filePath');
        return;
      }

      final bytes = await file.readAsBytes();
      final source = BytesSource(bytes);

      await _player.play(source);

      emit(
        state.copyWith(
          isPlaying: true,
          currentChapterId: chapterId,
          currentLanguage: language,
        ),
      );
      AppLogger.info('TTS playback started for: $chapterId');
    } catch (e) {
      AppLogger.error('TTS play error for: $chapterId', e);
      emit(
        state.copyWith(
          isPlaying: false,
          error: e is Exception ? e : Exception('Unknown error'),
        ),
      );
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      await _tts.stop();
      emit(state.copyWith(isPlaying: false, currentChapterId: null));
    } catch (_) {}
  }

  Future<void> pause() async {
    await _player.pause();
    await _tts.pause();
    emit(state.copyWith(isPlaying: false));
  }

  void toggleMute({bool? enabled}) {
    final value = enabled ?? !state.isMuted;
    if (value) {
      _player.setVolume(0);
      _tts.setVolume(0);
      emit(state.copyWith(isMuted: true));
      if (state.isPlaying) {
        _player.pause();
        emit(state.copyWith(isPlaying: false));
      }
    } else {
      _player.setVolume(1);
      _tts.setVolume(1);
      emit(state.copyWith(isMuted: false));
    }
  }

  @override
  Future<void> close() {
    _player.dispose();
    _tts.stop();
    return super.close();
  }
}
