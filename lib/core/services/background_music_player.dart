import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:art_of_deal_war/core/services/audio_player_service.dart';

class BackgroundMusicPlayer implements AudioPlayerService {
  static final BackgroundMusicPlayer _instance =
      BackgroundMusicPlayer._internal();
  factory BackgroundMusicPlayer() => _instance;
  BackgroundMusicPlayer._internal();

  final AudioPlayer _player = AudioPlayer(playerId: 'background_music');

  @override
  bool get isPlaying => _player.state == PlayerState.playing;

  @override
  bool get isMuted => _player.volume == 0;

  @override
  Future<void> play(String filePath) async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.2);
      await _player.play(AssetSource(filePath));
      debugPrint('Background music started: $filePath');
    } on Exception catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  void mute() {
    _player.setVolume(0);
  }

  @override
  void unmute() {
    _player.setVolume(0.2);
  }

  @override
  void toggleMute() {
    if (isMuted) {
      unmute();
    } else {
      mute();
    }
  }

  void dispose() {
    _player.dispose();
  }
}
