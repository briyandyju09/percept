import '../models/assessment_question.dart';
import '../models/assessment_result.dart';
import '../models/dimension_scores.dart';
import '../services/conversation/conversation_signal_extractor.dart';
import '../utils/keyword_stopwords.dart';

/// Scores the onboarding assessment's 15 questions (3 each across 5
/// dimensions: memory, observation, socialIntelligence, composure,
/// reasoning) into an initial [DimensionScores]. `communication` and
/// `performance` are not directly assessed at onboarding — per idea.txt's
/// 5 mini-tests — and start at the neutral default (50), growing instead
/// through actual practice.
///
/// Every sub-score below is a deterministic heuristic over the user's
/// typed/selected answer, in the same spirit as [RuleBasedConversationScorer]
/// — never a claim of perfectly measuring these dimensions, just an honest,
/// legible first estimate that the rest of the app then refines over time.
class AssessmentScorer {
  AssessmentResult score(
    List<AssessmentQuestion> questions,
    Map<String, dynamic> answers,
  ) {
    final byDimension = <String, List<int>>{};

    for (final q in questions) {
      final answer = answers[q.id];
      final points = _scoreQuestion(q, answer);
      byDimension.putIfAbsent(q.dimension, () => []).add(points);
    }

    int avgFor(String dim) {
      final scores = byDimension[dim];
      if (scores == null || scores.isEmpty) return 50;
      return (scores.reduce((a, b) => a + b) / scores.length).round();
    }

    final dimensionScores = DimensionScores(
      observation: avgFor('observation'),
      memory: avgFor('memory'),
      socialIntelligence: avgFor('socialIntelligence'),
      composure: avgFor('composure'),
      communication: 50,
      reasoning: avgFor('reasoning'),
      performance: 50,
    );

    return AssessmentResult(
      dimensionScores: dimensionScores,
      rawAnswers: answers,
      completedAt: DateTime.now(),
    );
  }

  int _scoreQuestion(AssessmentQuestion q, dynamic answer) {
    switch (q.type) {
      case 'memoryRecall':
        return _scoreRecallAgainstList(answer, q.stimulusList);
      case 'observationRecall':
      case 'reasoningPuzzle':
        return _scoreExactOrTokenMatch(answer, q.correctAnswer);
      case 'socialResponse':
        return _scoreSocialResponse(answer, q.correctAnswer);
      case 'emotionalReaction':
        return _scoreEmotionalReaction(answer);
      default:
        return 50;
    }
  }

  /// Recall scoring: what fraction of the originally-shown list appears
  /// (by token overlap) in the user's free-text recall answer.
  int _scoreRecallAgainstList(dynamic answer, List<String> originalList) {
    if (originalList.isEmpty) return 50;
    final text = (answer ?? '').toString();
    if (text.trim().isEmpty) return 0;
    final userTokens = extractKeyTokens(text);
    var hits = 0;
    for (final item in originalList) {
      final itemTokens = extractKeyTokens(item);
      if (itemTokens.any(userTokens.contains)) hits++;
    }
    return ((hits / originalList.length) * 100).round().clamp(0, 100);
  }

  /// Exact (case-insensitive) match if possible, else token-overlap partial
  /// credit against a single reference [correctAnswer].
  int _scoreExactOrTokenMatch(dynamic answer, dynamic correctAnswer) {
    if (correctAnswer == null) return 50;
    final userText = (answer ?? '').toString().trim().toLowerCase();
    final correctText = correctAnswer.toString().trim().toLowerCase();
    if (userText.isEmpty) return 0;
    if (userText == correctText) return 100;
    final userTokens = extractKeyTokens(userText);
    final correctTokens = extractKeyTokens(correctText);
    if (correctTokens.isEmpty) return 50;
    final overlap = correctTokens
        .where((t) => userTokens.contains(t))
        .length;
    return ((overlap / correctTokens.length) * 100).round().clamp(0, 100);
  }

  /// Free-text social response: rewards on-topic engagement (token overlap
  /// with the reference answer), genuine effort (a minimum word count),
  /// and explicit emotional-awareness language, reusing the same phrase
  /// bank the conversation simulator uses.
  int _scoreSocialResponse(dynamic answer, dynamic referenceAnswer) {
    final text = (answer ?? '').toString();
    if (text.trim().isEmpty) return 20;
    final words = ConversationSignalExtractor.wordCount(text);
    final effortScore = (words / 20).clamp(0, 1) * 40;
    final overlapScore =
        _scoreExactOrTokenMatch(text, referenceAnswer) / 100 * 30;
    final emotionalHits = ConversationSignalExtractor
        .countEmotionalAwarenessHits(text)
        .clamp(0, 2);
    final emotionalScore = emotionalHits / 2 * 30;
    return (effortScore + overlapScore + emotionalScore)
        .round()
        .clamp(0, 100);
  }

  static const List<String> _reactiveMarkers = [
    'immediately', 'snapped', 'yelled', 'shouted', 'blew up', 'furious',
    'can\'t believe', 'so annoying', 'hate', 'stupid',
  ];
  static const List<String> _regulatedMarkers = [
    'pause', 'breathe', 'breath', 'wait', 'calm', 'take a moment', 'think',
    'later', 'step back', 'count to', 'ask', 'clarify',
  ];

  /// Composure heuristic: rewards language suggesting a regulated,
  /// non-impulsive reaction; penalizes explicitly reactive language. Both
  /// marker lists are intentionally small and legible, not exhaustive.
  int _scoreEmotionalReaction(dynamic answer) {
    final text = (answer ?? '').toString().toLowerCase();
    if (text.trim().isEmpty) return 40;
    var score = 60;
    for (final marker in _regulatedMarkers) {
      if (text.contains(marker)) score += 8;
    }
    for (final marker in _reactiveMarkers) {
      if (text.contains(marker)) score -= 12;
    }
    return score.clamp(0, 100);
  }
}
