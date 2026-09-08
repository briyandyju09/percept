/// One triggered (or explicitly avoided) reasoning-quality flag surfaced on
/// the Case Debrief screen.
class CognitiveBiasFlag {
  const CognitiveBiasFlag({
    required this.biasName,
    required this.triggered,
    required this.evidenceForFlag,
    required this.explanationText,
  });

  final String biasName;
  final bool triggered;
  final String evidenceForFlag;
  final String explanationText;
}

/// Full result of [CaseReasoningAnalyzer.analyze].
class CaseDebriefResult {
  const CaseDebriefResult({
    required this.correct,
    required this.flags,
    required this.overallReasoningScore,
    required this.summary,
  });

  final bool correct;
  final List<CognitiveBiasFlag> flags;
  final int overallReasoningScore;
  final String summary;
}
