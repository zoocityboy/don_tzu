import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';

class GetChaptersForTtsUseCase {
  final ManuscriptRepository _repository;

  GetChaptersForTtsUseCase(this._repository);

  List<MapEntry<String, String>> call(String language) {
    return _repository.getChaptersForTts(language);
  }
}

class InitTtsForLanguageUseCase {
  final ManuscriptRepository _repository;

  InitTtsForLanguageUseCase(this._repository);

  Future<bool> call(String languageCode) {
    return _repository.initTtsForLanguage(languageCode);
  }
}

class PlayTtsChapterUseCase {
  final ManuscriptRepository _repository;

  PlayTtsChapterUseCase(this._repository);

  Future<void> call(String chapterId, {String? languageCode}) {
    return _repository.playTtsChapter(chapterId, languageCode: languageCode);
  }
}

class StopTtsUseCase {
  final ManuscriptRepository _repository;

  StopTtsUseCase(this._repository);

  Future<void> call() {
    return _repository.stopTts();
  }
}

class PauseTtsUseCase {
  final ManuscriptRepository _repository;

  PauseTtsUseCase(this._repository);

  Future<void> call() {
    return _repository.pauseTts();
  }
}

class IsTtsReadyUseCase {
  final ManuscriptRepository _repository;

  IsTtsReadyUseCase(this._repository);

  bool call(String languageCode) {
    return _repository.isTtsReadyForLanguage(languageCode);
  }
}
