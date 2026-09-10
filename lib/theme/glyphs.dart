/// Single source of truth for every "glyph per content-type" lookup map —
/// previously hand-duplicated across `daily_mission_card.dart`,
/// `lab_detail_screen.dart`, and `history_log_screen.dart` independently.
/// Keyed by plain strings (matching each type's `.name`/id) rather than
/// importing model enums here, so the theme layer stays model-independent.
class PerceptGlyphs {
  PerceptGlyphs._();

  /// Daily mission item type -> glyph.
  static const Map<String, String> missionType = {
    'learn': '🧠',
    'practice': '👁',
    'socialChallenge': '🗣',
    'composure': '🧘',
    'reflect': '📓',
  };

  /// Daily mission item type -> display label.
  static const Map<String, String> missionTypeLabel = {
    'learn': 'Learn',
    'practice': 'Practice',
    'socialChallenge': 'Social Challenge',
    'composure': 'Composure',
    'reflect': 'Reflect',
  };

  /// `DrillType.name` -> glyph.
  static const Map<String, String> drillType = {
    'observationSprint': '⏱',
    'recallQuiz': '🧩',
    'multipleChoice': '❓',
    'freeTextScenario': '✍️',
    'timedPressure': '⚡',
    'breathingTimer': '🌬',
  };

  /// `CompletionRecord.contentType` -> glyph.
  static const Map<String, String> completionType = {
    'lesson': '🧠',
    'drill': '👁',
    'dailyMissionItem': '☀️',
    'conversationScenario': '🗣',
    'case': '🕵️',
  };

  /// `LibraryResource.type` -> glyph.
  static const Map<String, String> libraryResourceType = {
    'book': '📘',
    'expert': '🎓',
    'researchArea': '🔬',
    'paper': '📄',
  };
}
