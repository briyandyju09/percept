import 'package:hive_ce/hive.dart';
import 'dimension_scores.dart';

part 'assessment_result.g.dart';

@HiveType(typeId: 7)
class AssessmentResult {
  AssessmentResult({
    required this.dimensionScores,
    required this.rawAnswers,
    required this.completedAt,
  });

  @HiveField(0)
  final DimensionScores dimensionScores;
  @HiveField(1)
  final Map<String, dynamic> rawAnswers;
  @HiveField(2)
  final DateTime completedAt;
}
