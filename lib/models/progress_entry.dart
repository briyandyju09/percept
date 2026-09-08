import 'package:hive_ce/hive.dart';

part 'progress_entry.g.dart';

/// A generic time-series row driving the Profile tab's trend charts, e.g.
/// metric="responseTimeMs" value=2100 on a given date.
@HiveType(typeId: 6)
class ProgressEntry {
  ProgressEntry({
    required this.date,
    required this.metric,
    required this.value,
  });

  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final String metric; // responseTimeMs | interruptions | stressPerformance
  @HiveField(2)
  final double value;
}
