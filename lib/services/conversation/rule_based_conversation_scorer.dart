import 'dart:math';

import '../../models/conversation.dart';
import 'conversation_scorer.dart';
import 'conversation_signal_extractor.dart';

/// Deterministic, fully-offline [ConversationScorer]. Every signal comes
/// from simple heuristics over the user's own typed text and the
/// scenario's authored metadata — no network call, no model inference.
///
/// Weighting (all sub-scores 0-1, combined into a 0-100 total):
/// - 25% questions asked, relative to how many NPC turns invited one
/// - 25% follow-up rate on the NPC's previous turn
/// - 20% emotional-awareness phrase usage
/// - 15% not ignoring NPC questions
/// - 15% conversational balance (40-60% of words being the user's is ideal)
class RuleBasedConversationScorer implements ConversationScorer {
  @override
  ConversationScoringResult score(
    ConversationScenario scenario,
    List<ConversationTurn> transcript,
  ) {
    final userTurns = transcript
        .where((t) => t.speaker == 'user')
        .map((t) => t.text)
        .toList();

    var questionsAsked = 0;
    var followUps = 0;
    var followUpOpportunities = 0;
    var ignoredQuestions = 0;
    var questionOpportunities = 0;
    var emotionalHits = 0;

    for (final text in userTurns) {
      if (ConversationSignalExtractor.isQuestion(text)) questionsAsked++;
      emotionalHits += ConversationSignalExtractor.countEmotionalAwarenessHits(
        text,
      );
    }

    // Walk NPC turns in order; each has a corresponding "next user reply"
    // (userTurns[i+1], since userTurns[0] replies to the opening line and
    // userTurns[i+1] replies to npcTurns[i]).
    for (var i = 0; i < scenario.npcTurns.length; i++) {
      final npcTurn = scenario.npcTurns[i];
      final replyIndex = i + 1;
      if (replyIndex >= userTurns.length) break;
      final reply = userTurns[replyIndex];

      if (npcTurn.keyTerms.isNotEmpty) {
        followUpOpportunities++;
        if (ConversationSignalExtractor.followsUpOn(reply, npcTurn.keyTerms)) {
          followUps++;
        }
      }
      if (npcTurn.isQuestion) {
        questionOpportunities++;
        if (!ConversationSignalExtractor.answersQuestion(
          reply,
          npcTurn.expectedAnswerTerms,
        )) {
          ignoredQuestions++;
        }
      }
    }

    final followUpRate = followUpOpportunities == 0
        ? 0.5
        : followUps / followUpOpportunities;
    final ignoredRatio = questionOpportunities == 0
        ? 0.0
        : ignoredQuestions / questionOpportunities;

    final userWordCount = userTurns
        .map(ConversationSignalExtractor.wordCount)
        .fold<int>(0, (a, b) => a + b);
    final npcWordCount = scenario.npcTurns
        .map((t) => ConversationSignalExtractor.wordCount(t.text))
        .fold<int>(0, (a, b) => a + b) +
        ConversationSignalExtractor.wordCount(scenario.openingLine);
    final totalWords = userWordCount + npcWordCount;
    final userShare = totalWords == 0 ? 0.5 : userWordCount / totalWords;
    // Ideal band is 40-60% user share; score falls off linearly outside it.
    final balanceScore = _bandScore(userShare, 0.4, 0.6);

    final expectedQuestionOpportunities = max(
      1,
      (scenario.npcTurns.length / 2).ceil(),
    );
    final questionScore = min(
      1.0,
      questionsAsked / expectedQuestionOpportunities,
    );
    final emotionalRatio = min(1.0, emotionalHits / max(1, userTurns.length));

    final total =
        (25 * questionScore) +
        (25 * followUpRate) +
        (20 * emotionalRatio) +
        (15 * (1 - ignoredRatio)) +
        (15 * balanceScore);

    final score = total.clamp(0, 100).round();

    final subScores = <String, double>{
      'questions': questionScore,
      'followUp': followUpRate,
      'emotional': emotionalRatio,
      'ignored': 1 - ignoredRatio,
      'balance': balanceScore,
    };
    final weakest = subScores.entries.reduce(
      (a, b) => a.value <= b.value ? a : b,
    );

    final feedback = _feedbackFor(
      weakest.key,
      questionsAsked: questionsAsked,
      followUps: followUps,
      followUpOpportunities: followUpOpportunities,
      ignoredQuestions: ignoredQuestions,
      userShare: userShare,
      attemptNumber: transcript.length,
    );

    return ConversationScoringResult(
      score: score,
      questionsAsked: questionsAsked,
      followUpRate: followUpRate,
      ignoredQuestionCount: ignoredQuestions,
      emotionalAwarenessHits: emotionalHits,
      balanceScore: balanceScore,
      feedbackLines: feedback,
    );
  }

  double _bandScore(double value, double low, double high) {
    if (value >= low && value <= high) return 1.0;
    final distance = value < low ? (low - value) : (value - high);
    return max(0.0, 1.0 - (distance / 0.4));
  }

  List<String> _feedbackFor(
    String weakestArea, {
    required int questionsAsked,
    required int followUps,
    required int followUpOpportunities,
    required int ignoredQuestions,
    required double userShare,
    required int attemptNumber,
  }) {
    final banks = <String, List<String>>{
      'questions': [
        'You asked $questionsAsked question${questionsAsked == 1 ? '' : 's'} — try asking one more open-ended question next time to keep them talking.',
        'Try leading more with curiosity: a well-placed question often does more work than a well-placed statement.',
        'Notice how many of your turns were statements about yourself versus questions about them — aim for more of the latter.',
      ],
      'followUp': [
        'You asked $questionsAsked questions but only followed up on $followUps of $followUpOpportunities opportunities — try referencing what they just said before changing topics.',
        'A good follow-up repeats a specific word or detail they used — it signals you were actually listening.',
        'Before asking your next question, try restating one detail from their last answer first.',
      ],
      'emotional': [
        "You stayed pretty factual — try naming the emotion you think they're feeling ('that sounds frustrating') before moving on.",
        'Acknowledging feeling, not just facts, usually makes people feel more heard.',
        "Try a line like 'that must have been hard' before your next question.",
      ],
      'ignored': [
        'You let $ignoredQuestions of their questions pass without really answering — try addressing what they ask before redirecting.',
        "When someone asks you something directly, answer it first, then you can steer the conversation elsewhere.",
        'Ignoring a direct question, even briefly, can read as disinterest — close the loop before moving on.',
      ],
      'balance': [
        userShare > 0.6
            ? "You did most of the talking (${(userShare * 100).round()}% of the words) — leave more room for them."
            : "They did most of the talking (${(userShare * 100).round()}% yours) — it's fine to share more of yourself too.",
        'Aim for something close to an even split — a conversation, not an interview or a monologue.',
        'Balance builds rapport: too little from you can feel guarded, too much can feel one-sided.',
      ],
    };

    final lines = banks[weakestArea] ?? banks['questions']!;
    final variantIndex = attemptNumber % lines.length;
    return [lines[variantIndex]];
  }
}
