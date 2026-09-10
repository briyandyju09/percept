import 'dart:convert';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
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
import '../../models/library_resource.dart';
import '../content_validation.dart';

/// Loads every hand-authored JSON content file once at startup and indexes
/// it in memory. All screens read content through this repository rather
/// than touching `rootBundle` directly.
///
/// Content is loaded by PREFIX, not by a single hardcoded filename per
/// category — see [_loadShardedJsonList]. A single content JSON file over
/// ~45KB was empirically found to hang indefinitely when loaded via
/// `rootBundle.loadString` in this environment (see
/// `tool/validate_content.dart`'s size-limit check), so every category
/// that grows past that size is split into multiple numbered shard files
/// (`lessons_composure.json`, `lessons_composure_2.json`, ...) that all
/// share a prefix and get discovered via the asset manifest at load time.
/// This means adding more content is just "add another shard file with a
/// unique suffix" — no code change needed here.
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
  late final List<LibraryResource> libraryResources;

  late final Map<String, Lesson> _lessonById;
  late final Map<String, Drill> _drillById;
  late final Map<String, KnowledgeCard> _cardById;
  late final Map<String, CaseFile> _caseById;
  late final Map<String, BiasDefinition> _biasById;

  AssetManifest? _manifest;

  static const List<String> _disciplineIds = [
    'observation',
    'psychology',
    'reading_people',
    'conversation',
    'mentalism',
    'composure',
    'character',
  ];

  static const List<String> _libraryGroupIds = [
    'observation',
    'psychology',
    'reading_people',
    'conversation',
    'mentalism',
    'composure',
    'character',
    'general',
  ];

  Future<void> load() async {
    _manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    final lessonLists = await Future.wait(
      _disciplineIds.map((d) => _loadShardedJsonList('lessons_$d')),
    );
    final drillLists = await Future.wait(
      _disciplineIds.map((d) => _loadShardedJsonList('drills_$d')),
    );
    final libraryLists = await Future.wait(
      _libraryGroupIds.map((d) => _loadShardedJsonList('library_resources_$d')),
    );

    lessons = [
      for (final list in lessonLists)
        for (final item in list) Lesson.fromJson(item),
    ];
    drills = [
      for (final list in drillLists)
        for (final item in list) Drill.fromJson(item),
    ];
    libraryResources = [
      for (final list in libraryLists)
        for (final item in list) LibraryResource.fromJson(item),
    ];

    knowledgeCards = (await _loadShardedJsonList('knowledge_cards'))
        .map(KnowledgeCard.fromJson)
        .toList();
    caseFiles = (await _loadShardedJsonList('case_files'))
        .map(CaseFile.fromJson)
        .toList();
    assessmentQuestions = (await _loadShardedJsonList('assessment_questions'))
        .map(AssessmentQuestion.fromJson)
        .toList();
    onboardingGoals = (await _loadShardedJsonList('onboarding_goals'))
        .map(OnboardingGoal.fromJson)
        .toList();
    dailyChallenges = (await _loadShardedJsonList('daily_challenge_bank'))
        .map(CharacterChallenge.fromJson)
        .toList();
    biasDefinitions = (await _loadShardedJsonList('bias_definitions'))
        .map(BiasDefinition.fromJson)
        .toList();
    conversationScenarios =
        (await _loadShardedJsonList('conversation_scenarios'))
            .map(ConversationScenario.fromJson)
            .toList();

    _lessonById = {for (final l in lessons) l.id: l};
    _drillById = {for (final d in drills) d.id: d};
    _cardById = {for (final c in knowledgeCards) c.id: c};
    _caseById = {for (final c in caseFiles) c.id: c};
    _biasById = {for (final b in biasDefinitions) b.id: b};

    assert(() {
      if (!kDebugMode) return true;
      final issues = validateContent(
        lessons: lessons,
        drills: drills,
        knowledgeCards: knowledgeCards,
        caseFiles: caseFiles,
        assessmentQuestions: assessmentQuestions,
      );
      if (issues.isNotEmpty) {
        // ignore: avoid_print
        print('ContentRepository validation problems:\n${issues.join('\n')}');
      }
      return true;
    }());
  }

  /// Finds every bundled asset under `assets/content/` whose key starts
  /// with [prefix] and ends in `.json` (e.g. prefix `lessons_composure`
  /// matches both `lessons_composure.json` and any `lessons_composure_2
  /// .json`, `_3.json`, ... shard that's been added since), loads them
  /// all, and concatenates their contents in sorted (stable) order.
  Future<List<Map<String, dynamic>>> _loadShardedJsonList(
    String prefix,
  ) async {
    final fullPrefix = 'assets/content/$prefix';
    final keys =
        _manifest!.listAssets()
            .where((k) => k.startsWith(fullPrefix) && k.endsWith('.json'))
            .toList()
          ..sort();
    final lists = await Future.wait(keys.map(_loadJsonList));
    return [for (final l in lists) ...l];
  }

  Future<List<Map<String, dynamic>>> _loadJsonList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
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

  List<LibraryResource> libraryResourcesFor(String disciplineId) =>
      libraryResources.where((r) => r.disciplineId == disciplineId).toList();

  List<LibraryResource> get generalLibraryResources =>
      libraryResources.where((r) => r.disciplineId == 'general').toList();

  List<Discipline> get disciplines => Discipline.all;
}
