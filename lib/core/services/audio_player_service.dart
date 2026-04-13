abstract class AudioPlayerService {
  bool get isPlaying;
  bool get isMuted;

  Future<void> play(String filePath);
  Future<void> pause();
  Future<void> stop();
  void mute();
  void unmute();
  void toggleMute();
}
