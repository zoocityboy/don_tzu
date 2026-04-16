import 'dart:convert';

import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:http/http.dart' as http;

const String _likedBoxName = 'liked_pages';
const String _likedPageIdsKey = 'ids';

class ManuscriptRemoteDataSourceImpl implements ManuscriptDataSource {
  static const String _baseUrl =
      'https://github.com/zoocityboy/don-tzu/raw/refs/heads/main/';
  static const String _folder = '_data';

  final Map<String, List<ManuscriptPageModel>> _cache = {};
  final http.Client _client;

  ManuscriptRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  String _parseLanguage(String language) {
    if (language.contains('-')) {
      return language.split('-').first;
    }
    return language;
  }

  String _getImageUrl(int id) => '$_baseUrl/$_folder/images/$id.webp';

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
    final lang = _parseLanguage(language);

    if (_cache.containsKey(lang) && _cache[lang]!.isNotEmpty) {
      return _cache[lang]!;
    }

    try {
      final models = await _downloadQuotes(lang);
      if (models.isNotEmpty) {
        _cache[lang] = models;
        return models;
      }
    } catch (e) {}

    return [];
  }

  Future<List<ManuscriptPageModel>> _downloadQuotes(String language) async {
    final url = '$_baseUrl/$_folder/quotes/$language/quotes.json';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) {
          final map = item as Map<String, dynamic>;
          return ManuscriptPageModel(
            id: map['id'].toString(),
            title: map['title'] as String,
            quote: map['quote'] as String,
            imageAsset: _getImageUrl(map['id'] as int),
            audio: '$_baseUrl/_data/tts/$language/${map['id']}.mp3',
          );
        }).toList();
      }
    } catch (e) {}
    return [];
  }

  void clearCache() {
    _cache.clear();
  }
}
