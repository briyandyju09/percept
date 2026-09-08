import '../../utils/keyword_stopwords.dart';

/// Pure signal-extraction helpers used by [RuleBasedConversationScorer].
/// Kept separate from the scorer so each heuristic is independently unit
/// testable.
class ConversationSignalExtractor {
  ConversationSignalExtractor._();

  static final RegExp _questionWordPattern = RegExp(
    r'^(who|what|when|where|why|how|do|does|did|can|could|would|is|are|will|have|has)\b',
    caseSensitive: false,
  );

  /// Whether [text] reads as the user asking a question — either it ends
  /// in "?" or opens with a question word.
  static bool isQuestion(String text) {
    final trimmed = text.trim();
    if (trimmed.contains('?')) return true;
    return _questionWordPattern.hasMatch(trimmed);
  }

  /// Whether [reply] follows up on [previousKeyTerms] — i.e. references
  /// what the other person just said rather than changing topics cold.
  static bool followsUpOn(String reply, List<String> previousKeyTerms) {
    if (previousKeyTerms.isEmpty) return false;
    final tokens = extractKeyTokens(reply);
    return previousKeyTerms.any((term) => tokens.contains(term.toLowerCase()));
  }

  /// Whether [reply] actually addresses a question that expected
  /// [expectedTerms] in an on-topic answer.
  static bool answersQuestion(String reply, List<String> expectedTerms) {
    if (expectedTerms.isEmpty) return true; // nothing specific to check
    final tokens = extractKeyTokens(reply);
    return expectedTerms.any((term) => tokens.contains(term.toLowerCase()));
  }

  static const List<String> emotionalAwarenessPhrases = [
    'sounds like',
    'sounds tough',
    'sounds hard',
    'sounds frustrating',
    'you seem',
    'you look',
    'that must have been',
    'that must be',
    'how did that feel',
    'how does that feel',
    'how are you feeling',
    'i can imagine',
    'i imagine that',
    'i hear you',
    'i understand why',
    'that makes sense',
    'you must feel',
    'you must be feeling',
    'that sounds',
    "it's ok to feel",
    'it makes sense that',
    'i get why',
    'i can tell',
    'you seem to be',
    'i noticed you',
  ];

  static int countEmotionalAwarenessHits(String reply) {
    final lower = reply.toLowerCase();
    var hits = 0;
    for (final phrase in emotionalAwarenessPhrases) {
      if (lower.contains(phrase)) hits++;
    }
    return hits;
  }

  static int wordCount(String text) =>
      text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
}
