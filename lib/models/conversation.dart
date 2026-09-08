/// One line of dialogue from the NPC in a [ConversationScenario].
class ConversationNpcTurn {
  const ConversationNpcTurn({
    required this.text,
    this.keyTerms = const [],
    this.isQuestion = false,
    this.expectedAnswerTerms = const [],
  });

  final String text;

  /// Stopword-stripped terms this turn "is about" — used to detect whether
  /// the user's next reply follows up on it.
  final List<String> keyTerms;

  /// Whether this NPC turn poses a question the user could ignore.
  final bool isQuestion;

  /// If [isQuestion], the terms an on-topic answer would contain.
  final List<String> expectedAnswerTerms;

  factory ConversationNpcTurn.fromJson(Map<String, dynamic> json) =>
      ConversationNpcTurn(
        text: json['text'] as String,
        keyTerms: (json['keyTerms'] as List<dynamic>? ?? []).cast<String>(),
        isQuestion: json['isQuestion'] as bool? ?? false,
        expectedAnswerTerms:
            (json['expectedAnswerTerms'] as List<dynamic>? ?? [])
                .cast<String>(),
      );
}

class ConversationScenario {
  const ConversationScenario({
    required this.id,
    required this.title,
    required this.setup,
    required this.openingLine,
    required this.npcTurns,
    this.difficulty = 1,
  });

  final String id;
  final String title;
  final String setup;
  final String openingLine;
  final List<ConversationNpcTurn> npcTurns;
  final int difficulty;

  factory ConversationScenario.fromJson(Map<String, dynamic> json) =>
      ConversationScenario(
        id: json['id'] as String,
        title: json['title'] as String,
        setup: json['setup'] as String,
        openingLine: json['openingLine'] as String,
        npcTurns: (json['npcTurns'] as List<dynamic>? ?? [])
            .map(
              (t) => ConversationNpcTurn.fromJson(t as Map<String, dynamic>),
            )
            .toList(),
        difficulty: json['difficulty'] as int? ?? 1,
      );
}

/// A single turn in the live played-out transcript (not persisted content —
/// produced during play).
class ConversationTurn {
  const ConversationTurn({
    required this.speaker,
    required this.text,
    required this.timestampMs,
  });

  /// user | npc
  final String speaker;
  final String text;
  final int timestampMs;
}

/// The result of scoring a played conversation scenario.
class ConversationScoringResult {
  const ConversationScoringResult({
    required this.score,
    required this.questionsAsked,
    required this.followUpRate,
    required this.ignoredQuestionCount,
    required this.emotionalAwarenessHits,
    required this.balanceScore,
    required this.feedbackLines,
  });

  final int score;
  final int questionsAsked;
  final double followUpRate;
  final int ignoredQuestionCount;
  final int emotionalAwarenessHits;
  final double balanceScore;
  final List<String> feedbackLines;
}
