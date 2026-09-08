import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/dimension_scores.dart';
import '../../routing/route_paths.dart';
import '../../state/daily_mission_providers.dart';
import '../../state/practice_providers.dart';
import '../../state/profile_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/dimension_bar_row.dart';
import '../../widgets/dimension_radar_chart.dart';
import '../../widgets/section_header.dart';

class ProfileHomeScreen extends ConsumerWidget {
  const ProfileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(dimensionScoresProvider);
    final streak = ref.watch(streakRecordProvider);
    final lessonCount = ref.watch(completionHistoryProvider)
        .where((c) => c.contentType == 'lesson')
        .length;
    final knowledgeScore = (40 + lessonCount * 2).clamp(0, 100);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Your Mind'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.push(RoutePaths.profileSettings),
                child: const Icon(CupertinoIcons.gear),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: PerceptSpacing.sm),
                  Row(
                    children: [
                      Text('🔥 ${streak.currentStreak} day streak', style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                      const Spacer(),
                      Text('Best: ${streak.longestStreak}', style: PerceptTypography.footnote(context.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: PerceptSpacing.lg),
                  Center(child: DimensionRadarChart(scores: scores)),
                  const SizedBox(height: PerceptSpacing.xl),
                  for (final key in DimensionScores.dimensionKeys)
                    DimensionBarRow(dimensionKey: key, value: scores[key]),
                  DimensionBarRow(dimensionKey: 'knowledge', value: knowledgeScore, color: PerceptColors.dimKnowledge),
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
                        Text('YOUR BIGGEST OPPORTUNITY RIGHT NOW', style: PerceptTypography.caption(context.perceptPrimary)),
                        const SizedBox(height: 4),
                        Text(
                          DimensionMeta.labels[scores.lowestDimensionKey] ?? '',
                          style: PerceptTypography.title3(context.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SectionHeader('More'),
                  _navRow(context, '📈', 'Trends over time', () => context.push(RoutePaths.profileTrends)),
                  _navRow(context, '📋', 'History', () => context.push(RoutePaths.profileHistory)),
                  _navRow(context, '🤝', 'Our philosophy', () => context.push(RoutePaths.profileEthics)),
                  const SizedBox(height: PerceptSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navRow(BuildContext context, String glyph, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.sm),
        child: Row(
          children: [
            Text(glyph, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: PerceptSpacing.md),
            Expanded(child: Text(label, style: PerceptTypography.body(context.textPrimary))),
            Icon(CupertinoIcons.chevron_forward, size: 16, color: context.textTertiary),
          ],
        ),
      ),
    );
  }
}
