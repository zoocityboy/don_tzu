import 'package:equatable/equatable.dart';

abstract class IntroState extends Equatable {
  const IntroState();

  @override
  List<Object?> get props => [];
}

class IntroInitial extends IntroState {
  const IntroInitial();
}

class IntroLoading extends IntroState {
  const IntroLoading();
}

class IntroReady extends IntroState {
  const IntroReady();
}

class IntroError extends IntroState {
  final String message;
  const IntroError(this.message);

  @override
  List<Object?> get props => [message];
}
