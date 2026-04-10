import 'package:equatable/equatable.dart';

class ManuscriptPage extends Equatable {
  final String id;
  final String title;
  final String quote;
  final String imageAsset;
  final bool isLiked;

  const ManuscriptPage({
    required this.id,
    required this.title,
    required this.quote,
    required this.imageAsset,
    this.isLiked = false,
  });

  ManuscriptPage copyWith({
    String? id,
    String? title,
    String? quote,
    String? imageAsset,
    bool? isLiked,
  }) {
    return ManuscriptPage(
      id: id ?? this.id,
      title: title ?? this.title,
      quote: quote ?? this.quote,
      imageAsset: imageAsset ?? this.imageAsset,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [id, title, quote, imageAsset, isLiked];
}
