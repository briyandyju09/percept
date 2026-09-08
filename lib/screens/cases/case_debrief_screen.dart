import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class CaseDebriefScreen extends ConsumerWidget {
  const CaseDebriefScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseFile = ref.read(contentRepositoryProvider).caseById(caseId)!;
    final progress = ref.read(caseProgressRepositoryProvider).load(caseId);
    final debrief = ref.read(caseReasoningAnalyzerProvider).analyze(caseFile, progress);
    final culprit = caseFile.characters.firstWhere(
      (c) => c.id == caseFile.solution.correctCulpritId,
    );

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(automaticallyImplyLeading: false),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.md),
              Text(
                debrief.correct ? 'Correct' : 'Not quite',
                style: PerceptTypography.title1(
                  debrief.correct ? PerceptColors.success : context.textPrimary,
                ),
              ),
              const SizedBox(height: PerceptSpacing.xs),
              Text(debrief.summary, style: PerceptTypography.subhead(context.textSecondary)),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: PerceptSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(PerceptSpacing.lg),
                      decoration: BoxDecoration(
                        color: context.perceptSurfaceRaised,
                        borderRadius: BorderRadius.circular(PerceptRadii.card),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('THE SOLUTION', style: PerceptTypography.caption(context.perceptPrimary)),
                          const SizedBox(height: 4),
                          Text(
                            '${culprit.portraitEmoji} ${culprit.name} — ${culprit.role}',
                            style: PerceptTypography.bodyEmphasis(context.textPrimary),
                          ),
                          const SizedBox(height: PerceptSpacing.sm),
                          Text(
                            caseFile.solution.explanation,
                            style: PerceptTypography.body(context.textPrimary, serif: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: PerceptSpacing.lg),
                    Row(
                      children: [
                        Text('YOUR REASONING', style: PerceptTypography.caption(context.perceptPrimary)),
                        const Spacer(),
                        Text(
                          '${debrief.overallReasoningScore}/100',
                          style: PerceptTypography.bodyEmphasis(context.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: PerceptSpacing.sm),
                    for (final flag in debrief.flags)
                      Container(
                        margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                        padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                        decoration: BoxDecoration(
                          color: flag.triggered
                              ? PerceptColors.warning.withValues(alpha: 0.08)
                              : PerceptColors.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(PerceptRadii.card),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(flag.triggered ? '⚠️' : '✓', style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: PerceptSpacing.sm),
                                Expanded(
                                  child: Text(
                                    flag.biasName,
                                    style: PerceptTypography.bodyEmphasis(context.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              flag.triggered ? flag.evidenceForFlag : 'Avoided this reasoning trap.',
                              style: PerceptTypography.footnote(context.textSecondary),
                            ),
                            if (flag.triggered) ...[
                              const SizedBox(height: 4),
                              Text(
                                flag.explanationText,
                                style: PerceptTypography.footnote(context.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: PerceptSpacing.xxl),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.go(RoutePaths.cases),
                  child: const Text('Back to Cases'),
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
