import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/assessment_result.dart';
import '../hive/hive_setup.dart';

class AssessmentRepository {
  Box get _box => Hive.box(HiveBoxes.assessmentResults);
  static const String _latestKey = 'latest';

  AssessmentResult? loadLatest() => _box.get(_latestKey) as AssessmentResult?;

  Future<void> save(AssessmentResult result) =>
      _box.put(_latestKey, result);
}
