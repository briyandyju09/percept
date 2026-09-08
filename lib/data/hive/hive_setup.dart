import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../hive_registrar.g.dart';

/// Central registry of every Hive box name used by Percept. Keeping these
/// as constants (instead of inline strings scattered across repositories)
/// means a typo becomes a compile error, not a silent empty box at runtime.
class HiveBoxes {
  HiveBoxes._();

  static const String profile = 'profile';
  static const String assessmentResults = 'assessmentResults';
  static const String completions = 'completions';
  static const String streak = 'streak';
  static const String dailyMissions = 'dailyMissions';
  static const String savedCards = 'savedCards';
  static const String caseProgress = 'caseProgress';
  static const String progressEntries = 'progressEntries';
  static const String settings = 'settings';
}

/// Initializes Hive CE and opens every box the app needs. Call once, before
/// `runApp`, and `await` it.
Future<void> setUpHive() async {
  await Hive.initFlutter();
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
}
