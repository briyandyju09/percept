import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/onboarding_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class GoalSelectionScreen extends ConsumerWidget {
  const GoalSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(contentRepositoryProvider).onboardingGoals;
    final draft = ref.watch(onboardingDraftProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('What do you want to become?'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: PerceptSpacing.screenMargin,
                  vertical: PerceptSpacing.md,
                ),
                children: [
                  Text(
                    'Choose as many as you like. Percept builds your first '
                    'training program around these.',
                    style: PerceptTypography.subhead(context.textSecondary),
                  ),
                  const SizedBox(height: PerceptSpacing.lg),
                  for (final goal in goals)
                    _GoalTile(
                      label: goal.label,
                      icon: goal.icon,
                      selected: draft.goals.contains(goal.id),
                      onTap: () => ref
                          .read(onboardingDraftProvider.notifier)
                          .toggleGoal(goal.id),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: draft.goals.isEmpty
                      ? null
                      : () async {
                          await ref
                              .read(profileProvider.notifier)
                              .setGoals(draft.goals);
                          if (context.mounted) {
                            context.go(RoutePaths.onboardingAssessmentIntro);
                          }
                        },
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
        padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
        decoration: BoxDecoration(
          color: selected
              ? context.perceptPrimary.withValues(alpha: 0.1)
              : context.perceptSurface,
          borderRadius: BorderRadius.circular(PerceptRadii.card),
          border: Border.all(
            color: selected ? context.perceptPrimary : context.perceptHairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: PerceptSpacing.md),
            Expanded(
              child: Text(
                label,
                style: PerceptTypography.bodyEmphasis(context.textPrimary),
              ),
            ),
            Icon(
              selected
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: selected ? context.perceptPrimary : context.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
