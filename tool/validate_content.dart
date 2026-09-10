// Standalone content lint: `dart run tool/validate_content.dart`
//
// Loads every file in assets/content/ directly off disk (no Flutter
// engine needed) through the same model classes and validation rules
// ContentRepository uses at runtime, and prints a pass/fail report. Run
// this after any content-authoring pass — new or edited JSON — before
// considering that work done.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:percept/data/content_validation.dart';
import 'package:percept/models/assessment_question.dart';
import 'package:percept/models/case_file.dart';
import 'package:percept/models/drill.dart';
import 'package:percept/models/knowledge_card.dart';
import 'package:percept/models/lesson.dart';

const _disciplineIds = [
  'observation',
  'psychology',
  'reading_people',
  'conversation',
  'mentalism',
  'composure',
  'character',
];

/// Empirically confirmed on this machine (binary search with synthetic
/// files): a 41KB file loaded via `rootBundle.loadString` in `flutter
/// test` loads instantly; a 51KB one hangs indefinitely (likely a Windows
/// dev-transport buffer limit, not a Flutter/Dart bug per se). This limit
/// sits at 45KB — comfortably below the confirmed 51KB hang point, with
/// enough margin below it that content authoring should treat 45KB as a
/// hard ceiling, not a target to approach. Every content file must stay
/// under this, so content authoring always shards by a natural key
/// (discipline, lab, case) rather than growing one big file.
const _maxSafeFileBytes = 45 * 1024;

/// Mirrors `ContentRepository._loadShardedJsonList`: finds every file in
/// [contentDir] whose name starts with [prefix] and ends in `.json`
/// (`lessons_composure.json`, `lessons_composure_2.json`, ...), sorted for
/// stable ordering, and concatenates their contents.
List<Map<String, dynamic>> _loadShardedJsonList(String contentDir, String prefix) {
  final dir = Directory(contentDir);
  final matches = dir
      .listSync()
      .whereType<File>()
      .where((f) {
        final name = f.uri.pathSegments.last;
        return name.startsWith(prefix) && name.endsWith('.json');
      })
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final result = <Map<String, dynamic>>[];
  for (final file in matches) {
    final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    result.addAll(decoded.cast<Map<String, dynamic>>());
  }
  return result;
}

List<ContentIssue> _checkFileSizes(String contentDir) {
  final issues = <ContentIssue>[];
  final dir = Directory(contentDir);
  for (final entry in dir.listSync()) {
    if (entry is! File || !entry.path.endsWith('.json')) continue;
    final size = entry.lengthSync();
    if (size > _maxSafeFileBytes) {
      issues.add(
        ContentIssue(
          'file-too-large',
          '${entry.path} is $size bytes (limit $_maxSafeFileBytes) — split '
              'it by discipline/lab/case before this hangs flutter_test '
              'and possibly debug-mode asset loading',
        ),
      );
    }
  }
  return issues;
}

void main() {
  const contentDir = 'assets/content';

  final lessons = [
    for (final d in _disciplineIds)
      for (final item in _loadShardedJsonList(contentDir, 'lessons_$d'))
        Lesson.fromJson(item),
  ];
  final drills = [
    for (final d in _disciplineIds)
      for (final item in _loadShardedJsonList(contentDir, 'drills_$d'))
        Drill.fromJson(item),
  ];
  final knowledgeCards = _loadShardedJsonList(contentDir, 'knowledge_cards')
      .map(KnowledgeCard.fromJson)
      .toList();
  final caseFiles = _loadShardedJsonList(contentDir, 'case_files')
      .map(CaseFile.fromJson)
      .toList();
  final assessmentQuestions =
      _loadShardedJsonList(contentDir, 'assessment_questions')
          .map(AssessmentQuestion.fromJson)
          .toList();

  print(
    'Loaded ${lessons.length} lessons, ${drills.length} drills, '
    '${knowledgeCards.length} knowledge cards, ${caseFiles.length} case '
    'files, ${assessmentQuestions.length} assessment questions.',
  );

  final issues = [
    ...validateContent(
      lessons: lessons,
      drills: drills,
      knowledgeCards: knowledgeCards,
      caseFiles: caseFiles,
      assessmentQuestions: assessmentQuestions,
    ),
    ..._checkFileSizes(contentDir),
  ];

  if (issues.isEmpty) {
    print('✓ No content validation issues found.');
    exit(0);
  }

  print('\n✗ ${issues.length} content validation issue(s) found:\n');
  final byCategory = <String, List<ContentIssue>>{};
  for (final issue in issues) {
    byCategory.putIfAbsent(issue.category, () => []).add(issue);
  }
  for (final entry in byCategory.entries) {
    print('-- ${entry.key} (${entry.value.length}) --');
    for (final issue in entry.value) {
      print('  ${issue.message}');
    }
  }
  exit(1);
}
