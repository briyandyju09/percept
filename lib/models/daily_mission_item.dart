import 'package:hive_ce/hive.dart';

part 'daily_mission_item.g.dart';

@HiveType(typeId: 8)
class DailyMissionItem {
  DailyMissionItem({
    required this.id,
    required this.date,
    required this.type,
    required this.refContentId,
    required this.estimatedMinutes,
    this.title = '',
    this.subtitle = '',
    this.completed = false,
    this.completedAt,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String date; // yyyy-MM-dd
  @HiveField(2)
  final String type; // learn | practice | socialChallenge | composure | reflect
  @HiveField(3)
  final String refContentId;
  @HiveField(4)
  final int estimatedMinutes;
  @HiveField(5)
  final bool completed;
  @HiveField(6)
  final DateTime? completedAt;
  @HiveField(7)
  final String title;
  @HiveField(8)
  final String subtitle;

  DailyMissionItem copyWith({bool? completed, DateTime? completedAt}) {
    return DailyMissionItem(
      id: id,
      date: date,
      type: type,
      refContentId: refContentId,
      estimatedMinutes: estimatedMinutes,
      title: title,
      subtitle: subtitle,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
