import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'manuscript_event.dart';
import 'manuscript_state.dart';

class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final ManuscriptRepository _repository;

  ManuscriptBloc({
    required ManuscriptRepository repository,
  }) : _repository = repository,
       super(const ManuscriptInitial()) {
    on<LoadManuscriptPages>(_onLoadManuscriptPages);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadManuscriptPages(
    LoadManuscriptPages event,
    Emitter<ManuscriptState> emit,
  ) async {
    emit(const ManuscriptLoading());
    try {
      final language = event.language ?? 'en';
      final pages = await _repository.getManuscriptPages(language);

      await _repository.initTtsForLanguage(language);
      emit(ManuscriptLoaded(pages: pages));
    } on Exception catch (e) {
      emit(ManuscriptError(e.toString()));
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<ManuscriptState> emit,
  ) async {
    final currentState = state;
    if (currentState is ManuscriptLoaded) {
      try {
        await _repository.toggleLike(event.pageId);

        final updatedPages = currentState.pages.map((page) {
          if (page.id == event.pageId) {
            return page.copyWith(isLiked: !page.isLiked);
          }
          return page;
        }).toList();

        emit(currentState.copyWith(pages: updatedPages));
      } on Exception {
        // Silently fail - don't disrupt the user experience
      }
    }
  }
}
