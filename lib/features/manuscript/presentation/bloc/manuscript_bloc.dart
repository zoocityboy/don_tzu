import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/manuscript_page.dart';
import '../../domain/repositories/manuscript_repository.dart';
import 'manuscript_event.dart';
import 'manuscript_state.dart';

class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final ManuscriptRepository _repository;

  ManuscriptBloc(this._repository) : super(const ManuscriptInitial()) {
    on<LoadManuscriptPages>(_onLoadManuscriptPages);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadManuscriptPages(
    LoadManuscriptPages event,
    Emitter<ManuscriptState> emit,
  ) async {
    emit(const ManuscriptLoading());
    try {
      final pages = await _repository.getManuscriptPages();
      emit(ManuscriptLoaded(pages: pages));
    } catch (e) {
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
      } catch (e) {
        // Silently fail - don't disrupt the user experience
      }
    }
  }

  Future<void> _sharePage(ManuscriptPage page) async {
    final text =
        '''${page.title}

"${page.quote}"

— The Art of Deal War

Shared from The Art of Deal War app''';

    await Share.share(text);
  }
}
