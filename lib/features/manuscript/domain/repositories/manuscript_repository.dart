import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';

abstract class ManuscriptRepository {
  Future<List<ManuscriptPage>> getManuscriptPages(String language);
  Future<void> toggleLike(String pageId);
  Future<Set<String>> getLikedPageIds();
}
