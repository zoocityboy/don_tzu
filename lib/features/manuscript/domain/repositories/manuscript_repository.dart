import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';

abstract class ManuscriptRepository {
  Future<List<ManuscriptPage>> getManuscriptPages(String language);
  Future<void> toggleLike(String pageId);
  Future<Set<String>> getLikedPageIds();
  List<MapEntry<String, String>> getChaptersForTts(String language);
  Future<bool> initTtsForLanguage(String languageCode);
  Future<void> playTtsChapter(String chapterId, {String? languageCode});
  Future<void> stopTts();
  Future<void> pauseTts();
  bool isTtsReadyForLanguage(String languageCode);
}
