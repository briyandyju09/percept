import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/dimension_scores.dart';
import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class DrillResultScreen extends ConsumerWidget {
  const DrillResultScreen({
    super.key,
    required this.drillId,
    required this.correctCount,
    required this.totalCount,
  });

  final String drillId;
  final int correctCount;
  final int totalCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drill = ref.read(contentRepositoryProvider).drillById(drillId);
    final percent = totalCount == 0 ? 0 : ((correctCount / totalCount) * 100).round();
    final discipline = drill == null ? null : Discipline.byId(drill.disciplineId);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(automaticallyImplyLeading: false),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          child: Column(
            children: [
              const Spacer(),
              Text(
                percent >= 70 ? '💪' : '📈',
                style: const TextStyle(fontSize: 44),
              ),
              const SizedBox(height: PerceptSpacing.lg),
              Text('$percent%', style: PerceptTypography.display(context.textPrimary)),
              const SizedBox(height: PerceptSpacing.xs),
              Text(
                '$correctCount of $totalCount correct',
                style: PerceptTypography.subhead(context.textSecondary),
              ),
              if (discipline != null) ...[
                const SizedBox(height: PerceptSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PerceptSpacing.md,
                    vertical: PerceptSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: PerceptColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(PerceptRadii.chip),
                  ),
                  child: Text(
                    '+${percent >= 70 ? 2 : 1} ${DimensionMeta.labels[discipline.primaryDimension] ?? discipline.primaryDimension}',
                    style: PerceptTypography.caption(PerceptColors.accent),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    while (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
