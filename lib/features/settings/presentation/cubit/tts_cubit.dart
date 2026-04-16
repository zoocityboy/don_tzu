import 'dart:async';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TtsState {
  final dynamic file;
  final String? error;

  const TtsState({this.file, this.error});

  TtsState copyWith({dynamic file, String? error}) {
    return TtsState(file: file ?? this.file, error: error ?? this.error);
  }

  @override
  String toString() {
    return 'TtsState(file: $file, error: $error)';
  }
}

class TtsCubit extends Cubit<TtsState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'tts_player');
  final SettingsLocalDataSource _settingsStorage;
  late final StreamSubscription<dynamic> _settingsSubscription;

  TtsCubit({required SettingsLocalDataSource settingsStorage})
    : _settingsStorage = settingsStorage,
      super(TtsState(file: null, error: null)) {
    _initPlayer();
    _settingsSubscription = _settingsStorage
        .watch(key: SettingsLocalDataSource.ttsReaderEnabledKey)
        .listen((_) {
          _syncWithSettings();
        });
    _syncWithSettings();
  }
  void _syncWithSettings() {
    final isEnabled = _settingsStorage.readSettings().ttsReaderEnabled;
    if (!isEnabled) {
      _player.setVolume(0);
      stop();
    } else {
      _player.setVolume(1);
    }
  }

  void _initPlayer() {
    _player.onPlayerComplete.listen((_) {
      AppLogger.debug('TTS playback completed');
      emit(state.copyWith(file: null));
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
      }
    });

    _player.onPlayerComplete.listen((_) {
      AppLogger.error('TTS player error');
      emit(state.copyWith(file: null, error: 'Playback error'));
    });

    AppLogger.info('TTS player initialized');
  }

  Future<void> play(Source uri) async {
    if (!_settingsStorage.readSettings().ttsReaderEnabled) {
      AppLogger.info('TTS play ignored because the reader is disabled');

      return;
    }
    print('Playing TTS from: $uri');

    _player.play(uri);
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> toggleMute({bool? enabled}) async {
    final shouldMute = enabled ?? _player.volume == 0;
    await _settingsStorage.setTtsReaderEnabled(!shouldMute);
  }

  @override
  Future<void> close() async {
    await _settingsSubscription.cancel();
    await _player.dispose();
    return super.close();
  }
}
