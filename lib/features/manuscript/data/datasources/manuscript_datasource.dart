import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';

abstract class ManuscriptDataSource {
  Future<Set<String>> getLikedPageIds();
  Future<List<ManuscriptPageModel>> getManuscriptPages(String language);
  Future<void> saveLikedPageIds(Set<String> ids);
}
