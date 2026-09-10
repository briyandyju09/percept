import '../models/assessment_question.dart';
import '../models/case_file.dart';
import '../models/drill.dart';
import '../models/knowledge_card.dart';
import '../models/lesson.dart';
import '../utils/gradable_text.dart';

/// Shared content-integrity + grading-format validation, reused by
/// [ContentRepository]'s debug-mode assert at runtime AND by
/// `tool/validate_content.dart`'s standalone lint pass. Keeping the rules
/// in one place means "is this content actually gradable" is checked the
/// same way everywhere, rather than only being discovered by a user
/// hitting a dead question in the app.
///
/// Every rule here exists because it caught a REAL bug once (see the
/// Phase 2 plan): `trueFalse` questions authored with empty `options`
/// (unanswerable), `numericInput`/`multipleChoice` questions whose
/// `correctAnswer` was hedge prose instead of a real value (unpassable),
/// and `correctAnswer` values so long that token-overlap scoring couldn't
/// tell a right answer from a wrong one.
class ContentIssue {
  const ContentIssue(this.category, this.message);
  final String category;
  final String message;

  @override
  String toString() => '[$category] $message';
}

/// Validates one [DrillQuestion] (or [AssessmentQuestion], via the
/// generic-ish parameters below) against the grading rules the actual
/// engine (`drill_play_screen.dart` / `assessment_scorer.dart`) depends on.
List<ContentIssue> _validateGradableQuestion({
  required String ownerLabel,
  required String questionId,
  required String type,
  required List<String> options,
  required dynamic correctAnswer,
}) {
  final issues = <ContentIssue>[];
  final correctText = correctAnswer?.toString().trim() ?? '';

  switch (type) {
    case 'trueFalse':
      final normalizedOptions = options.map((o) => o.trim()).toSet();
      if (normalizedOptions.length != 2 ||
          !normalizedOptions.contains('True') ||
          !normalizedOptions.contains('False')) {
        issues.add(
          ContentIssue(
            'trueFalse-options',
            '$ownerLabel/$questionId: trueFalse question must have options '
                'exactly ["True","False"], found $options',
          ),
        );
      }
      if (correctText != 'True' && correctText != 'False') {
        issues.add(
          ContentIssue(
            'trueFalse-answer',
            '$ownerLabel/$questionId: trueFalse correctAnswer must be '
                '"True" or "False", found "$correctText"',
          ),
        );
      }
      break;
    case 'multipleChoice':
      if (options.isEmpty) {
        issues.add(
          ContentIssue(
            'multipleChoice-options',
            '$ownerLabel/$questionId: multipleChoice question has no options',
          ),
        );
      } else if (!options.any(
        (o) => o.trim().toLowerCase() == correctText.toLowerCase(),
      )) {
        // Note: deliberately no separate "hedge language" check here — a
        // multipleChoice correctAnswer that exactly matches one of its own
        // options is fine no matter what that option's text contains (an
        // option can legitimately say "...consider alternatives (e.g. X)"
        // as the substantively-correct choice). Hedge language only
        // matters when it's masking a missing exact match, which the
        // check above already catches.
        issues.add(
          ContentIssue(
            'multipleChoice-answer',
            '$ownerLabel/$questionId: correctAnswer "$correctText" does not '
                'exactly match any option in $options',
          ),
        );
      }
      break;
    case 'numericInput':
      if (num.tryParse(correctText) == null) {
        issues.add(
          ContentIssue(
            'numericInput-answer',
            '$ownerLabel/$questionId: numericInput correctAnswer "$correctText" '
                'is not parseable as a number',
          ),
        );
      }
      if (looksHedgy(correctText)) {
        issues.add(
          ContentIssue(
            'hedge-language',
            '$ownerLabel/$questionId: numericInput correctAnswer contains '
                'hedge language: "$correctText"',
          ),
        );
      }
      break;
    case 'textInput':
      // Open-ended by design when hedgy/long; short+non-hedgy answers are
      // graded via token overlap. Neither shape is a lint violation on its
      // own — this type intentionally supports both a quiz-style short
      // answer and a reflection prompt.
      break;
  }
  return issues;
}

/// Runs every rule against a fully-loaded content set. Returns an empty
/// list when everything's clean.
List<ContentIssue> validateContent({
  required List<Lesson> lessons,
  required List<Drill> drills,
  required List<KnowledgeCard> knowledgeCards,
  required List<CaseFile> caseFiles,
  required List<AssessmentQuestion> assessmentQuestions,
}) {
  final issues = <ContentIssue>[];

  final drillById = {for (final d in drills) d.id: d};
  final cardById = {for (final c in knowledgeCards) c.id: c};

  // --- Referential integrity (moved here from ContentRepository) ---
  for (final lesson in lessons) {
    for (final id in lesson.relatedDrillIds) {
      if (!drillById.containsKey(id)) {
        issues.add(
          ContentIssue(
            'missing-ref',
            'Lesson ${lesson.id} references missing drill $id',
          ),
        );
      }
    }
    for (final id in lesson.relatedCardIds) {
      if (!cardById.containsKey(id)) {
        issues.add(
          ContentIssue(
            'missing-ref',
            'Lesson ${lesson.id} references missing card $id',
          ),
        );
      }
    }
  }
  for (final caseFile in caseFiles) {
    final characterIds = caseFile.characters.map((c) => c.id).toSet();
    if (!characterIds.contains(caseFile.solution.correctCulpritId)) {
      issues.add(
        ContentIssue(
          'missing-ref',
          'Case ${caseFile.id} solution culprit not among characters',
        ),
      );
    }
    for (final ev in caseFile.evidence) {
      for (final contradictedId in ev.contradicts) {
        if (!caseFile.evidence.any((e) => e.id == contradictedId)) {
          issues.add(
            ContentIssue(
              'missing-ref',
              'Case ${caseFile.id} evidence ${ev.id} contradicts missing '
                  '$contradictedId',
            ),
          );
        }
      }
    }
  }

  // --- Grading-format checks: drills ---
  for (final drill in drills) {
    for (final q in drill.questions) {
      issues.addAll(
        _validateGradableQuestion(
          ownerLabel: 'drill ${drill.id}',
          questionId: q.id,
          type: q.type,
          options: q.options,
          correctAnswer: q.correctAnswer,
        ),
      );
    }
  }

  // --- Grading-format checks: assessment questions ---
  for (final q in assessmentQuestions) {
    final correctText = q.correctAnswer?.toString().trim() ?? '';
    if (q.options.isNotEmpty) {
      if (!q.options.any(
        (o) => o.trim().toLowerCase() == correctText.toLowerCase(),
      )) {
        issues.add(
          ContentIssue(
            'assessment-answer',
            'assessment ${q.id}: correctAnswer "$correctText" does not '
                'exactly match any option in ${q.options}',
          ),
        );
      }
    } else if (q.type == 'reasoningPuzzle' || q.type == 'observationRecall') {
      if (wordCount(correctText) > 12) {
        issues.add(
          ContentIssue(
            'dilution-risk',
            'assessment ${q.id} (${q.type}): correctAnswer is ${wordCount(correctText)} '
                'words long — token-overlap scoring degrades badly past ~12 '
                'words ("$correctText")',
          ),
        );
      }
    }
  }

  return issues;
}
