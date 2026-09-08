import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/case_progress_repository.dart';
import '../models/case_file.dart';
import '../models/case_progress.dart';
import '../models/completion_record.dart';
import 'repository_providers.dart';
import 'revision_providers.dart';

/// Reactive read of one case's progress — `Provider.family` re-runs
/// whenever [caseProgressRevisionProvider] bumps, which every mutating
/// action below does.
final caseProgressProvider = Provider.family<CaseProgress, String>((
  ref,
  caseId,
) {
  ref.watch(caseProgressRevisionProvider);
  return ref.read(caseProgressRepositoryProvider).load(caseId);
});

final allCaseProgressProvider = Provider((ref) {
  ref.watch(caseProgressRevisionProvider);
  return ref.read(caseProgressRepositoryProvider).all();
});

class CaseActions {
  CaseActions(this._ref);
  final Ref _ref;

  CaseProgressRepository get _repo =>
      _ref.read(caseProgressRepositoryProvider);

  Future<void> askQuestion(String caseId, CaseQuestion question) async {
    final progress = _repo.load(caseId);
    if (progress.questionsAsked.contains(question.id)) return;
    final updated = progress.copyWith(
      questionsAsked: [...progress.questionsAsked, question.id],
    );
    await _repo.save(updated);
    _bump();
  }

  Future<void> viewEvidence(String caseId, String evidenceId) async {
    final progress = _repo.load(caseId);
    if (progress.evidenceViewed.contains(evidenceId)) return;
    final updated = progress.copyWith(
      evidenceViewed: [...progress.evidenceViewed, evidenceId],
    );
    await _repo.save(updated);
    _bump();
  }

  /// Called the first time the player treats a character as a real
  /// suspect (e.g. opens an "accuse" sheet on them) — used by the
  /// reasoning analyzer to detect anchoring on whoever was suspected
  /// first.
  Future<void> markSuspect(String caseId, String characterId) async {
    final progress = _repo.load(caseId);
    if (progress.suspectsMarked.contains(characterId)) return;
    final updated = progress.copyWith(
      suspectsMarked: [...progress.suspectsMarked, characterId],
    );
    await _repo.save(updated);
    _bump();
  }

  Future<void> submitAccusation(CaseFile caseFile, String culpritId) async {
    final progress = _repo.load(caseFile.id);
    final updated = progress.copyWith(
      chosenCulpritId: culpritId,
      solved: true,
    );
    await _repo.save(updated);
    _bump();

    await _ref.read(progressRepositoryProvider).addCompletion(
      CompletionRecord(
        id: 'case-${caseFile.id}-${DateTime.now().millisecondsSinceEpoch}',
        contentId: caseFile.id,
        contentType: 'case',
        completedAt: DateTime.now(),
        resultSummary: culpritId == caseFile.solution.correctCulpritId
            ? 'solved'
            : 'incorrect',
      ),
    );
    _ref.read(completionsRevisionProvider.notifier).state++;
  }

  void _bump() => _ref.read(caseProgressRevisionProvider.notifier).state++;
}

final caseActionsProvider = Provider((ref) => CaseActions(ref));
