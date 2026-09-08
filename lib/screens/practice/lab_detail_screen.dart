import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../models/drill.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_tag_chip.dart';

class LabDetailScreen extends ConsumerWidget {
  const LabDetailScreen({super.key, required this.labCategory});

  final String labCategory;

  static const Map<DrillType, String> _typeGlyph = {
    DrillType.observationSprint: '⏱',
    DrillType.recallQuiz: '🧩',
    DrillType.multipleChoice: '❓',
    DrillType.freeTextScenario: '✍️',
    DrillType.timedPressure: '⚡',
    DrillType.breathingTimer: '🌬',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discipline = Discipline.byLabName(labCategory);
    final drills = ref.read(contentRepositoryProvider).drillsForLab(labCategory);
    drills.sort((a, b) => a.difficulty.compareTo(b.difficulty));

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(labCategory)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          children: [
            Text(discipline.tagline, style: PerceptTypography.subhead(context.textSecondary)),
            const SizedBox(height: PerceptSpacing.lg),
            for (final drill in drills)
              Padding(
                padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                child: GestureDetector(
                  onTap: () => context.push(
                    RoutePaths.withParam(RoutePaths.practiceDrill, 'drillId', drill.id),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: context.perceptSurface,
                      borderRadius: BorderRadius.circular(PerceptRadii.card),
                      border: Border.all(color: context.perceptHairline),
                    ),
                    child: Row(
                      children: [
                        Text(_typeGlyph[drill.type] ?? '•', style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: PerceptSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drill.prompt,
                                style: PerceptTypography.bodyEmphasis(context.textPrimary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  PerceptPlainChip('Difficulty ${drill.difficulty}'),
                                  const SizedBox(width: 6),
                                  PerceptPlainChip('${drill.estimatedMinutes} min'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (ref.watch(isDrillCompletedProvider(drill.id)))
                          Icon(CupertinoIcons.check_mark_circled_solid, color: context.perceptPrimary)
                        else
                          Icon(CupertinoIcons.chevron_forward, size: 18, color: context.textTertiary),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
