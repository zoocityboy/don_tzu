import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/get_manuscript_pages_usecase.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/manuscript_usecases.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';
import 'manuscript_event.dart';
import 'manuscript_state.dart';

class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final GetManuscriptPagesUseCase _getManuscriptPagesUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final TtsCubit _ttsCubit;

  @override
  void onChange(Change<ManuscriptState> change) {
    super.onChange(change);
    AppLogger.debug(
      'ManuscriptBloc state changed: ${change.currentState} -> ${change.nextState}',
    );
  }

  ManuscriptBloc({
    required GetManuscriptPagesUseCase getManuscriptPagesUseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
    required TtsCubit ttsCubit,
  }) : _getManuscriptPagesUseCase = getManuscriptPagesUseCase,
       _toggleLikeUseCase = toggleLikeUseCase,
       _ttsCubit = ttsCubit,
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
      final pages = await _getManuscriptPagesUseCase.call(language);

      final texts = pages
          .map((p) => TtsTextModel(id: p.id, text: p.quote, language: language))
          .toList();
      await _ttsCubit.generateForLanguage(language, texts);
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
        await _toggleLikeUseCase.call(event.pageId);

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
