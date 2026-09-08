enum DrillType {
  observationSprint,
  recallQuiz,
  multipleChoice,
  freeTextScenario,
  timedPressure,
  breathingTimer,
}

DrillType drillTypeFromString(String value) {
  return DrillType.values.firstWhere(
    (t) => t.name == value,
    orElse: () => DrillType.multipleChoice,
  );
}

class DrillQuestion {
  const DrillQuestion({
    required this.id,
    required this.prompt,
    required this.type,
    this.options = const [],
    this.correctAnswer,
    this.explanation = '',
  });

  final String id;
  final String prompt;

  /// multipleChoice | numericInput | textInput | trueFalse
  final String type;
  final List<String> options;
  final dynamic correctAnswer;
  final String explanation;

  factory DrillQuestion.fromJson(Map<String, dynamic> json) => DrillQuestion(
    id: json['id'] as String,
    prompt: json['prompt'] as String,
    type: json['type'] as String? ?? 'multipleChoice',
    options: (json['options'] as List<dynamic>? ?? []).cast<String>(),
    correctAnswer: json['correctAnswer'],
    explanation: json['explanation'] as String? ?? '',
  );
}

class Drill {
  const Drill({
    required this.id,
    required this.disciplineId,
    required this.labCategory,
    required this.type,
    required this.difficulty,
    required this.prompt,
    this.stimulusText,
    this.stimulusFacts = const [],
    this.stimulusImage,
    this.stimulusSeconds = 10,
    this.questions = const [],
    required this.estimatedMinutes,
  });

  final String id;
  final String disciplineId;
  final String labCategory;
  final DrillType type;

  /// 1-5
  final int difficulty;
  final String prompt;

  /// For observationSprint: the paragraph describing "the room"/scene.
  final String? stimulusText;

  /// For observationSprint: a structured list of facts the recall
  /// questions are generated against (e.g. "3 chairs", "book was red").
  final List<String> stimulusFacts;
  final String? stimulusImage;

  /// Seconds the stimulus is shown before being hidden.
  final int stimulusSeconds;
  final List<DrillQuestion> questions;
  final int estimatedMinutes;

  factory Drill.fromJson(Map<String, dynamic> json) => Drill(
    id: json['id'] as String,
    disciplineId: json['disciplineId'] as String,
    labCategory: json['labCategory'] as String,
    type: drillTypeFromString(json['type'] as String? ?? 'multipleChoice'),
    difficulty: json['difficulty'] as int? ?? 1,
    prompt: json['prompt'] as String,
    stimulusText: json['stimulusText'] as String?,
    stimulusFacts: (json['stimulusFacts'] as List<dynamic>? ?? [])
        .cast<String>(),
    stimulusImage: json['stimulusImage'] as String?,
    stimulusSeconds: json['stimulusSeconds'] as int? ?? 10,
    questions: (json['questions'] as List<dynamic>? ?? [])
        .map((q) => DrillQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
    estimatedMinutes: json['estimatedMinutes'] as int? ?? 4,
  );
}
