import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transient in-memory state for the onboarding flow only — the running
/// set of selected goals and the assessment answers collected across the 5
/// mini-test screens. Nothing here is persisted until
/// `AssessmentResultsScreen` scores it and writes through to the real
/// [ProfileNotifier]/`AssessmentRepository`.
class OnboardingDraftState {
  const OnboardingDraftState({this.goals = const [], this.answers = const {}});

  final List<String> goals;
  final Map<String, dynamic> answers;

  OnboardingDraftState copyWith({
    List<String>? goals,
    Map<String, dynamic>? answers,
  }) {
    return OnboardingDraftState(
      goals: goals ?? this.goals,
      answers: answers ?? this.answers,
    );
  }
}

class OnboardingDraftNotifier extends Notifier<OnboardingDraftState> {
  @override
  OnboardingDraftState build() => const OnboardingDraftState();

  void toggleGoal(String goalId) {
    final goals = [...state.goals];
    if (goals.contains(goalId)) {
      goals.remove(goalId);
    } else {
      goals.add(goalId);
    }
    state = state.copyWith(goals: goals);
  }

  void recordAnswer(String questionId, dynamic answer) {
    state = state.copyWith(
      answers: {...state.answers, questionId: answer},
    );
  }
}

final onboardingDraftProvider =
    NotifierProvider<OnboardingDraftNotifier, OnboardingDraftState>(
  OnboardingDraftNotifier.new,
);
