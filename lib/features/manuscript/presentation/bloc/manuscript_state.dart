import 'package:equatable/equatable.dart';
import '../../domain/entities/manuscript_page.dart';

abstract class ManuscriptState extends Equatable {
  const ManuscriptState();

  @override
  List<Object?> get props => [];
}

class ManuscriptInitial extends ManuscriptState {
  const ManuscriptInitial();
}

class ManuscriptLoading extends ManuscriptState {
  const ManuscriptLoading();
}

class ManuscriptLoaded extends ManuscriptState {
  final List<ManuscriptPage> pages;
  final int currentPageIndex;

  const ManuscriptLoaded({required this.pages, this.currentPageIndex = 0});

  ManuscriptLoaded copyWith({
    List<ManuscriptPage>? pages,
    int? currentPageIndex,
  }) {
    return ManuscriptLoaded(
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }

  @override
  List<Object?> get props => [pages, currentPageIndex];
}

class ManuscriptError extends ManuscriptState {
  final String message;

  const ManuscriptError(this.message);

  @override
  List<Object?> get props => [message];
}
