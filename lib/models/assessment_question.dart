/// One question in the onboarding assessment. `type` determines which
/// assessment mini-test screen renders it:
/// memoryRecall | observationRecall | socialResponse | emotionalReaction |
/// reasoningPuzzle.
class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.dimension,
    required this.type,
    required this.prompt,
    this.stimulus,
    this.stimulusList = const [],
    this.options = const [],
    this.correctAnswer,
    this.scoringWeight = 1,
    this.explanation,
  });

  final String id;
  final String dimension;
  final String type;
  final String prompt;
  final String? stimulus;
  final List<String> stimulusList;
  final List<String> options;

  /// The short, exactly-gradable value — kept short and literal (matching
  /// one of [options] where present) so `_scoreExactOrTokenMatch` in
  /// `AssessmentScorer` can actually tell a right answer from a wrong one.
  /// Longer reasoning/narrative belongs in [explanation], not here.
  final dynamic correctAnswer;
  final int scoringWeight;

  /// Optional narrative explanation of why [correctAnswer] is correct —
  /// display-only, never used for scoring, so it can be as long as it
  /// needs to be without diluting the grader.
  final String? explanation;

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) =>
      AssessmentQuestion(
        id: json['id'] as String,
        dimension: json['dimension'] as String,
        type: json['type'] as String,
        prompt: json['prompt'] as String,
        stimulus: json['stimulus'] as String?,
        stimulusList: (json['stimulusList'] as List<dynamic>? ?? [])
            .cast<String>(),
        options: (json['options'] as List<dynamic>? ?? []).cast<String>(),
        correctAnswer: json['correctAnswer'],
        scoringWeight: json['scoringWeight'] as int? ?? 1,
        explanation: json['explanation'] as String?,
      );
}
