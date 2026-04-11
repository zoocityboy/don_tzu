import 'dart:ui';

import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'manuscript_event.dart';
import 'manuscript_state.dart';

class ManuscriptBloc extends Bloc<ManuscriptEvent, ManuscriptState> {
  final ManuscriptRepository _repository;
  final TtsService _ttsService;
  final ManuscriptLocalDataSource _dataSource;

  String _getCurrentLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return '${locale.languageCode}-${locale.countryCode ?? ''}';
  }

  ManuscriptBloc(
    this._repository,
    this._ttsService,
    this._dataSource,
  ) : super(const ManuscriptInitial()) {
    on<LoadManuscriptPages>(_onLoadManuscriptPages);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadManuscriptPages(
    LoadManuscriptPages event,
    Emitter<ManuscriptState> emit,
  ) async {
    emit(const ManuscriptLoading());
    try {
      final language = event.language ?? _getCurrentLanguage();
      final pages = await _repository.getManuscriptPages(language);

      final localeCode = language.contains('-')
          ? language.split('-').first
          : language;
      final locale = Locale(localeCode);
      final l10n = lookupManuscriptLocalizations(locale);
      final chapters = _dataSource.getChaptersForTts(l10n);
      await _ttsService.initWithChapters(chapters);
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
