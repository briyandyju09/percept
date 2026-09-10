import 'keyword_stopwords.dart';

/// Phrases that signal "this correctAnswer is guidance/reflection prose,
/// not a literal gradable value" — used to tell an open-ended textInput
/// reflection apart from a genuine short-answer question, and to lint
/// content that puts this kind of language somewhere it'll break exact
/// matching (multipleChoice/trueFalse/numericInput).
final RegExp hedgePhrasePattern = RegExp(
  r'e\.g\.|there is no single|no single correct|no single right|'
  r'reference answer|well-calibrated|well calibrated|varies\b|'
  r'this is a reflection prompt',
  caseSensitive: false,
);

bool looksHedgy(String text) => hedgePhrasePattern.hasMatch(text);

int wordCount(String text) =>
    text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

/// Whether [reply] shares enough of [correctAnswer]'s meaningful
/// (stopword-stripped) tokens to count as a match. The same lenient
/// heuristic `AssessmentScorer`/`RuleBasedConversationScorer` already use
/// elsewhere, so a short free-text answer doesn't need to be a verbatim
/// match to be graded correct.
bool tokenOverlapMatches(
  String reply,
  String correctAnswer, {
  double minOverlapRatio = 0.5,
}) {
  final correctTokens = extractKeyTokens(correctAnswer);
  if (correctTokens.isEmpty) return true;
  final replyTokens = extractKeyTokens(reply);
  final overlap = correctTokens.where(replyTokens.contains).length;
  return (overlap / correctTokens.length) >= minOverlapRatio;
}
