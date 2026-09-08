import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../screens/cases/case_briefing_screen.dart';
import '../screens/cases/case_debrief_screen.dart';
import '../screens/cases/case_deduction_screen.dart';
import '../screens/cases/case_evidence_board_screen.dart';
import '../screens/cases/case_interview_screen.dart';
import '../screens/cases/cases_home_screen.dart';
import '../screens/learn/discipline_detail_screen.dart';
import '../screens/learn/discipline_list_screen.dart';
import '../screens/learn/knowledge_graph_topic_screen.dart';
import '../screens/learn/learn_home_screen.dart';
import '../screens/learn/lesson_complete_screen.dart';
import '../screens/learn/lesson_reader_screen.dart';
import '../screens/learn/saved_cards_screen.dart';
import '../screens/onboarding/assessment_emotional_screen.dart';
import '../screens/onboarding/assessment_intro_screen.dart';
import '../screens/onboarding/assessment_memory_screen.dart';
import '../screens/onboarding/assessment_observation_screen.dart';
import '../screens/onboarding/assessment_reasoning_screen.dart';
import '../screens/onboarding/assessment_results_screen.dart';
import '../screens/onboarding/assessment_social_screen.dart';
import '../screens/onboarding/goal_selection_screen.dart';
import '../screens/onboarding/program_generated_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/practice/conversation_result_screen.dart';
import '../screens/practice/conversation_simulator_screen.dart';
import '../screens/practice/drill_play_screen.dart';
import '../screens/practice/drill_result_screen.dart';
import '../screens/practice/lab_detail_screen.dart';
import '../screens/practice/practice_home_screen.dart';
import '../screens/profile/about_ethics_screen.dart';
import '../screens/profile/history_log_screen.dart';
import '../screens/profile/profile_home_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/trend_charts_screen.dart';
import '../screens/today/reflect_prompt_screen.dart';
import '../screens/today/social_challenge_detail_screen.dart';
import '../screens/today/today_home_screen.dart';
import '../shell/percept_tab_shell.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter({required bool onboardingCompleted}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation:
        onboardingCompleted ? RoutePaths.today : RoutePaths.onboardingWelcome,
    routes: [
      GoRoute(
        path: RoutePaths.onboardingWelcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingGoals,
        builder: (context, state) => const GoalSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentIntro,
        builder: (context, state) => const AssessmentIntroScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentMemory,
        builder: (context, state) => const AssessmentMemoryScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentObservation,
        builder: (context, state) => const AssessmentObservationScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentSocial,
        builder: (context, state) => const AssessmentSocialScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentEmotional,
        builder: (context, state) => const AssessmentEmotionalScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingAssessmentReasoning,
        builder: (context, state) => const AssessmentReasoningScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingResults,
        builder: (context, state) => const AssessmentResultsScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboardingProgram,
        builder: (context, state) => const ProgramGeneratedScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            PerceptTabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.today,
                builder: (context, state) => const TodayHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'social',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) =>
                        const SocialChallengeDetailScreen(),
                  ),
                  GoRoute(
                    path: 'reflect',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ReflectPromptScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.learn,
                builder: (context, state) => const LearnHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'disciplines',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const DisciplineListScreen(),
                  ),
                  GoRoute(
                    path: 'disciplines/:disciplineId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => DisciplineDetailScreen(
                      disciplineId: state.pathParameters['disciplineId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'lesson/:lessonId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => LessonReaderScreen(
                      lessonId: state.pathParameters['lessonId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'lesson/:lessonId/complete',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => LessonCompleteScreen(
                      lessonId: state.pathParameters['lessonId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'topic/:disciplineId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => KnowledgeGraphTopicScreen(
                      disciplineId: state.pathParameters['disciplineId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'saved',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SavedCardsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.practice,
                builder: (context, state) => const PracticeHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'lab/:labCategory',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => LabDetailScreen(
                      labCategory: state.pathParameters['labCategory']!,
                    ),
                  ),
                  GoRoute(
                    path: 'drill/:drillId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => DrillPlayScreen(
                      drillId: state.pathParameters['drillId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'drill/:drillId/result',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => DrillResultScreen(
                      drillId: state.pathParameters['drillId']!,
                      correctCount: (state.extra as Map?)?['correctCount'] ?? 0,
                      totalCount: (state.extra as Map?)?['totalCount'] ?? 1,
                    ),
                  ),
                  GoRoute(
                    path: 'conversation/:scenarioId',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => ConversationSimulatorScreen(
                      scenarioId: state.pathParameters['scenarioId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'conversation/:scenarioId/result',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const ConversationResultScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.cases,
                builder: (context, state) => const CasesHomeScreen(),
                routes: [
                  GoRoute(
                    path: ':caseId/briefing',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => CaseBriefingScreen(
                      caseId: state.pathParameters['caseId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':caseId/interview',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => CaseInterviewScreen(
                      caseId: state.pathParameters['caseId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':caseId/evidence',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => CaseEvidenceBoardScreen(
                      caseId: state.pathParameters['caseId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':caseId/deduction',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => CaseDeductionScreen(
                      caseId: state.pathParameters['caseId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':caseId/debrief',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => CaseDebriefScreen(
                      caseId: state.pathParameters['caseId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (context, state) => const ProfileHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'trends',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const TrendChartsScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const HistoryLogScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'ethics',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) => const AboutEthicsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
