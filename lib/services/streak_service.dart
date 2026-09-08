import '../models/streak_record.dart';
import '../utils/date_utils.dart';

/// Pure streak-arithmetic logic, kept separate from persistence so it's
/// trivially unit-testable.
class StreakService {
  /// Returns the updated [StreakRecord] after the user completes at least
  /// one daily-mission item "today". Idempotent — calling this again later
  /// the same day is a no-op.
  StreakRecord recordCompletionToday(StreakRecord current, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final todayStr = dateKey(today);

    if (current.history.contains(todayStr)) {
      return current; // already recorded today
    }

    int newCurrentStreak;
    if (current.lastCompletedDate == null) {
      newCurrentStreak = 1;
    } else if (isYesterday(current.lastCompletedDate!, today)) {
      newCurrentStreak = current.currentStreak + 1;
    } else {
      newCurrentStreak = 1; // streak was broken
    }

    final newHistory = {...current.history, todayStr};
    final newLongest = newCurrentStreak > current.longestStreak
        ? newCurrentStreak
        : current.longestStreak;

    return current.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongest,
      lastCompletedDate: todayStr,
      history: newHistory,
    );
  }

  /// Whether the streak has already lapsed as of "now" (i.e. yesterday
  /// passed with no completion and today hasn't been completed yet) — used
  /// to show a "your streak is at risk" nudge rather than silently
  /// resetting the display until the next completion.
  bool isAtRisk(StreakRecord current, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final todayStr = dateKey(today);
    if (current.lastCompletedDate == null) return false;
    if (current.history.contains(todayStr)) return false;
    return isYesterday(current.lastCompletedDate!, today);
  }
}
