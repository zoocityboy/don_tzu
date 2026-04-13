import 'package:flutter/services.dart';
import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/core/services/pocketbase_service.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';
import 'package:art_of_deal_war/core/services/tts_audio_player.dart';

class ManuscriptRemoteDataSource implements ManuscriptLocalDataSource {
  final PocketBaseService _pocketBaseService;
  final TtsService _ttsService;
  final TtsAudioPlayer _ttsAudioPlayer;

  final Map<String, List<ManuscriptPageModel>> _cache = {};

  static const Map<String, String> _jsonAssets = {
    'en': 'assets/data/manuscripts_en.json',
    'cs': 'assets/data/manuscripts_cs.json',
    'de': 'assets/data/manuscripts_de.json',
    'hu': 'assets/data/manuscripts_hu.json',
    'pl': 'assets/data/manuscripts_pl.json',
    'sk': 'assets/data/manuscripts_sk.json',
  };

  ManuscriptRemoteDataSource({
    required PocketBaseService pocketBaseService,
    required TtsService ttsService,
    required TtsAudioPlayer ttsAudioPlayer,
  }) : _pocketBaseService = pocketBaseService,
       _ttsService = ttsService,
       _ttsAudioPlayer = ttsAudioPlayer;

  @override
  Future<Set<String>> getLikedPageIds() async {
    return {};
  }

  @override
  Future<List<ManuscriptPageModel>> getManuscriptPages(String language) async {
    final parsedLanguage = _parseLanguage(language);

    if (_cache.containsKey(parsedLanguage) &&
        _cache[parsedLanguage]!.isNotEmpty) {
      return _cache[parsedLanguage]!;
    }

    try {
      final records = await _pocketBaseService.getManuscriptsByLanguage(
        parsedLanguage,
      );

      if (records.isNotEmpty) {
        final models = records
            .map(
              (record) => ManuscriptPageModel(
                id: record.id,
                title: record.data['title'] as String,
                quote: record.data['quote'] as String,
                imageAsset:
                    record.data['image'] as String? ?? 'assets/images/1.webp',
              ),
            )
            .toList();

        _cache[parsedLanguage] = models;
        return models;
      }
    } catch (e) {
      // Fallback to local JSON
    }

    return _loadFromJson(parsedLanguage);
  }

  Future<List<ManuscriptPageModel>> _loadFromJson(String language) async {
    if (_cache.containsKey(language)) {
      return _cache[language]!;
    }

    final jsonPath = _jsonAssets[language] ?? _jsonAssets['en']!;
    try {
      final jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonList = _parseJsonList(jsonString);
      final models = jsonList
          .map(
            (item) => ManuscriptPageModel(
              id: item['id'] as String,
              title: item['title'] as String,
              quote: item['quote'] as String,
              imageAsset: item['image'] as String,
            ),
          )
          .toList();
      _cache[language] = models;
      return models;
    } catch (e) {
      return [];
    }
  }

  List<dynamic> _parseJsonList(String jsonString) {
    final List<dynamic> result = [];
    final regex = RegExp(
      r'\{"id":\s*"(\d+)",\s*"title":\s*"([^"]+)",\s*"quote":\s*"([^"]+)",\s*"image":\s*"([^"]+)"\}',
    );
    for (final match in regex.allMatches(jsonString)) {
      result.add({
        'id': match.group(1),
        'title': match.group(2),
        'quote': match.group(3),
        'image': match.group(4),
      });
    }
    return result;
  }

  @override
  Future<void> saveLikedPageIds(Set<String> ids) async {}

  @override
  List<MapEntry<String, String>> getChaptersForTts(String language) {
    final pages = _cache[_parseLanguage(language)] ?? [];
    return pages.map((page) => MapEntry(page.id, page.quote)).toList();
  }

  List<TtsTextModel> getTtsTexts(String language) {
    final pages = _cache[_parseLanguage(language)] ?? [];
    return pages
        .map(
          (p) => TtsTextModel(
            id: p.id,
            text: p.quote,
            language: language,
          ),
        )
        .toList();
  }

  String _parseLanguage(String language) {
    if (language.contains('-')) {
      return language.split('-').first;
    }
    return language;
  }

  void clearCache() {
    _cache.clear();
  }

  @override
  Future<bool> initTtsForLanguage(String languageCode) async {
    final pages = _cache[_parseLanguage(languageCode)] ?? [];
    final texts = pages
        .map(
          (p) => TtsTextModel(
            id: p.id,
            text: p.quote,
            language: languageCode,
          ),
        )
        .toList();
    await _ttsService.generateForLanguage(languageCode, texts);
    return _ttsService.isLanguageReady(languageCode);
  }

  @override
  String? getAudioFilePath(String chapterId, String languageCode) {
    return _ttsService.getFilePath(chapterId, languageCode);
  }

  @override
  Future<void> playTtsChapter(String chapterId, {String? languageCode}) async {
    final filePath = _ttsService.getFilePath(chapterId, languageCode ?? 'en');
    if (filePath != null) {
      await _ttsAudioPlayer.play(filePath);
    }
  }

  @override
  Future<void> stopTts() async {
    await _ttsAudioPlayer.stop();
  }

  @override
  Future<void> pauseTts() async {
    await _ttsAudioPlayer.pause();
  }

  @override
  bool isTtsReadyForLanguage(String languageCode) {
    return _ttsService.isLanguageReady(languageCode);
  }
}
