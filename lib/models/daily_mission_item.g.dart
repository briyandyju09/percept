// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_mission_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyMissionItemAdapter extends TypeAdapter<DailyMissionItem> {
  @override
  final typeId = 8;

  @override
  DailyMissionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMissionItem(
      id: fields[0] as String,
      date: fields[1] as String,
      type: fields[2] as String,
      refContentId: fields[3] as String,
      estimatedMinutes: (fields[4] as num).toInt(),
      title: fields[7] == null ? '' : fields[7] as String,
      subtitle: fields[8] == null ? '' : fields[8] as String,
      completed: fields[5] == null ? false : fields[5] as bool,
      completedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMissionItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.refContentId)
      ..writeByte(4)
      ..write(obj.estimatedMinutes)
      ..writeByte(5)
      ..write(obj.completed)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.subtitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMissionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
