import 'package:hive_ce/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 9)
class AppSettings {
  AppSettings({
    this.themeMode = 'system',
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 9,
    this.dailyReminderMinute = 0,
    this.hapticsEnabled = true,
  });

  @HiveField(0)
  final String themeMode; // system | light | dark
  @HiveField(1)
  final bool dailyReminderEnabled;
  @HiveField(2)
  final int dailyReminderHour;
  @HiveField(3)
  final int dailyReminderMinute;
  @HiveField(4)
  final bool hapticsEnabled;

  AppSettings copyWith({
    String? themeMode,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? hapticsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
