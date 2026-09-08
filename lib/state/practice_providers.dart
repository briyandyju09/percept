import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completion_record.dart';
import '../models/discipline.dart';
import '../models/drill.dart';
import '../models/lesson.dart';
import '../models/progress_entry.dart';
import 'profile_providers.dart';
import 'repository_providers.dart';
import 'revision_providers.dart';

/// A small facade over the completion/profile-nudging side effects that
/// happen whenever the user finishes a lesson or a drill — kept in one
/// place so `LessonCompleteScreen`/`DrillResultScreen` don't each
/// reimplement "record completion + bump revision + move the dimension."
class PracticeActions {
  PracticeActions(this._ref);
  final Ref _ref;

  Future<void> completeLesson(Lesson lesson) async {
    await _ref.read(progressRepositoryProvider).addCompletion(
      CompletionRecord(
        id: 'lesson-${lesson.id}-${DateTime.now().millisecondsSinceEpoch}',
        contentId: lesson.id,
        contentType: 'lesson',
        completedAt: DateTime.now(),
      ),
    );
    _ref.read(completionsRevisionProvider.notifier).state++;
    final discipline = Discipline.byId(lesson.disciplineId);
    await _ref
        .read(profileProvider.notifier)
        .adjustDimension(discipline.primaryDimension, 1);
  }

  /// [scorePercent] is 0-100 (e.g. correct answers / total questions).
  Future<void> completeDrill(Drill drill, {required int scorePercent}) async {
    await _ref.read(progressRepositoryProvider).addCompletion(
      CompletionRecord(
        id: 'drill-${drill.id}-${DateTime.now().millisecondsSinceEpoch}',
        contentId: drill.id,
        contentType: 'drill',
        completedAt: DateTime.now(),
        resultSummary: '$scorePercent%',
      ),
    );
    _ref.read(completionsRevisionProvider.notifier).state++;

    final discipline = Discipline.byId(drill.disciplineId);
    // Strong performance (>=70%) nudges the dimension up by 2, a weak one
    // still nudges up by a token +1 for effort (practice always helps a
    // little), never down — completing hard practice shouldn't punish you.
    final delta = scorePercent >= 70 ? 2 : 1;
    await _ref
        .read(profileProvider.notifier)
        .adjustDimension(discipline.primaryDimension, delta);

    await _ref.read(progressRepositoryProvider).addProgressEntry(
      ProgressEntry(
        date: DateTime.now(),
        metric: 'drillScore_${drill.labCategory}',
        value: scorePercent.toDouble(),
      ),
    );
    _ref.read(progressEntriesRevisionProvider.notifier).state++;
  }

  Future<void> markCardSaved(String cardId) async {
    await _ref.read(savedCardsRepositoryProvider).toggle(cardId);
    _ref.read(savedCardsRevisionProvider.notifier).state++;
  }
}

final practiceActionsProvider = Provider((ref) => PracticeActions(ref));

final isLessonCompletedProvider = Provider.family<bool, String>((ref, id) {
  ref.watch(completionsRevisionProvider);
  return ref.read(progressRepositoryProvider).isCompleted(id);
});

final isDrillCompletedProvider = Provider.family<bool, String>((ref, id) {
  ref.watch(completionsRevisionProvider);
  return ref.read(progressRepositoryProvider).isCompleted(id);
});

final isCardSavedProvider = Provider.family<bool, String>((ref, cardId) {
  ref.watch(savedCardsRevisionProvider);
  return ref.read(savedCardsRepositoryProvider).isSaved(cardId);
});

final savedCardsListProvider = Provider((ref) {
  ref.watch(savedCardsRevisionProvider);
  return ref.read(savedCardsRepositoryProvider).all();
});

final completionHistoryProvider = Provider((ref) {
  ref.watch(completionsRevisionProvider);
  return ref.read(progressRepositoryProvider).allCompletions();
});

final progressEntriesForMetricProvider = Provider.family<
    List<ProgressEntry>, String>((ref, metric) {
  ref.watch(progressEntriesRevisionProvider);
  return ref.read(progressRepositoryProvider).entriesForMetric(metric);
});
