import '../../models/conversation.dart';

/// Scores a played-out conversation-simulator transcript against its
/// scripted scenario. `RuleBasedConversationScorer` is the only v1
/// implementation — a real LLM-backed scorer could later implement this
/// same interface (e.g. sending the transcript to Claude for evaluation)
/// without any screen needing to change.
abstract class ConversationScorer {
  ConversationScoringResult score(
    ConversationScenario scenario,
    List<ConversationTurn> transcript,
  );
}
