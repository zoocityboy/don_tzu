import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';

class ManuscriptRepositoryImpl implements ManuscriptRepository {
  final ManuscriptDataSource _dataSource;
  Set<String> _likedPageIds = {};

  ManuscriptRepositoryImpl(this._dataSource);

  @override
  Future<List<ManuscriptPage>> getManuscriptPages(String language) async {
    final models = await _dataSource.getManuscriptPages(language);
    _likedPageIds = await _dataSource.getLikedPageIds();

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
    await _dataSource.saveLikedPageIds(_likedPageIds);
  }

  @override
  Future<Set<String>> getLikedPageIds() async {
    return _likedPageIds;
  }
}
