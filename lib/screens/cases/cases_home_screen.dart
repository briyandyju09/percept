import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/case_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';

class CasesHomeScreen extends ConsumerWidget {
  const CasesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.read(contentRepositoryProvider).caseFiles;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(largeTitle: Text('Case Files')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Interview characters, review evidence, and make a deduction. '
                    'Afterward you\'ll see how you reasoned — not just whether you were right.',
                    style: PerceptTypography.subhead(context.textSecondary),
                  ),
                  const SizedBox(height: PerceptSpacing.lg),
                  for (final caseFile in cases)
                    Builder(builder: (context) {
                      final progress = ref.watch(caseProgressProvider(caseFile.id));
                      final status = progress.solved
                          ? (progress.chosenCulpritId == caseFile.solution.correctCulpritId
                              ? 'Solved'
                              : 'Closed — incorrect')
                          : (progress.questionsAsked.isEmpty ? 'Not started' : 'In progress');
                      return PerceptCard(
                        margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                        onTap: () => context.push(
                          RoutePaths.withParam(RoutePaths.caseBriefing, 'caseId', caseFile.id),
                        ),
                        child: Row(
                          children: [
                            const Text('🕵️', style: TextStyle(fontSize: PerceptGlyphSize.row)),
                            const SizedBox(width: PerceptSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CASE #${caseFile.caseNumber.toString().padLeft(3, '0')}',
                                    style: PerceptTypography.caption(context.textTertiary),
                                  ),
                                  Text(
                                    caseFile.title,
                                    style: PerceptTypography.bodyEmphasis(context.textPrimary),
                                  ),
                                  const SizedBox(height: PerceptSpacing.xs),
                                  Text(
                                    status,
                                    style: PerceptTypography.footnote(
                                      progress.solved ? PerceptColors.success : context.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_forward, color: context.textTertiary, size: 18),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: PerceptSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
