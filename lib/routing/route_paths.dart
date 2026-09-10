/// Central registry of every route path string, so a typo is a compile
/// error at the call site (via these constants) rather than a silent
/// "route not found" at runtime.
class RoutePaths {
  RoutePaths._();

  // Onboarding (outside the tab shell)
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingGoals = '/onboarding/goals';
  static const String onboardingAssessmentIntro =
      '/onboarding/assessment-intro';
  static const String onboardingAssessmentMemory =
      '/onboarding/assessment/memory';
  static const String onboardingAssessmentObservation =
      '/onboarding/assessment/observation';
  static const String onboardingAssessmentSocial =
      '/onboarding/assessment/social';
  static const String onboardingAssessmentEmotional =
      '/onboarding/assessment/emotional';
  static const String onboardingAssessmentReasoning =
      '/onboarding/assessment/reasoning';
  static const String onboardingResults = '/onboarding/results';
  static const String onboardingProgram = '/onboarding/program';

  // Today tab
  static const String today = '/today';
  static const String todaySocialChallenge = '/today/social';
  static const String todayReflect = '/today/reflect';

  // Learn tab
  static const String learn = '/learn';
  static const String learnCard = '/learn/card/:cardId';
  static const String learnDisciplines = '/learn/disciplines';
  static const String learnDisciplineDetail = '/learn/disciplines/:disciplineId';
  static const String learnLesson = '/learn/lesson/:lessonId';
  static const String learnLessonComplete = '/learn/lesson/:lessonId/complete';
  static const String learnSaved = '/learn/saved';

  // Library tab
  static const String library = '/library';
  static const String libraryDiscipline = '/library/:disciplineId';

  // Practice tab
  static const String practice = '/practice';
  static const String practiceLab = '/practice/lab/:labCategory';
  static const String practiceObservationSprint =
      '/practice/sprint/:drillId';
  static const String practiceDrill = '/practice/drill/:drillId';
  static const String practiceDrillResult = '/practice/drill/:drillId/result';
  static const String practiceConversation =
      '/practice/conversation/:scenarioId';
  static const String practiceConversationResult =
      '/practice/conversation/:scenarioId/result';
  static const String practicePressure = '/practice/pressure/:drillId';

  // Cases tab
  static const String cases = '/cases';
  static const String caseBriefing = '/cases/:caseId/briefing';
  static const String caseInterview = '/cases/:caseId/interview';
  static const String caseEvidence = '/cases/:caseId/evidence';
  static const String caseDeduction = '/cases/:caseId/deduction';
  static const String caseDebrief = '/cases/:caseId/debrief';

  // Profile tab
  static const String profile = '/profile';
  static const String profileTrends = '/profile/trends';
  static const String profileHistory = '/profile/history';
  static const String profileSettings = '/profile/settings';
  static const String profileEthics = '/profile/ethics';

  static String withParam(String pattern, String key, String value) =>
      pattern.replaceAll(':$key', Uri.encodeComponent(value));
}
