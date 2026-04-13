import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';

abstract class ManuscriptLocalDataSource {
  Future<Set<String>> getLikedPageIds();
  Future<List<ManuscriptPageModel>> getManuscriptPages(String language);
  List<MapEntry<String, String>> getChaptersForTts(String language);
  Future<void> saveLikedPageIds(Set<String> ids);
  Future<bool> initTtsForLanguage(String languageCode);
  String? getAudioFilePath(String chapterId, String languageCode);
  bool isTtsReadyForLanguage(String languageCode);
  Future<void> playTtsChapter(String chapterId, {String? languageCode});
  Future<void> stopTts();
  Future<void> pauseTts();
}
