import 'dart:ui';

import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';

class ManuscriptRepositoryImpl implements ManuscriptRepository {
  final ManuscriptLocalDataSource _localDataSource;
  Set<String> _likedPageIds = {};

  ManuscriptRepositoryImpl(this._localDataSource);

  Locale _parseLocale(String language) {
    if (language.contains('-')) {
      return Locale(language.split('-').first);
    }
    return Locale(language);
  }

  @override
  Future<List<ManuscriptPage>> getManuscriptPages(String language) async {
    final locale = _parseLocale(language);
    final l10n = lookupManuscriptLocalizations(locale);
    final models = await _localDataSource.getManuscriptPages(l10n);
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
}
