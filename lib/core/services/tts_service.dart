import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isMuted = false;
  String? _currentText;

  bool get isSpeaking => _isSpeaking;
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _tts.stop();
      _isSpeaking = false;
    }
  }

  Future<void> init() async {
    if (_isInitialized) return;

    final languageCode = Platform.localeName.split('_').first;
    String language;

    switch (languageCode) {
      case 'cs':
        language = 'cs-CZ';
      case 'de':
        language = 'de-DE';
      case 'hu':
        language = 'hu-HU';
      case 'pl':
        language = 'pl-PL';
      case 'sk':
        language = 'sk-SK';
      default:
        language = 'en-US';
    }

    await _tts.setLanguage(language);
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(0.85);
    await _tts.setVolume(1.0);

    final voices = await _tts.getVoices;
    for (final voice in voices) {
      if (voice['name'].toString().toLowerCase().contains('male') ||
          voice['name'].toString().toLowerCase().contains('daniel') ||
          voice['name'].toString().toLowerCase().contains('zira')) {
        if (voice['locale'].toString().startsWith(language.split('-').first)) {
          await _tts.setVoice({'name': voice['name'], 'locale': language});
          break;
        }
      }
    }

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentText = null;
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
      _currentText = null;
    });

    _tts.setErrorHandler((msg) {
      debugPrint('TTS error: $msg');
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await init();
    if (_isMuted) return;

    if (_isSpeaking && _currentText == text) return;

    await _tts.stop();
    _currentText = text;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
    _currentText = null;
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  void dispose() {
    _tts.stop();
  }
}
