import 'dart:convert';
import 'dart:io';

import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/core/services/data_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RemoteDataService implements DataService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/zoocityboy/don-tzu/refs/heads/master/';
  static const _folder = '_data';
  final Map<String, List<ManuscriptQuote>> _quotesCache = {};
  Map<String, List<ManuscriptQuote>> get quotesCache => _quotesCache;

  void clearCache() {
    _quotesCache.clear();
  }

  @override
  String getImageUrl(int id) {
    return '$_baseUrl/$_folder/images/$id.webp';
  }

  @override
  String getAudioUrl(String language, int id) {
    final lang = DataService.parseLanguage(language);
    return '$_baseUrl/$_folder/tts/$lang/$id.mp3';
  }

  @override
  String getBackgroundMusicUrl() {
    return '$_baseUrl/$_folder/music/background.mp3';
  }

  @override
  Future<List<ManuscriptQuote>> getQuotes(String language) async {
    final lang = DataService.parseLanguage(language);

    if (_quotesCache.containsKey(lang)) {
      return _quotesCache[lang]!;
    }

    try {
      final quotes = await _downloadQuotes(lang);
      _quotesCache[lang] = quotes;
      return quotes;
    } catch (e) {
      AppLogger.error('Failed to download quotes for: $lang', e);
      return [];
    }
  }

  Future<List<ManuscriptQuote>> _downloadQuotes(String language) async {
    final url = '$_baseUrl/$_folder/quotes/$language/quotes.json';
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

  @override
  Future<bool> isLanguageSupported(String language) async {
    final lang = DataService.parseLanguage(language);
    final url = '$_baseUrl/$_folder/quotes/$lang/quotes.json';

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getSupportedLanguages() async {
    return const ['en', 'cs', 'de', 'hu', 'pl', 'sk', 'ja', 'zh'];
  }

  @override
  Future<String?> downloadAudio(String language, int quoteId) async {
    final lang = DataService.parseLanguage(language);
    final url = getAudioUrl(lang, quoteId);

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docsDir.path}/tts_audio/$lang');
      await audioDir.create(recursive: true);

      final filePath = '${audioDir.path}/$quoteId.mp3';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
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
}
