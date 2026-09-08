import 'package:hive_ce/hive.dart';

part 'completion_record.g.dart';

@HiveType(typeId: 3)
class CompletionRecord {
  CompletionRecord({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.completedAt,
    this.resultSummary,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String contentId;
  @HiveField(2)
  final String contentType; // lesson | drill | card | dailyMissionItem | case
  @HiveField(3)
  final DateTime completedAt;
  @HiveField(4)
  final String? resultSummary;
}
