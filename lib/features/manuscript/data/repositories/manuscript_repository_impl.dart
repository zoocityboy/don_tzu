import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';

class ManuscriptRepositoryImpl implements ManuscriptRepository {
  final ManuscriptLocalDataSource _localDataSource;
  Set<String> _likedPageIds = {};

  ManuscriptRepositoryImpl(this._localDataSource);

  @override
  Future<List<ManuscriptPage>> getManuscriptPages(String language) async {
    final models = await _localDataSource.getManuscriptPages(language);
    _likedPageIds = await _localDataSource.getLikedPageIds();

    return models.map((model) {
      return ManuscriptPage(
        id: model.id,
        title: model.title,
        quote: model.quote,
        imageAsset: model.imageAsset,
        isLiked: _likedPageIds.contains(model.id),
      );
    }).toList();
  }

  @override
  Future<void> toggleLike(String pageId) async {
    if (_likedPageIds.contains(pageId)) {
      _likedPageIds.remove(pageId);
    } else {
      _likedPageIds.add(pageId);
    }
    await _localDataSource.saveLikedPageIds(_likedPageIds);
  }

  @override
  Future<Set<String>> getLikedPageIds() async {
    return _likedPageIds;
  }

  @override
  List<MapEntry<String, String>> getChaptersForTts(String language) {
    return _localDataSource.getChaptersForTts(language);
  }

  @override
  Future<bool> initTtsForLanguage(String languageCode) async {
    return _localDataSource.initTtsForLanguage(languageCode);
  }

  @override
  Future<void> playTtsChapter(String chapterId, {String? languageCode}) async {
    await _localDataSource.playTtsChapter(
      chapterId,
      languageCode: languageCode,
    );
  }

  @override
  Future<void> stopTts() async {
    await _localDataSource.stopTts();
  }

  @override
  Future<void> pauseTts() async {
    await _localDataSource.pauseTts();
  }

  @override
  bool isTtsReadyForLanguage(String languageCode) {
    return _localDataSource.isTtsReadyForLanguage(languageCode);
  }
}
