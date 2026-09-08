import 'package:hive_ce/hive.dart';

part 'streak_record.g.dart';

/// Tracks daily-mission completion streaks. `history` stores `yyyy-MM-dd`
/// keys for every day at least one mission item was completed.
@HiveType(typeId: 2)
class StreakRecord {
  StreakRecord({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    Set<String>? history,
  }) : history = history ?? <String>{};

  @HiveField(0)
  final int currentStreak;
  @HiveField(1)
  final int longestStreak;
  @HiveField(2)
  final String? lastCompletedDate; // yyyy-MM-dd
  @HiveField(3)
  final Set<String> history;

  StreakRecord copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastCompletedDate,
    Set<String>? history,
  }) {
    return StreakRecord(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      history: history ?? this.history,
    );
  }
}
