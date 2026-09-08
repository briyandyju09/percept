import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/case_progress.dart';
import '../hive/hive_setup.dart';

class CaseProgressRepository {
  Box get _box => Hive.box(HiveBoxes.caseProgress);

  CaseProgress load(String caseId) {
    final existing = _box.get(caseId) as CaseProgress?;
    return existing ?? CaseProgress(caseId: caseId);
  }

  Future<void> save(CaseProgress progress) =>
      _box.put(progress.caseId, progress);

  List<CaseProgress> all() => _box.values.cast<CaseProgress>().toList();
}
