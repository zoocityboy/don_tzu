import 'dart:convert';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/core/services/data_service.dart';
import 'package:flutter/services.dart';

class LocalDataService implements DataService {
  static const Map<String, String> _assetPaths = {
    'en': 'assets/quotes/en/quotes.json',
    'cs': 'assets/quotes/cs/quotes.json',
    'de': 'assets/quotes/de/quotes.json',
    'hu': 'assets/quotes/hu/quotes.json',
    'pl': 'assets/quotes/pl/quotes.json',
    'sk': 'assets/quotes/sk/quotes.json',
    'ja': 'assets/quotes/ja/quotes.json',
    'zh': 'assets/quotes/zh/quotes.json',
  };

  static const List<String> _supportedLanguages = [
    'en',
    'cs',
    'de',
    'hu',
    'pl',
    'sk',
    'ja',
    'zh',
  ];

  @override
  String getImageUrl(int id) {
    return 'assets/images/$id.webp';
  }

  @override
  String getAudioUrl(String language, int id) {
    return 'assets/tts/$language/$id.mp3';
  }

  @override
  String getBackgroundMusicUrl() {
    return 'assets/sound/background.mp3';
  }

  @override
  Future<List<ManuscriptQuote>> getQuotes(String language) async {
    final lang = DataService.parseLanguage(language);
    final path = _assetPaths[lang];

    if (path == null) {
      AppLogger.warning('No asset path for language: $lang');
      return [];
    }

    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => ManuscriptQuote.fromJson(item)).toList();
    } catch (e) {
      AppLogger.error('Failed to load local quotes for: $lang', e);
      return [];
    }
  }

  @override
  Future<bool> isLanguageSupported(String language) async {
    final lang = DataService.parseLanguage(language);
    return _supportedLanguages.contains(lang);
  }

  @override
  Future<List<String>> getSupportedLanguages() async {
    return _supportedLanguages;
  }

  @override
  Future<String?> downloadAudio(String language, int quoteId) async {
    return null;
  }
}
