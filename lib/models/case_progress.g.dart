// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaseProgressAdapter extends TypeAdapter<CaseProgress> {
  @override
  final typeId = 5;

  @override
  CaseProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaseProgress(
      caseId: fields[0] as String,
      questionsAsked: (fields[1] as List?)?.cast<String>(),
      evidenceViewed: (fields[2] as List?)?.cast<String>(),
      suspectsMarked: (fields[3] as List?)?.cast<String>(),
      solved: fields[4] == null ? false : fields[4] as bool,
      chosenCulpritId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CaseProgress obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.caseId)
      ..writeByte(1)
      ..write(obj.questionsAsked)
      ..writeByte(2)
      ..write(obj.evidenceViewed)
      ..writeByte(3)
      ..write(obj.suspectsMarked)
      ..writeByte(4)
      ..write(obj.solved)
      ..writeByte(5)
      ..write(obj.chosenCulpritId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
