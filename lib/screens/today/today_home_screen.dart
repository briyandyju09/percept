import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/daily_mission_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/daily_mission_card.dart';

class TodayHomeScreen extends ConsumerWidget {
  const TodayHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dailyMissionProvider);
    final notifier = ref.read(dailyMissionProvider.notifier);
    final streak = ref.watch(streakRecordProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Today'),
              trailing: streak.currentStreak > 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 2),
                        Text(
                          '${streak.currentStreak}',
                          style: PerceptTypography.bodyEmphasis(PerceptColors.accent),
                        ),
                      ],
                    )
                  : null,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: PerceptSpacing.screenMargin,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: PerceptSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '${notifier.completedCount}/${items.length} done',
                        style: PerceptTypography.subhead(context.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        '${notifier.totalMinutes} min total',
                        style: PerceptTypography.subhead(context.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: PerceptSpacing.md),
                  for (final item in items)
                    DailyMissionCard(
                      item: item,
                      onToggle: () => notifier.toggleComplete(item.id),
                      onTap: () => _openItem(context, ref, item.type, item.refContentId),
                    ),
                  const SizedBox(height: PerceptSpacing.xxl),
                  if (notifier.allComplete)
                    Container(
                      padding: const EdgeInsets.all(PerceptSpacing.lg),
                      decoration: BoxDecoration(
                        color: PerceptColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(PerceptRadii.card),
                      ),
                      child: Text(
                        'Today\'s mission is complete. See you tomorrow.',
                        style: PerceptTypography.bodyEmphasis(context.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: PerceptSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openItem(BuildContext context, WidgetRef ref, String type, String refId) {
    switch (type) {
      case 'learn':
        if (refId.isNotEmpty) {
          context.push(RoutePaths.withParam(RoutePaths.learnLesson, 'lessonId', refId));
        }
        break;
      case 'practice':
        if (refId.isNotEmpty) {
          context.push(RoutePaths.withParam(RoutePaths.practiceDrill, 'drillId', refId));
        }
        break;
      case 'socialChallenge':
        context.push(RoutePaths.todaySocialChallenge);
        break;
      case 'composure':
        if (refId.isNotEmpty) {
          context.push(RoutePaths.withParam(RoutePaths.practiceDrill, 'drillId', refId));
        }
        break;
      case 'reflect':
        context.push(RoutePaths.todayReflect);
        break;
    }
  }
}
