abstract class DataService {
  // static const String _baseUrl =
  //     'https://raw.githubusercontent.com/zoocityboy/don-tzu/main';

  // static final Map<String, List<ManuscriptQuote>> _quotesCache = {};

  // static String get baseUrl => _baseUrl;

  // static Map<String, List<ManuscriptQuote>> get quotesCache => _quotesCache;

  // static void clearCache() {
  //   _quotesCache.clear();
  // }

  static String parseLanguage(String language) {
    if (language.contains('-')) {
      return language.split('-').first;
    }
    return language;
  }

  String getImageUrl(int id);

  String getAudioUrl(String language, int id);

  String getBackgroundMusicUrl();

  Future<List<ManuscriptQuote>> getQuotes(String language);

  Future<bool> isLanguageSupported(String language);

  Future<List<String>> getSupportedLanguages();

  Future<String?> downloadAudio(String language, int quoteId);
}

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
