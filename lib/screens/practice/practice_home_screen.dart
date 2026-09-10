import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';

class PracticeHomeScreen extends ConsumerWidget {
  const PracticeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.read(contentRepositoryProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(largeTitle: Text('Practice')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final discipline = Discipline.all[i];
                    final drills = content.drillsForLab(discipline.labName);
                    final completed = drills
                        .where((d) => ref.watch(isDrillCompletedProvider(d.id)))
                        .length;
                    return _LabTile(
                      discipline: discipline,
                      total: drills.length,
                      completed: completed,
                    );
                  },
                  childCount: Discipline.all.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: PerceptSpacing.sm,
                  crossAxisSpacing: PerceptSpacing.sm,
                  childAspectRatio: 1.05,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: PerceptSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _LabTile extends StatelessWidget {
  const _LabTile({required this.discipline, required this.total, required this.completed});

  final Discipline discipline;
  final int total;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return PerceptCard(
      onTap: () => context.push(
        RoutePaths.withParam(RoutePaths.practiceLab, 'labCategory', discipline.labName),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(discipline.icon, style: const TextStyle(fontSize: PerceptGlyphSize.row + 4)),
          const Spacer(),
          Text(discipline.labName, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
          const SizedBox(height: PerceptSpacing.xs),
          Text(
            '$completed / $total drills',
            style: PerceptTypography.footnote(context.textSecondary),
          ),
          const SizedBox(height: PerceptSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Container(height: 5, color: context.perceptHairline),
                  Container(
                    height: 5,
                    width: constraints.maxWidth * (total == 0 ? 0 : completed / total),
                    color: PerceptColors.accent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
