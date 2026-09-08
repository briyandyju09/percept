// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedCardAdapter extends TypeAdapter<SavedCard> {
  @override
  final typeId = 4;

  @override
  SavedCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedCard(
      cardId: fields[0] as String,
      savedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedCard obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
