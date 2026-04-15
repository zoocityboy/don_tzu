import 'package:flutter_bloc/flutter_bloc.dart';
import 'intro_event.dart';
import 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc() : super(const IntroInitial()) {
    on<InitializeIntro>(_onInitialize);
  }

  Future<void> _onInitialize(
    InitializeIntro event,
    Emitter<IntroState> emit,
  ) async {
    emit(const IntroLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const IntroReady());
    } catch (e) {
      emit(IntroError(e.toString()));
    }
  }
}
