import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:art_of_deal_war/core/services/audio_player_service.dart';

class TtsAudioPlayer implements AudioPlayerService {
  static final TtsAudioPlayer _instance = TtsAudioPlayer._internal();
  factory TtsAudioPlayer() => _instance;
  TtsAudioPlayer._internal();

  final AudioPlayer _player = AudioPlayer(playerId: 'tts_player')
    ..setReleaseMode(ReleaseMode.stop)
    ..setPlayerMode(PlayerMode.mediaPlayer);

  @override
  bool get isPlaying => _player.state == PlayerState.playing;

  @override
  bool get isMuted => _player.volume == 0;

  @override
  Future<void> play(String filePath) async {
    if (isMuted) return;

    await stop();

    try {
      final source = DeviceFileSource(
        filePath,
        mimeType: filePath.endsWith('.mp3') ? 'audio/mpeg' : 'audio/wav',
      );
      _player.play(source, mode: PlayerMode.mediaPlayer);
    } on Exception catch (e) {
      debugPrint('TTS play error: $filePath $e');
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } on Exception catch (_) {}
  }

  @override
  void mute() {
    _player.setVolume(0);
  }

  @override
  void unmute() {
    _player.setVolume(1);
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
