import 'dart:async';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TtsState {
  final bool isPlaying;
  final bool isMuted;
  final bool isReady;
  final String? currentChapterId;
  final String? currentLanguage;
  final String? error;

  const TtsState({
    this.isPlaying = false,
    this.isMuted = false,
    this.isReady = true,
    this.currentChapterId,
    this.currentLanguage,
    this.error,
  });

  TtsState copyWith({
    bool? isPlaying,
    bool? isMuted,
    bool? isReady,
    String? currentChapterId,
    String? currentLanguage,
    String? error,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      isReady: isReady ?? this.isReady,
      currentChapterId: currentChapterId ?? this.currentChapterId,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'TtsState(isPlaying: $isPlaying, isMuted: $isMuted, isReady: $isReady, currentChapterId: $currentChapterId, currentLanguage: $currentLanguage, error: $error)';
  }
}

class TtsCubit extends Cubit<TtsState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'tts_player');
  final SettingsLocalDataSource _settingsStorage;
  late final StreamSubscription<dynamic> _settingsSubscription;

  TtsCubit({required SettingsLocalDataSource settingsStorage})
    : _settingsStorage = settingsStorage,
      super(
        TtsState(
          isMuted: !settingsStorage.readSettings().ttsReaderEnabled,
        ),
      ) {
    _initPlayer();
    _settingsSubscription = _settingsStorage
        .watch(key: SettingsLocalDataSource.ttsReaderEnabledKey)
        .listen((_) {
          _syncWithSettings();
        });
    _syncWithSettings();
  }

  void _initPlayer() {
    _player.onPlayerComplete.listen((_) {
      AppLogger.debug('TTS playback completed');
      emit(state.copyWith(isPlaying: false, currentChapterId: null));
    });

    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        AppLogger.debug('TTS playing');
      } else if (state == PlayerState.paused) {
        AppLogger.debug('TTS paused');
      } else if (state == PlayerState.stopped) {
        AppLogger.debug('TTS stopped');
      } else if (state == PlayerState.completed) {
        AppLogger.debug('TTS completed');
        emit(this.state.copyWith(isPlaying: false, currentChapterId: null));
      }
    });

    _player.onPlayerComplete.listen((_) {
      AppLogger.error('TTS player error');
      emit(state.copyWith(isPlaying: false, error: 'Playback error'));
    });

    AppLogger.info('TTS player initialized');
  }

  bool isLanguageReady(String language) {
    return true;
  }

  String? getFilePath(String chapterId, String language) {
    return null;
  }

  Future<void> generateForLanguage(
    String language,
    List<dynamic> texts,
  ) async {}

  Future<void> speak(String text, String language) async {}

  Future<void> play(String chapterId, String language) async {
    if (!_settingsStorage.readSettings().ttsReaderEnabled) {
      AppLogger.info('TTS play ignored because the reader is disabled');
    }
  }

  Future<void> playUrl(String url, String chapterId, String language) async {
    AppLogger.info('TTS play URL requested: url=$url, chapterId=$chapterId');

    if (!_settingsStorage.readSettings().ttsReaderEnabled) {
      AppLogger.info('TTS play ignored because the reader is disabled');
      return;
    }

    try {
      await stop();

      await _player.play(UrlSource(url));

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
      emit(state.copyWith(isPlaying: false, error: e.toString()));
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

  Future<void> toggleMute({bool? enabled}) async {
    final shouldMute = enabled ?? !state.isMuted;
    await _settingsStorage.setTtsReaderEnabled(!shouldMute);
  }

  Future<void> _syncWithSettings() async {
    final isEnabled = _settingsStorage.readSettings().ttsReaderEnabled;

    await _player.setVolume(isEnabled ? 1 : 0);

    if (!isEnabled && state.isPlaying) {
      await _player.stop();
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          isMuted: !isEnabled,
          isPlaying: isEnabled ? state.isPlaying : false,
          currentChapterId: isEnabled ? state.currentChapterId : null,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _settingsSubscription.cancel();
    await _player.dispose();
    return super.close();
  }
}
