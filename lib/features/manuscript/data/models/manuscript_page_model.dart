import 'package:hive_ce/hive.dart';

part 'manuscript_page_model.g.dart';

@HiveType(typeId: 0)
class ManuscriptPageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String quote;

  @HiveField(3)
  final String imageAsset;

  @HiveField(4)
  bool isLiked;

  @HiveField(5)
  final String audio;

  ManuscriptPageModel({
    required this.id,
    required this.title,
    required this.quote,
    required this.imageAsset,
    required this.audio,
    this.isLiked = false,
  });

  ManuscriptPageModel copyWith({
    String? id,
    String? title,
    String? quote,
    String? imageAsset,
    bool? isLiked,
    String? audio,
  }) {
    return ManuscriptPageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      quote: quote ?? this.quote,
      imageAsset: imageAsset ?? this.imageAsset,
      audio: audio ?? this.audio,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
