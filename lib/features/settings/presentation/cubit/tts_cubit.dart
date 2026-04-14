import 'dart:io';
import 'package:edge_tts/edge_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';

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
}

class TtsCubit extends Cubit<TtsState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'tts_player')
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.mediaPlayer);

  final Map<String, bool> _initialized = {};

  TtsCubit() : super(const TtsState()) {
    _player.onPlayerStateChanged.listen((playerState) {
      emit(
        state.copyWith(
          isPlaying: playerState == PlayerState.playing,
        ),
      );
      if (playerState == PlayerState.completed) {
        emit(state.copyWith(isPlaying: false, currentChapterId: null));
      }
    });
  }

  bool isLanguageReady(String language) {
    return _initialized[language.split('-').first] ?? false;
  }

  String? getFilePath(String chapterId, String language) {
    final lang = language.split('-').first;
    return state.audioFiles[lang]?[chapterId];
  }

  Future<void> generateForLanguage(
    String language,
    List<TtsTextModel> texts,
  ) async {
    final lang = language.split('-').first;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/${lang}');
      await audioDir.create(recursive: true);

      final voice = await _findVoice(lang);
      final audioFiles = <String, String>{};

      for (final text in texts) {
        final filePath = '${audioDir.path}/${text.id}.mp3';
        if (!File(filePath).existsSync()) {
          await _synthesize(text.text, filePath, voice, text.language);
        }
        audioFiles[text.id] = filePath;
      }

      final updatedFiles = Map<String, Map<String, String>>.from(
        state.audioFiles,
      );
      updatedFiles[lang] = audioFiles;

      _initialized[lang] = true;
      debugPrint(
        'TTS generated for language: $lang with voice: $voice and files: $audioFiles',
      );
      emit(state.copyWith(audioFiles: updatedFiles, isReady: true));
      debugPrint('TTS generated for language: $lang');
    } catch (e) {
      debugPrint('TTS error for $lang: $e');
      emit(
        state.copyWith(
          isReady: false,
          error: e is Exception ? e : Exception('Unknown error'),
        ),
      );
    }
  }

  Future<String> _findVoice(String language) async {
    final voices = await listVoices();
    try {
      return voices.firstWhere((v) => v.locale.startsWith(language)).shortName;
    } catch (_) {
      return voices.first.shortName;
    }
  }

  Future<void> _synthesize(
    String text,
    String filePath,
    String voice,
    String language,
  ) async {
    final tts = Communicate(
      text: text,
      voice: voice,
      rate: '-10%',
      pitch: '-20Hz',
      volume: '+0%',
    );
    await tts.save(filePath);
    _initialized[language] = true;
  }

  Future<void> play(String chapterId, String language) async {
    // if (state.isMuted) return;

    final filePath = getFilePath(chapterId, language);
    if (filePath != null) {
      await stop();
      try {
        final source = DeviceFileSource(
          filePath,
          mimeType: filePath.endsWith('.mp3') ? 'audio/mpeg' : 'audio/wav',
        );
        _player.play(source, mode: PlayerMode.mediaPlayer);
        emit(
          state.copyWith(
            isPlaying: true,
            currentChapterId: chapterId,
            currentLanguage: language,
          ),
        );
      } catch (e) {
        debugPrint('TTS play error: $filePath $e');
        emit(
          state.copyWith(
            isPlaying: false,
            error: e is Exception ? e : Exception('Unknown error'),
          ),
        );
      }
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      emit(state.copyWith(isPlaying: false, currentChapterId: null));
    } catch (_) {}
  }

  Future<void> pause() async {
    await _player.pause();
    emit(state.copyWith(isPlaying: false));
  }

  void toggleMute() {
    if (state.isMuted) {
      _player.setVolume(1);
      emit(state.copyWith(isMuted: false));
    } else {
      _player.setVolume(0);
      emit(state.copyWith(isMuted: true));
      if (state.isPlaying) {
        _player.pause();
        emit(state.copyWith(isPlaying: false));
      }
    }
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
