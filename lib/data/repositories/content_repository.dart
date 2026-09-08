import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kDebugMode;

import '../../models/assessment_question.dart';
import '../../models/bias_definition.dart';
import '../../models/case_file.dart';
import '../../models/character_challenge.dart';
import '../../models/conversation.dart';
import '../../models/discipline.dart';
import '../../models/drill.dart';
import '../../models/knowledge_card.dart';
import '../../models/lesson.dart';
import '../../models/onboarding_goal.dart';

/// Loads every hand-authored JSON content file once at startup and indexes
/// it in memory. All screens read content through this repository rather
/// than touching `rootBundle` directly.
class ContentRepository {
  late final List<Lesson> lessons;
  late final List<Drill> drills;
  late final List<KnowledgeCard> knowledgeCards;
  late final List<CaseFile> caseFiles;
  late final List<AssessmentQuestion> assessmentQuestions;
  late final List<OnboardingGoal> onboardingGoals;
  late final List<CharacterChallenge> dailyChallenges;
  late final List<BiasDefinition> biasDefinitions;
  late final List<ConversationScenario> conversationScenarios;

  late final Map<String, Lesson> _lessonById;
  late final Map<String, Drill> _drillById;
  late final Map<String, KnowledgeCard> _cardById;
  late final Map<String, CaseFile> _caseById;
  late final Map<String, BiasDefinition> _biasById;

  static const List<String> _disciplineIds = [
    'observation',
    'psychology',
    'reading_people',
    'conversation',
    'mentalism',
    'composure',
    'character',
  ];

  Future<void> load() async {
    final lessonLists = await Future.wait(
      _disciplineIds.map((d) => _loadJsonList('assets/content/lessons_$d.json')),
    );
    final drillLists = await Future.wait(
      _disciplineIds.map((d) => _loadJsonList('assets/content/drills_$d.json')),
    );

    lessons = [
      for (final list in lessonLists)
        for (final item in list) Lesson.fromJson(item),
    ];
    drills = [
      for (final list in drillLists)
        for (final item in list) Drill.fromJson(item),
    ];

    knowledgeCards = (await _loadJsonList('assets/content/knowledge_cards.json'))
        .map(KnowledgeCard.fromJson)
        .toList();
    caseFiles = (await _loadJsonList('assets/content/case_files.json'))
        .map(CaseFile.fromJson)
        .toList();
    assessmentQuestions =
        (await _loadJsonList('assets/content/assessment_questions.json'))
            .map(AssessmentQuestion.fromJson)
            .toList();
    onboardingGoals = (await _loadJsonList('assets/content/onboarding_goals.json'))
        .map(OnboardingGoal.fromJson)
        .toList();
    dailyChallenges =
        (await _loadJsonList('assets/content/daily_challenge_bank.json'))
            .map(CharacterChallenge.fromJson)
            .toList();
    biasDefinitions = (await _loadJsonList('assets/content/bias_definitions.json'))
        .map(BiasDefinition.fromJson)
        .toList();
    conversationScenarios =
        (await _loadJsonList('assets/content/conversation_scenarios.json'))
            .map(ConversationScenario.fromJson)
            .toList();

    _lessonById = {for (final l in lessons) l.id: l};
    _drillById = {for (final d in drills) d.id: d};
    _cardById = {for (final c in knowledgeCards) c.id: c};
    _caseById = {for (final c in caseFiles) c.id: c};
    _biasById = {for (final b in biasDefinitions) b.id: b};

    assert(_checkReferentialIntegrity());
  }

  Future<List<Map<String, dynamic>>> _loadJsonList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  bool _checkReferentialIntegrity() {
    if (!kDebugMode) return true;
    final problems = <String>[];
    for (final lesson in lessons) {
      for (final id in lesson.relatedDrillIds) {
        if (!_drillById.containsKey(id)) {
          problems.add('Lesson ${lesson.id} references missing drill $id');
        }
      }
      for (final id in lesson.relatedCardIds) {
        if (!_cardById.containsKey(id)) {
          problems.add('Lesson ${lesson.id} references missing card $id');
        }
      }
    }
    for (final caseFile in caseFiles) {
      final characterIds = caseFile.characters.map((c) => c.id).toSet();
      if (!characterIds.contains(caseFile.solution.correctCulpritId)) {
        problems.add(
          'Case ${caseFile.id} solution culprit not among characters',
        );
      }
      for (final ev in caseFile.evidence) {
        for (final contradictedId in ev.contradicts) {
          if (!caseFile.evidence.any((e) => e.id == contradictedId)) {
            problems.add(
              'Case ${caseFile.id} evidence ${ev.id} contradicts missing $contradictedId',
            );
          }
        }
      }
    }
    if (problems.isNotEmpty) {
      // ignore: avoid_print
      print('ContentRepository referential integrity problems:\n'
          '${problems.join('\n')}');
    }
    return true;
  }

  // --- Lookups ---

  Lesson? lessonById(String id) => _lessonById[id];
  Drill? drillById(String id) => _drillById[id];
  KnowledgeCard? cardById(String id) => _cardById[id];
  CaseFile? caseById(String id) => _caseById[id];
  BiasDefinition? biasById(String id) => _biasById[id];

  List<Lesson> lessonsFor(String disciplineId) =>
      lessons.where((l) => l.disciplineId == disciplineId).toList();

  List<Drill> drillsFor(String disciplineId) =>
      drills.where((d) => d.disciplineId == disciplineId).toList();

  List<Drill> drillsForLab(String labCategory) =>
      drills.where((d) => d.labCategory == labCategory).toList();

  List<KnowledgeCard> cardsFor(String disciplineId) =>
      knowledgeCards.where((c) => c.disciplineId == disciplineId).toList();

  List<Discipline> get disciplines => Discipline.all;
}
