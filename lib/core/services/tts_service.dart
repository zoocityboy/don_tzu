import 'dart:io';
import 'package:edge_tts/edge_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final Map<String, Map<String, String>> _audioFiles = {};
  final Map<String, bool> _initialized = {};

  Future<void> generate(List<TtsTextModel> texts) async {
    final groupedByLanguage = <String, List<TtsTextModel>>{};
    for (final text in texts) {
      final lang = text.language.split('-').first;
      groupedByLanguage.putIfAbsent(lang, () => []).add(text);
    }

    for (final entry in groupedByLanguage.entries) {
      await _generateForLanguage(entry.key, entry.value);
    }
  }

  Future<void> generateForLanguage(
    String language,
    List<TtsTextModel> texts,
  ) async {
    await _generateForLanguage(language.split('-').first, texts);
  }

  bool isLanguageReady(String language) {
    return _initialized[language.split('-').first] ?? false;
  }

  String? getFilePath(String chapterId, String language) {
    final lang = language.split('-').first;
    return _audioFiles[lang]?[chapterId];
  }

  Future<void> _generateForLanguage(
    String language,
    List<TtsTextModel> texts,
  ) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/$language');
      await audioDir.create(recursive: true);

      final voice = await _findVoice(language);
      final audioFiles = <String, String>{};

      for (final text in texts) {
        final filePath = '${audioDir.path}/${text.id}.mp3';
        if (!File(filePath).existsSync()) {
          await _synthesize(text.text, filePath, voice, text.language);
        }
        audioFiles[text.id] = filePath;
      }

      _audioFiles[language] = audioFiles;
      _initialized[language] = true;
      debugPrint('TTS generated for language: $language');
    } catch (e) {
      debugPrint('TTS error for $language: $e');
    }
  }

  Future<String> _findVoice(String language) async {
    final voices = await listVoices();
    try {
      return voices.firstWhere((v) => v.locale.startsWith(language)).shortName;
    } catch (_) {
      return voices.first.shortName;
    }
  }

  Future<void> _synthesize(
    String text,
    String filePath,
    String voice,
    String language,
  ) async {
    final tts = Communicate(
      text: text,
      voice: voice,
      rate: '-10%',
      pitch: '-20Hz',
      volume: '+0%',
    );
    await tts.save(filePath);
    _initialized[language] = true;
  }
}
