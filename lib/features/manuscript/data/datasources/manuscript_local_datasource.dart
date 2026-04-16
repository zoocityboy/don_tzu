import 'dart:convert';

import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

const String _likedBoxName = 'liked_pages';
const String _likedPageIdsKey = 'ids';

class ManuscriptLocalDataSourceImpl implements ManuscriptDataSource {
  static const Map<String, String> _assetPaths = {
    'en': 'assets/quotes/en.json',
    'cs': 'assets/quotes/cs.json',
    'de': 'assets/quotes/de.json',
    'hu': 'assets/quotes/hu.json',
    'pl': 'assets/quotes/pl.json',
    'sk': 'assets/quotes/sk.json',
    'ja': 'assets/quotes/ja.json',
    'zh': 'assets/quotes/zh.json',
  };

  final Map<String, List<ManuscriptPageModel>> _cache = {};

  String _parseLanguage(String language) {
    if (language.contains('-')) {
      return language.split('-').first;
    }
    return language;
  }

  String _getImageUrl(int id) => 'assets/images/$id.webp';

  String _getAudioUrl(String language, int id) =>
      'assets/tts/$language/$id.mp3';

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
      final models = await _loadFromAssets(lang);
      if (models.isNotEmpty) {
        _cache[lang] = models;
        return models;
      }
    } catch (e) {}
    return [];
  }

  Future<List<ManuscriptPageModel>> _loadFromAssets(String language) async {
    final path = _assetPaths[language];
    if (path == null) {
      return [];
    }

    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) {
        final map = item as Map<String, dynamic>;
        return ManuscriptPageModel(
          id: map['id'].toString(),
          title: map['title'] as String,
          quote: map['quote'] as String,
          imageAsset: _getImageUrl(map['id'] as int),
          audio: _getAudioUrl(language, map['id'] as int),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
