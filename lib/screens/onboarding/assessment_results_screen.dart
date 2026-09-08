import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/dimension_scores.dart';
import '../../routing/route_paths.dart';
import '../../state/onboarding_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/dimension_bar_row.dart';
import '../../widgets/dimension_radar_chart.dart';

class AssessmentResultsScreen extends ConsumerStatefulWidget {
  const AssessmentResultsScreen({super.key});

  @override
  ConsumerState<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState
    extends ConsumerState<AssessmentResultsScreen> {
  DimensionScores? _scores;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _computeScores());
  }

  void _computeScores() {
    final draft = ref.read(onboardingDraftProvider);
    final questions = ref.read(contentRepositoryProvider).assessmentQuestions;
    final result = ref
        .read(assessmentScorerProvider)
        .score(questions, draft.answers);
    ref.read(assessmentRepositoryProvider).save(result);
    ref.read(profileProvider.notifier).applyAssessment(result.dimensionScores);
    setState(() => _scores = result.dimensionScores);
  }

  @override
  Widget build(BuildContext context) {
    final scores = _scores;
    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Your Profile'),
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: scores == null
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PerceptSpacing.screenMargin,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: PerceptSpacing.lg),
                          Center(child: DimensionRadarChart(scores: scores)),
                          const SizedBox(height: PerceptSpacing.xl),
                          for (final key in DimensionScores.dimensionKeys)
                            DimensionBarRow(dimensionKey: key, value: scores[key]),
                          const SizedBox(height: PerceptSpacing.lg),
                          Container(
                            padding: const EdgeInsets.all(PerceptSpacing.lg),
                            decoration: BoxDecoration(
                              color: context.perceptPrimary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(PerceptRadii.card),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'YOUR BIGGEST OPPORTUNITY',
                                  style: PerceptTypography.caption(context.perceptPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DimensionMeta.labels[scores.lowestDimensionKey] ?? '',
                                  style: PerceptTypography.title3(context.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your first training program focuses here — the '
                                  'rest of your profile grows alongside it as you practice.',
                                  style: PerceptTypography.footnote(context.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: PerceptSpacing.md,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: () =>
                              context.go(RoutePaths.onboardingProgram),
                          child: const Text('Build my program'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
