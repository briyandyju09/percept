import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dimension_scores.dart';
import '../models/user_profile.dart';
import 'repository_providers.dart';

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => ref.read(profileRepositoryProvider).load();

  Future<void> _persist() =>
      ref.read(profileRepositoryProvider).save(state);

  Future<void> setGoals(List<String> goals) async {
    state = state.copyWith(goals: goals);
    await _persist();
  }

  Future<void> applyAssessment(DimensionScores scores) async {
    state = state.copyWith(dimensionScores: scores);
    await _persist();
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _persist();
  }

  /// Nudges a single dimension by [delta] (e.g. +2 after a strong drill
  /// result, -1 after a weak one) — the mechanism by which practice
  /// gradually moves the Personal Profile over time.
  Future<void> adjustDimension(String key, int delta) async {
    state = UserProfile(
      id: state.id,
      createdAt: state.createdAt,
      goals: state.goals,
      dimensionScores: state.dimensionScores.adjust(key, delta),
      onboardingCompleted: state.onboardingCompleted,
      displayName: state.displayName,
    );
    await _persist();
  }

  Future<void> resetAll() async {
    await ref.read(profileRepositoryProvider).reset();
    state = UserProfile.fresh();
    await _persist();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);

/// Convenience derived provider so widgets that only care about scores
/// don't need to depend on the whole profile object.
final dimensionScoresProvider = Provider<DimensionScores>(
  (ref) => ref.watch(profileProvider).dimensionScores,
);
