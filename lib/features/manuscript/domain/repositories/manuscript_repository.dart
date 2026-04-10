import '../entities/manuscript_page.dart';

abstract class ManuscriptRepository {
  Future<List<ManuscriptPage>> getManuscriptPages();
  Future<void> toggleLike(String pageId);
  Future<Set<String>> getLikedPageIds();
}
