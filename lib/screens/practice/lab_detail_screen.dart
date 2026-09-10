import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/glyphs.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';

class LabDetailScreen extends ConsumerWidget {
  const LabDetailScreen({super.key, required this.labCategory});

  final String labCategory;

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
              PerceptCard(
                margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                onTap: () => context.push(
                  RoutePaths.withParam(RoutePaths.practiceDrill, 'drillId', drill.id),
                ),
                child: Row(
                  children: [
                    Text(
                      PerceptGlyphs.drillType[drill.type.name] ?? '•',
                      style: const TextStyle(fontSize: PerceptGlyphSize.row),
                    ),
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
                          const SizedBox(height: PerceptSpacing.xs),
                          PerceptMetaLine([
                            'Difficulty ${drill.difficulty}',
                            '${drill.estimatedMinutes} min',
                          ]),
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
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
