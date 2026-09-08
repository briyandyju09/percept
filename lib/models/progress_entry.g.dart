// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressEntryAdapter extends TypeAdapter<ProgressEntry> {
  @override
  final typeId = 6;

  @override
  ProgressEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressEntry(
      date: fields[0] as DateTime,
      metric: fields[1] as String,
      value: (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgressEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.metric)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
