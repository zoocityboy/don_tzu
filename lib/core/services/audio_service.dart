import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  Future<void> playBackgroundMusic() async {
    if (_isMuted) return;
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
    if (!_isMuted) {
      await _player.resume();
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _player.pause();
    } else {
      _player.resume();
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
