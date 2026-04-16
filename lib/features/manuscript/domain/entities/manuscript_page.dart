import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';

class ManuscriptPage extends Equatable {
  final String id;
  final String title;
  final String quote;
  final String imageAsset;
  final bool isLiked;
  final Source audioAsset;

  const ManuscriptPage({
    required this.id,
    required this.title,
    required this.quote,
    required this.imageAsset,
    this.isLiked = false,
    required this.audioAsset,
  });

  ManuscriptPage copyWith({
    String? id,
    String? title,
    String? quote,
    String? imageAsset,
    bool? isLiked,
    Source? audio,
  }) {
    return ManuscriptPage(
      id: id ?? this.id,
      title: title ?? this.title,
      quote: quote ?? this.quote,
      imageAsset: imageAsset ?? this.imageAsset,
      isLiked: isLiked ?? this.isLiked,
      audioAsset: audio ?? this.audioAsset,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    quote,
    imageAsset,
    isLiked,
    audioAsset,
  ];
}
