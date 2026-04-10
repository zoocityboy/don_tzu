// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manuscript_page_model.dart';

class ManuscriptPageModelAdapter extends TypeAdapter<ManuscriptPageModel> {
  @override
  final int typeId = 0;

  @override
  ManuscriptPageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManuscriptPageModel(
      id: fields[0] as String,
      title: fields[1] as String,
      quote: fields[2] as String,
      imageAsset: fields[3] as String,
      isLiked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ManuscriptPageModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.quote)
      ..writeByte(3)
      ..write(obj.imageAsset)
      ..writeByte(4)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManuscriptPageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
