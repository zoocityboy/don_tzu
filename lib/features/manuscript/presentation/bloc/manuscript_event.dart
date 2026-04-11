import 'package:equatable/equatable.dart';

abstract class ManuscriptEvent extends Equatable {
  const ManuscriptEvent();

  @override
  List<Object?> get props => [];
}

class LoadManuscriptPages extends ManuscriptEvent {
  const LoadManuscriptPages();
}

class ToggleLike extends ManuscriptEvent {
  final String pageId;

  const ToggleLike(this.pageId);

  @override
  List<Object?> get props => [pageId];
}
