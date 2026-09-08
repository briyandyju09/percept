import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class CaseBriefingScreen extends ConsumerWidget {
  const CaseBriefingScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseFile = ref.read(contentRepositoryProvider).caseById(caseId)!;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Case #${caseFile.caseNumber.toString().padLeft(3, '0')}'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.md),
              Text(caseFile.title, style: PerceptTypography.title1(context.textPrimary)),
              const SizedBox(height: PerceptSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caseFile.briefing,
                        style: PerceptTypography.body(context.textPrimary, serif: true),
                      ),
                      const SizedBox(height: PerceptSpacing.xl),
                      Text('CHARACTERS', style: PerceptTypography.caption(context.perceptPrimary)),
                      const SizedBox(height: PerceptSpacing.sm),
                      Wrap(
                        spacing: PerceptSpacing.sm,
                        runSpacing: PerceptSpacing.sm,
                        children: [
                          for (final c in caseFile.characters)
                            _chip(context, '${c.portraitEmoji} ${c.name} — ${c.role}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.push(
                    RoutePaths.withParam(RoutePaths.caseInterview, 'caseId', caseId),
                  ),
                  child: const Text('Begin the investigation'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.md, vertical: PerceptSpacing.xs),
    decoration: BoxDecoration(
      color: context.perceptSurfaceRaised,
      borderRadius: BorderRadius.circular(PerceptRadii.chip),
      border: Border.all(color: context.perceptHairline),
    ),
    child: Text(text, style: PerceptTypography.footnote(context.textPrimary)),
  );
}
