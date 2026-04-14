import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'intro_event.dart';
import 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final TtsCubit _ttsCubit;

  String _getCurrentLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return '${locale.languageCode}-${locale.countryCode ?? ''}';
  }

  IntroBloc({
    required TtsCubit ttsCubit,
  }) : _ttsCubit = ttsCubit,
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
      _ttsCubit.generateForLanguage(language, []);
      emit(const IntroReady());
    } catch (e) {
      emit(IntroError(e.toString()));
    }
  }
}
