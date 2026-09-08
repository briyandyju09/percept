import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/assessment_repository.dart';
import '../data/repositories/case_progress_repository.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/daily_mission_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/saved_cards_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../services/assessment_scorer.dart';
import '../services/case_reasoning/case_reasoning_analyzer.dart';
import '../services/case_reasoning/rule_based_case_reasoning_analyzer.dart';
import '../services/conversation/conversation_scorer.dart';
import '../services/conversation/rule_based_conversation_scorer.dart';
import '../services/daily_mission_generator.dart';
import '../services/streak_service.dart';

/// Every repository/service is provided as a plain singleton `Provider` —
/// none of them hold reactive state themselves (that lives in the
/// `Notifier`s in the other `state/*` files), so a plain `Provider` is all
/// they need.

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  throw UnimplementedError(
    'contentRepositoryProvider must be overridden after ContentRepository.load() '
    'completes in main() — see ProviderScope(overrides: ...) in main.dart.',
  );
});

final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());
final progressRepositoryProvider = Provider((ref) => ProgressRepository());
final caseProgressRepositoryProvider = Provider(
  (ref) => CaseProgressRepository(),
);
final savedCardsRepositoryProvider = Provider((ref) => SavedCardsRepository());
final assessmentRepositoryProvider = Provider((ref) => AssessmentRepository());
final dailyMissionRepositoryProvider = Provider(
  (ref) => DailyMissionRepository(),
);

final streakServiceProvider = Provider((ref) => StreakService());
final assessmentScorerProvider = Provider((ref) => AssessmentScorer());

final dailyMissionGeneratorProvider = Provider(
  (ref) => DailyMissionGenerator(ref.watch(contentRepositoryProvider)),
);

final conversationScorerProvider = Provider<ConversationScorer>(
  (ref) => RuleBasedConversationScorer(),
);

final caseReasoningAnalyzerProvider = Provider<CaseReasoningAnalyzer>(
  (ref) => RuleBasedCaseReasoningAnalyzer(ref.watch(contentRepositoryProvider)),
);
