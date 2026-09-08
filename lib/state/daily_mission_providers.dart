import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completion_record.dart';
import '../models/daily_mission_item.dart';
import '../utils/date_utils.dart';
import '../utils/id_generator.dart';
import 'profile_providers.dart';
import 'repository_providers.dart';
import 'revision_providers.dart';

class DailyMissionNotifier extends Notifier<List<DailyMissionItem>> {
  @override
  List<DailyMissionItem> build() {
    final today = todayKey();
    final repo = ref.read(dailyMissionRepositoryProvider);
    final existing = repo.forDate(today);
    if (existing.isNotEmpty) {
      existing.sort(_orderIndex);
      return existing;
    }
    final profile = ref.read(profileProvider);
    final generated = ref
        .read(dailyMissionGeneratorProvider)
        .generateFor(today, profile);
    repo.saveAll(generated);
    return generated;
  }

  int _orderIndex(DailyMissionItem a, DailyMissionItem b) {
    const order = ['learn', 'practice', 'socialChallenge', 'composure', 'reflect'];
    return order.indexOf(a.type).compareTo(order.indexOf(b.type));
  }

  Future<void> toggleComplete(String itemId) async {
    final item = state.firstWhere((i) => i.id == itemId);
    final updated = item.copyWith(
      completed: !item.completed,
      completedAt: !item.completed ? DateTime.now() : null,
    );
    state = [
      for (final i in state) if (i.id == itemId) updated else i,
    ];
    await ref.read(dailyMissionRepositoryProvider).save(updated);

    if (updated.completed) {
      await ref.read(progressRepositoryProvider).addCompletion(
        CompletionRecord(
          id: generateLocalId('completion'),
          contentId: updated.refContentId.isEmpty
              ? updated.id
              : updated.refContentId,
          contentType: 'dailyMissionItem',
          completedAt: DateTime.now(),
        ),
      );
      ref.read(completionsRevisionProvider.notifier).state++;

      final streak = ref.read(progressRepositoryProvider).loadStreak();
      final updatedStreak = ref.read(streakServiceProvider).recordCompletionToday(streak);
      await ref.read(progressRepositoryProvider).saveStreak(updatedStreak);
      ref.read(streakRevisionProvider.notifier).state++;
    }
  }

  bool get allComplete => state.every((i) => i.completed);

  int get completedCount => state.where((i) => i.completed).length;

  int get totalMinutes =>
      state.fold(0, (sum, i) => sum + i.estimatedMinutes);
}

final dailyMissionProvider =
    NotifierProvider<DailyMissionNotifier, List<DailyMissionItem>>(
  DailyMissionNotifier.new,
);

final streakRecordProvider = Provider((ref) {
  ref.watch(streakRevisionProvider);
  return ref.read(progressRepositoryProvider).loadStreak();
});
