import 'package:hive_ce/hive.dart';

part 'case_progress.g.dart';

@HiveType(typeId: 5)
class CaseProgress {
  CaseProgress({
    required this.caseId,
    List<String>? questionsAsked,
    List<String>? evidenceViewed,
    List<String>? suspectsMarked,
    this.solved = false,
    this.chosenCulpritId,
  }) : questionsAsked = questionsAsked ?? [],
       evidenceViewed = evidenceViewed ?? [],
       suspectsMarked = suspectsMarked ?? [];

  @HiveField(0)
  final String caseId;
  @HiveField(1)
  final List<String> questionsAsked;
  @HiveField(2)
  final List<String> evidenceViewed;
  @HiveField(3)
  final List<String> suspectsMarked;
  @HiveField(4)
  final bool solved;
  @HiveField(5)
  final String? chosenCulpritId;

  CaseProgress copyWith({
    List<String>? questionsAsked,
    List<String>? evidenceViewed,
    List<String>? suspectsMarked,
    bool? solved,
    String? chosenCulpritId,
  }) {
    return CaseProgress(
      caseId: caseId,
      questionsAsked: questionsAsked ?? this.questionsAsked,
      evidenceViewed: evidenceViewed ?? this.evidenceViewed,
      suspectsMarked: suspectsMarked ?? this.suspectsMarked,
      solved: solved ?? this.solved,
      chosenCulpritId: chosenCulpritId ?? this.chosenCulpritId,
    );
  }
}
