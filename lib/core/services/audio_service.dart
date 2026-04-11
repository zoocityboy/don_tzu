import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer(playerId: 'background_music');
  final AudioPlayer _ttsPlayer = AudioPlayer(playerId: 'tts_player')
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.mediaPlayer)
    ..setVolume(1);

  bool get isMuted => _player.volume == 0;

  Future<void> playBackgroundMusic() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.2);
      await _player.play(AssetSource('sound/walen-lonely-samurai.mp3'));
      debugPrint('Background music started');
    } on Exception catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    if (!isMuted) {
      await _player.resume();
    }
  }

  void toggleMute() {
    if (isMuted) {
      _player.setVolume(0.2);
      _player.resume();
    } else {
      _player.setVolume(0);
      _player.pause();
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
