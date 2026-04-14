import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';

class GetManuscriptPagesUseCase {
  final ManuscriptRepository _repository;

  GetManuscriptPagesUseCase(this._repository);

  Future<List<ManuscriptPage>> call(String language) {
    return _repository.getManuscriptPages(language);
  }
}
