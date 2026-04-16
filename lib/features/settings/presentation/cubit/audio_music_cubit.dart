import 'dart:async';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioMusicState {
  final bool isPlaying;
  final bool isMuted;

  const AudioMusicState({this.isPlaying = false, this.isMuted = false});

  AudioMusicState copyWith({bool? isPlaying, bool? isMuted}) {
    return AudioMusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  @override
  String toString() {
    return 'AudioMusicState(isPlaying: $isPlaying, isMuted: $isMuted)';
  }
}

class AudioMusicCubit extends Cubit<AudioMusicState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'background_music');
  final SettingsLocalDataSource _settingsStorage;
  late final StreamSubscription<dynamic> _settingsSubscription;
  String? _currentAssetPath;

  AudioMusicCubit({required SettingsLocalDataSource settingsStorage})
    : _settingsStorage = settingsStorage,
      super(
        AudioMusicState(
          isMuted: !settingsStorage.readSettings().backgroundMusicEnabled,
        ),
      ) {
    _player.onPlayerStateChanged.listen((playerState) {
      emit(state.copyWith(isPlaying: playerState == PlayerState.playing));
    });
    _settingsSubscription = _settingsStorage
        .watch(key: SettingsLocalDataSource.backgroundMusicEnabledKey)
        .listen((_) {
          _syncWithSettings();
        });
    _syncWithSettings();
  }

  Future<void> play(String filePath) async {
    _currentAssetPath = filePath;

    if (!_settingsStorage.readSettings().backgroundMusicEnabled) {
      emit(state.copyWith(isPlaying: false, isMuted: true));
      return;
    }

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.2);
      await _player.play(AssetSource(filePath));
      emit(state.copyWith(isPlaying: true, isMuted: false));
      AppLogger.info('Background music started: $filePath');
    } catch (e) {
      AppLogger.error('Error playing audio', e);
    }
  }

  Future<void> pause() async {
    await _player.pause();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> stop() async {
    await _player.stop();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> toggleMute() async {
    await _settingsStorage.setBackgroundMusicEnabled(state.isMuted);
  }

  Future<void> _syncWithSettings() async {
    final isEnabled = _settingsStorage.readSettings().backgroundMusicEnabled;

    if (!isEnabled) {
      await _player.stop();
      if (!isClosed) {
        emit(state.copyWith(isPlaying: false, isMuted: true));
      }
      return;
    }

    await _player.setVolume(0.2);

    if (_currentAssetPath != null && !state.isPlaying) {
      try {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource(_currentAssetPath!));
      } catch (e) {
        AppLogger.error('Error resuming background music', e);
      }
    }

    if (!isClosed) {
      emit(state.copyWith(isMuted: false));
    }
  }

  @override
  Future<void> close() async {
    await _settingsSubscription.cancel();
    await _player.dispose();
    return super.close();
  }
}
