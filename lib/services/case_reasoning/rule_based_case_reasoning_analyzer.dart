import '../../data/repositories/content_repository.dart';
import '../../models/case_file.dart';
import '../../models/case_progress.dart';
import '../../models/cognitive_bias_flag.dart';
import 'case_reasoning_analyzer.dart';

/// Deterministic, fully-offline [CaseReasoningAnalyzer]. Every signal comes
/// from authored metadata (`CaseQuestion.flags`, `CaseEvidence.subtle`/
/// `contradicts`/`supportsCharacterId`) matched against what the player
/// actually asked/viewed/accused — no network call, no model inference.
///
/// Always checks the same 4 fixed reasoning-quality flags, whose
/// explanation text is looked up from [ContentRepository.biasDefinitions]
/// so the same wording used to teach these concepts in the Human
/// Psychology discipline is reused verbatim in the case debrief:
/// `anchoring_bias`, `premature_closure`, `confirmation_bias`,
/// `belief_perseverance`.
class RuleBasedCaseReasoningAnalyzer implements CaseReasoningAnalyzer {
  RuleBasedCaseReasoningAnalyzer(this._content);

  final ContentRepository _content;

  @override
  CaseDebriefResult analyze(CaseFile caseFile, CaseProgress progress) {
    final flags = <CognitiveBiasFlag>[];

    final accusedId = progress.chosenCulpritId;
    final correct = accusedId == caseFile.solution.correctCulpritId;

    final firstSuspect = progress.suspectsMarked.isNotEmpty
        ? progress.suspectsMarked.first
        : null;

    // --- Anchoring: final accusation equals the first character marked as
    // a suspect, with little follow-up questioning of anyone else after.
    final questionsAboutOthersAfterFirstSuspect = progress.questionsAsked
        .where((qId) => _questionCharacterId(caseFile, qId) != firstSuspect)
        .length;
    final anchored = firstSuspect != null &&
        accusedId == firstSuspect &&
        questionsAboutOthersAfterFirstSuspect < 3;
    flags.add(_flagFor('anchoring_bias', anchored, 'You accused the first person you suspected without exploring the other characters much further.'));

    // --- Premature closure: accused having viewed <60% of evidence or
    // asked fewer than the case's threshold of questions.
    final evidenceViewedRatio = caseFile.evidence.isEmpty
        ? 1.0
        : progress.evidenceViewed.length / caseFile.evidence.length;
    final premature = evidenceViewedRatio < 0.6 ||
        progress.questionsAsked.length < caseFile.minQuestionsBeforeAccusation;
    flags.add(_flagFor(
      'premature_closure',
      premature,
      'You made your accusation having reviewed only ${(evidenceViewedRatio * 100).round()}% of the evidence and asked ${progress.questionsAsked.length} question(s).',
    ));

    // --- Confirmation bias: ratio of "supports:<accused>" questions asked
    // vs "challenges:<accused>" questions asked is lopsided.
    int supportsCount = 0;
    int challengesCount = 0;
    for (final qId in progress.questionsAsked) {
      final question = _findQuestion(caseFile, qId);
      if (question == null || accusedId == null) continue;
      if (question.flags.contains('supports:$accusedId')) supportsCount++;
      if (question.flags.contains('challenges:$accusedId')) challengesCount++;
    }
    final confirmationSeeking =
        accusedId != null && supportsCount >= 2 && challengesCount == 0;
    flags.add(_flagFor(
      'confirmation_bias',
      confirmationSeeking,
      'You asked $supportsCount question(s) that supported your eventual suspect and none that challenged them.',
    ));

    // --- Belief perseverance: viewed evidence that contradicts something
    // supporting the accused, but never asked a question tagged
    // "contradiction" about it.
    var ignoredContradiction = false;
    if (accusedId != null) {
      final supportingEvidenceIds = caseFile.evidence
          .where((e) => e.supportsCharacterId == accusedId)
          .map((e) => e.id)
          .toSet();
      final viewedContradictions = caseFile.evidence.where(
        (e) =>
            progress.evidenceViewed.contains(e.id) &&
            e.contradicts.any(supportingEvidenceIds.contains),
      );
      final askedAnyContradictionQuestion = progress.questionsAsked.any((qId) {
        final q = _findQuestion(caseFile, qId);
        return q != null && q.flags.contains('contradiction');
      });
      ignoredContradiction =
          viewedContradictions.isNotEmpty && !askedAnyContradictionQuestion;
    }
    flags.add(_flagFor(
      'belief_perseverance',
      ignoredContradiction,
      'You saw evidence that contradicted your eventual suspect but never questioned it further.',
    ));

    // --- Positive signal (not a bias flag, but worth surfacing): did they
    // notice the subtle evidence?
    final subtleEvidence = caseFile.evidence.where((e) => e.subtle).toList();
    final noticedSubtle = subtleEvidence.isEmpty ||
        subtleEvidence.every((e) => progress.evidenceViewed.contains(e.id));

    final triggeredCount = flags.where((f) => f.triggered).length;
    final subtlePenalty = noticedSubtle ? 0 : 10;
    final overallReasoningScore =
        (100 - (triggeredCount * 20) - subtlePenalty).clamp(0, 100);

    final summary = correct
        ? (triggeredCount == 0
            ? 'You reached the right conclusion, and your reasoning process held up — thorough, balanced, and open to being wrong.'
            : 'You reached the right conclusion, but the path there leaned on some shortcuts worth noticing.')
        : 'The evidence actually points elsewhere — see the solution below, and the flags above for what likely led you astray.';

    return CaseDebriefResult(
      correct: correct,
      flags: flags,
      overallReasoningScore: overallReasoningScore,
      summary: summary,
    );
  }

  CaseQuestion? _findQuestion(CaseFile caseFile, String questionId) {
    for (final character in caseFile.characters) {
      for (final q in character.dialogueTree) {
        if (q.id == questionId) return q;
      }
    }
    return null;
  }

  String? _questionCharacterId(CaseFile caseFile, String questionId) =>
      _findQuestion(caseFile, questionId)?.characterId;

  CognitiveBiasFlag _flagFor(String biasId, bool triggered, String evidence) {
    final def = _content.biasById(biasId);
    return CognitiveBiasFlag(
      biasName: def?.name ?? biasId,
      triggered: triggered,
      evidenceForFlag: evidence,
      explanationText: def?.explanation ??
          'This reasoning pattern can lead you away from the truth even when you feel confident.',
    );
  }
}
