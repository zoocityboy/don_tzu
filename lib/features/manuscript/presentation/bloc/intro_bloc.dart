import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'intro_event.dart';
import 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final TtsService _ttsService;
  final ManuscriptLocalDataSource _dataSource;

  String _getCurrentLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return '${locale.languageCode}-${locale.countryCode ?? ''}';
  }

  IntroBloc(this._ttsService, this._dataSource) : super(const IntroInitial()) {
    on<InitializeIntro>(_onInitialize);
  }

  Future<void> _onInitialize(
    InitializeIntro event,
    Emitter<IntroState> emit,
  ) async {
    emit(const IntroLoading());
    try {
      final language = event.language ?? _getCurrentLanguage();
      final localeCode = language.contains('-')
          ? language.split('-').first
          : language;
      final locale = Locale(localeCode);
      final l10n = lookupManuscriptLocalizations(locale);
      final chapters = _dataSource.getChaptersForTts(l10n);
      await _ttsService.initWithChapters(chapters);
      emit(const IntroReady());
    } catch (e) {
      emit(IntroError(e.toString()));
    }
  }
}
