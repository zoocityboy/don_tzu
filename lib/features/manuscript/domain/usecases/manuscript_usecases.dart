import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';

class ToggleLikeUseCase {
  final ManuscriptRepository _repository;

  ToggleLikeUseCase(this._repository);

  Future<void> call(String pageId) {
    return _repository.toggleLike(pageId);
  }
}

class GetLikedPagesUseCase {
  final ManuscriptRepository _repository;

  GetLikedPagesUseCase(this._repository);

  Future<Set<String>> call() {
    return _repository.getLikedPageIds();
  }
}
