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
  });

  final String id;
  final String dimension;
  final String type;
  final String prompt;
  final String? stimulus;
  final List<String> stimulusList;
  final List<String> options;
  final dynamic correctAnswer;
  final int scoringWeight;

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
      );
}
