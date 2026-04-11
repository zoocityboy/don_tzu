import 'package:equatable/equatable.dart';

abstract class IntroEvent extends Equatable {
  const IntroEvent();

  @override
  List<Object?> get props => [];
}

class InitializeIntro extends IntroEvent {
  final String? language;

  const InitializeIntro({this.language});

  @override
  List<Object?> get props => [language];
}
