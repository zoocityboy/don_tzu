import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioMusicState {
  final bool isPlaying;
  final bool isMuted;

  const AudioMusicState({
    this.isPlaying = false,
    this.isMuted = false,
  });

  AudioMusicState copyWith({
    bool? isPlaying,
    bool? isMuted,
  }) {
    return AudioMusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class AudioMusicCubit extends Cubit<AudioMusicState> {
  final AudioPlayer _player = AudioPlayer(playerId: 'background_music');

  AudioMusicCubit() : super(const AudioMusicState()) {
    _player.onPlayerStateChanged.listen((playerState) {
      emit(state.copyWith(isPlaying: playerState == PlayerState.playing));
    });
  }

  Future<void> play(String filePath) async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.2);
      await _player.play(AssetSource(filePath));
      emit(state.copyWith(isPlaying: true));
      debugPrint('Background music started: $filePath');
    } catch (e) {
      debugPrint('Error playing audio: $e');
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

  void toggleMute() {
    if (state.isMuted) {
      _player.setVolume(0.2);
      emit(state.copyWith(isMuted: false));
    } else {
      _player.setVolume(0);
      emit(state.copyWith(isMuted: true));
    }
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
