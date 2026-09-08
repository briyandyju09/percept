// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 9;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] == null ? 'system' : fields[0] as String,
      dailyReminderEnabled: fields[1] == null ? false : fields[1] as bool,
      dailyReminderHour: fields[2] == null ? 9 : (fields[2] as num).toInt(),
      dailyReminderMinute: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      hapticsEnabled: fields[4] == null ? true : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.dailyReminderEnabled)
      ..writeByte(2)
      ..write(obj.dailyReminderHour)
      ..writeByte(3)
      ..write(obj.dailyReminderMinute)
      ..writeByte(4)
      ..write(obj.hapticsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
