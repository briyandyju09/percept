import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/case_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class CaseDeductionScreen extends ConsumerStatefulWidget {
  const CaseDeductionScreen({super.key, required this.caseId});

  final String caseId;

  @override
  ConsumerState<CaseDeductionScreen> createState() => _CaseDeductionScreenState();
}

class _CaseDeductionScreenState extends ConsumerState<CaseDeductionScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final caseFile = ref.read(contentRepositoryProvider).caseById(widget.caseId)!;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Make Your Accusation')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.md),
              Text('Who did it?', style: PerceptTypography.title1(context.textPrimary)),
              const SizedBox(height: PerceptSpacing.sm),
              Text(
                'This is final — you\'ll see the full reasoning debrief after.',
                style: PerceptTypography.footnote(context.textSecondary),
              ),
              const SizedBox(height: PerceptSpacing.lg),
              Expanded(
                child: ListView(
                  children: [
                    for (final c in caseFile.characters)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selected = c.id);
                            ref.read(caseActionsProvider).markSuspect(widget.caseId, c.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                            decoration: BoxDecoration(
                              color: _selected == c.id
                                  ? context.perceptPrimary.withValues(alpha: 0.1)
                                  : context.perceptSurface,
                              borderRadius: BorderRadius.circular(PerceptRadii.card),
                              border: Border.all(
                                color: _selected == c.id ? context.perceptPrimary : context.perceptHairline,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(c.portraitEmoji, style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: PerceptSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.name, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                                      Text(c.role, style: PerceptTypography.footnote(context.textSecondary)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _selected == null
                      ? null
                      : () async {
                          await ref
                              .read(caseActionsProvider)
                              .submitAccusation(caseFile, _selected!);
                          if (context.mounted) {
                            context.pushReplacement(
                              RoutePaths.withParam(RoutePaths.caseDebrief, 'caseId', widget.caseId),
                            );
                          }
                        },
                  child: const Text('Submit accusation'),
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
