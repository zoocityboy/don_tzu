import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/core/services/data_service.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';

const String _likedBoxName = 'liked_pages';
const String _likedPageIdsKey = 'ids';

class ManuscriptRemoteDataSource implements ManuscriptLocalDataSource {
  final TtsCubit _ttsCubit;

  final Map<String, List<ManuscriptPageModel>> _cache = {};

  static const Map<String, String> _jsonAssets = {
    'en': 'assets/data/en/quotes.json',
    'cs': 'assets/data/cs/quotes.json',
    'de': 'assets/data/de/quotes.json',
    'hu': 'assets/data/hu/quotes.json',
    'pl': 'assets/data/pl/quotes.json',
    'sk': 'assets/data/sk/quotes.json',
    'ja': 'assets/data/ja/quotes.json',
    'zh': 'assets/data/zh/quotes.json',
  };

  ManuscriptRemoteDataSource({
    required TtsCubit ttsCubit,
  }) : _ttsCubit = ttsCubit;

  Future<Box> get _likedBox => Hive.openBox(_likedBoxName);

  @override
  Future<Set<String>> getLikedPageIds() async {
    final box = await _likedBox;
    final List<dynamic> ids =
        box.get(_likedPageIdsKey, defaultValue: <dynamic>[]) as List<dynamic>;
    return ids.map((e) => e.toString()).toSet();
  }

  @override
  Future<void> saveLikedPageIds(Set<String> ids) async {
    final box = await _likedBox;
    await box.put(_likedPageIdsKey, ids.toList());
  }

  @override
  Future<List<ManuscriptPageModel>> getManuscriptPages(String language) async {
    final parsedLanguage = _parseLanguage(language);

    // Return from cache if available
    if (_cache.containsKey(parsedLanguage) &&
        _cache[parsedLanguage]!.isNotEmpty) {
      return _cache[parsedLanguage]!;
    }

    // Try to download from GitHub first
    try {
      final quotes = await DataService.getQuotes(parsedLanguage);
      if (quotes.isNotEmpty) {
        final models = quotes
            .map(
              (quote) => ManuscriptPageModel(
                id: quote.id.toString(),
                title: quote.title,
                quote: quote.quote,
                imageAsset: DataService.getImageUrl(quote.id),
              ),
            )
            .toList();

        _cache[parsedLanguage] = models;
        return models;
      }
    } catch (e) {
      // Fallback to local JSON if download fails
    }

    // Fallback to local assets
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
              id: item['id'].toString(),
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
      r'\{"id":\s*(\d+),.*?"title":\s*"([^"]+)",\s*"quote":\s*"([^"]+)",\s*"image":\s*"([^"]+)"\}',
    );
    for (final match in regex.allMatches(jsonString)) {
      result.add({
        'id': int.tryParse(match.group(1) ?? '1') ?? 1,
        'title': match.group(2),
        'quote': match.group(3),
        'image': match.group(4),
      });
    }
    return result;
  }

  @override
  List<MapEntry<String, String>> getChaptersForTts(String language) {
    final pages = _cache[_parseLanguage(language)] ?? [];
    return pages.map((page) => MapEntry(page.id, page.quote)).toList();
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
    await _ttsCubit.generateForLanguage(languageCode, texts);
    return _ttsCubit.isLanguageReady(languageCode);
  }

  @override
  String? getAudioFilePath(String chapterId, String languageCode) {
    return _ttsCubit.getFilePath(chapterId, languageCode);
  }

  @override
  Future<void> playTtsChapter(String chapterId, {String? languageCode}) async {
    await _ttsCubit.play(chapterId, languageCode ?? 'en');
  }

  @override
  Future<void> stopTts() async {
    await _ttsCubit.stop();
  }

  @override
  Future<void> pauseTts() async {
    await _ttsCubit.pause();
  }

  @override
  bool isTtsReadyForLanguage(String languageCode) {
    return _ttsCubit.isLanguageReady(languageCode);
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
}
