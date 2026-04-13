import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'intro_event.dart';
import 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final ManuscriptRepository _repository;

  String _getCurrentLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return '${locale.languageCode}-${locale.countryCode ?? ''}';
  }

  IntroBloc({
    required ManuscriptRepository repository,
  }) : _repository = repository,
       super(const IntroInitial()) {
    on<InitializeIntro>(_onInitialize);
  }

  Future<void> _onInitialize(
    InitializeIntro event,
    Emitter<IntroState> emit,
  ) async {
    emit(const IntroLoading());
    try {
      final language = event.language ?? _getCurrentLanguage();
      await _repository.initTtsForLanguage(language);
      emit(const IntroReady());
    } catch (e) {
      emit(IntroError(e.toString()));
    }
  }
}
