// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentResultAdapter extends TypeAdapter<AssessmentResult> {
  @override
  final typeId = 7;

  @override
  AssessmentResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentResult(
      dimensionScores: fields[0] as DimensionScores,
      rawAnswers: (fields[1] as Map).cast<String, dynamic>(),
      completedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentResult obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dimensionScores)
      ..writeByte(1)
      ..write(obj.rawAnswers)
      ..writeByte(2)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
