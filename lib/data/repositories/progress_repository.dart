import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/completion_record.dart';
import '../../models/progress_entry.dart';
import '../../models/streak_record.dart';
import '../hive/hive_setup.dart';

/// Handles completion history, longitudinal trend rows, and the streak
/// counter — the data the Profile tab's trend charts and history log read.
class ProgressRepository {
  Box get _completionsBox => Hive.box(HiveBoxes.completions);
  Box get _streakBox => Hive.box(HiveBoxes.streak);
  Box get _entriesBox => Hive.box(HiveBoxes.progressEntries);

  // --- Completions ---

  Future<void> addCompletion(CompletionRecord record) =>
      _completionsBox.put(record.id, record);

  List<CompletionRecord> allCompletions() {
    final list = _completionsBox.values.cast<CompletionRecord>().toList();
    list.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return list;
  }

  bool isCompleted(String contentId) => _completionsBox.values
      .cast<CompletionRecord>()
      .any((c) => c.contentId == contentId);

  int countByType(String contentType) => _completionsBox.values
      .cast<CompletionRecord>()
      .where((c) => c.contentType == contentType)
      .length;

  // --- Streak ---

  static const String _streakKey = 'current';

  StreakRecord loadStreak() {
    final existing = _streakBox.get(_streakKey) as StreakRecord?;
    if (existing != null) return existing;
    final fresh = StreakRecord();
    _streakBox.put(_streakKey, fresh);
    return fresh;
  }

  Future<void> saveStreak(StreakRecord record) =>
      _streakBox.put(_streakKey, record);

  // --- Progress entries (trend charts) ---

  Future<void> addProgressEntry(ProgressEntry entry) => _entriesBox.put(
    '${entry.metric}-${entry.date.toIso8601String()}',
    entry,
  );

  List<ProgressEntry> entriesForMetric(String metric) {
    final list = _entriesBox.values
        .cast<ProgressEntry>()
        .where((e) => e.metric == metric)
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }
}
