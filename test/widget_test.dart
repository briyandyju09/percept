// Percept smoke test: boots the real app against a temp Hive directory and
// confirms a fresh profile lands on the onboarding Welcome screen.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:percept/app.dart';
import 'package:percept/data/hive/hive_setup.dart';
import 'package:percept/data/repositories/content_repository.dart';
import 'package:percept/hive_registrar.g.dart';
import 'package:percept/state/repository_providers.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('percept_test_hive');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    await Future.wait([
      Hive.openBox(HiveBoxes.profile),
      Hive.openBox(HiveBoxes.assessmentResults),
      Hive.openBox(HiveBoxes.completions),
      Hive.openBox(HiveBoxes.streak),
      Hive.openBox(HiveBoxes.dailyMissions),
      Hive.openBox(HiveBoxes.savedCards),
      Hive.openBox(HiveBoxes.caseProgress),
      Hive.openBox(HiveBoxes.progressEntries),
      Hive.openBox(HiveBoxes.settings),
    ]);
  });

  tearDown(() async {
    // Note: intentionally not calling Hive.close() here — on this platform
    // it hangs waiting on a lock-file handle that never releases inside
    // the test harness's isolate, even though the app itself works fine
    // (verified: the widget tree builds and renders correctly before this
    // teardown ever runs). Each test gets a fresh temp directory via
    // setUp, so a clean close isn't needed for test isolation here; this
    // is a best-effort delete only.
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (_) {
      // Best-effort cleanup only.
    }
  });

  testWidgets('fresh install lands on the onboarding welcome screen', (
    tester,
  ) async {
    final content = ContentRepository();
    await content.load();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [contentRepositoryProvider.overrideWithValue(content)],
        child: const PerceptApp(),
      ),
    );
    // A bounded pump rather than pumpAndSettle(): this screen has no
    // finite-duration animations to wait out.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Percept'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 20)));
}
