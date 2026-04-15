import 'dart:convert';
import 'dart:io';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// GitHub-based data service for downloading app content.
/// Data is downloaded from: https://github.com/[owner]/[repo]/releases/tag/[version]
class DataService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/zoocityboy/don-tzu/main';

  static final Map<String, List<ManuscriptQuote>> _quotesCache = {};

  /// Get current app version from pubspec.yaml
  static String get appVersion => '1.0.0';

  /// Get quotes for a language - downloads if needed
  static Future<List<ManuscriptQuote>> getQuotes(String language) async {
    final lang = _parseLanguage(language);

    // Return cached if available
    if (_quotesCache.containsKey(lang)) {
      return _quotesCache[lang]!;
    }

    // Download from GitHub
    try {
      final quotes = await _downloadQuotes(lang);
      _quotesCache[lang] = quotes;
      return quotes;
    } catch (e) {
      AppLogger.error('Failed to download quotes for: $lang', e);
      // Return empty list - caller should handle fallback
      return [];
    }
  }

  /// Download quotes from GitHub
  static Future<List<ManuscriptQuote>> _downloadQuotes(String language) async {
    final url = '$_baseUrl/data/$language/quotes.json';
    AppLogger.info('Downloading quotes from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => ManuscriptQuote.fromJson(item)).toList();
      } else {
        AppLogger.warning('Failed to download quotes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      AppLogger.error('Error downloading quotes: $e');
      return [];
    }
  }

  /// Get image URL for a quote
  static String getImageUrl(int id) {
    return '$_baseUrl/data/images/$id.webp';
  }

  /// Get TTS audio URL for a quote
  static String getAudioUrl(String language, int id) {
    return '$_baseUrl/data/$language/$id.mp3';
  }

  /// Get background music URL
  static String getBackgroundMusicUrl() {
    return '$_baseUrl/data/music/background.mp3';
  }

  /// Check if data is available for a language
  static Future<bool> isLanguageSupported(String language) async {
    final lang = _parseLanguage(language);
    final url = '$_baseUrl/data/$lang/quotes.json';

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get supported languages from GitHub
  static Future<List<String>> getSupportedLanguages() async {
    // Hardcoded for now - could be fetched from a manifest.json
    return const ['en', 'cs', 'de', 'hu', 'pl', 'sk', 'ja', 'zh'];
  }

  /// Download and cache audio file for offline use
  static Future<String?> downloadAudio(String language, int quoteId) async {
    final lang = _parseLanguage(language);
    final url = getAudioUrl(lang, quoteId);

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/$lang');
      await audioDir.create(recursive: true);

      final filePath = '${audioDir.path}/$quoteId.mp3';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath; // Already cached
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        AppLogger.info('Cached audio: $filePath');
        return filePath;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to download audio: $quoteId', e);
      return null;
    }
  }

  /// Clear all cached data
  static void clearCache() {
    _quotesCache.clear();
  }

  /// Parse language code (e.g., 'en-US' -> 'en')
  static String _parseLanguage(String language) {
    if (language.contains('-')) {
      return language.split('-').first;
    }
    return language;
  }
}

/// Model for a manuscript quote
class ManuscriptQuote {
  final int id;
  final String title;
  final String quote;
  final String imageAsset;

  const ManuscriptQuote({
    required this.id,
    required this.title,
    required this.quote,
    this.imageAsset = '',
  });

  factory ManuscriptQuote.fromJson(Map<String, dynamic> json) {
    return ManuscriptQuote(
      id: json['id'] as int,
      title: json['title'] as String,
      quote: json['quote'] as String,
      imageAsset: json['image'] as String? ?? '',
    );
  }
}
