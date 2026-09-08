import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/case_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class CaseEvidenceBoardScreen extends ConsumerWidget {
  const CaseEvidenceBoardScreen({super.key, required this.caseId});

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseFile = ref.read(contentRepositoryProvider).caseById(caseId)!;
    final progress = ref.watch(caseProgressProvider(caseId));

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Evidence')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          children: [
            Text(
              'Tap an item to review it — this is tracked as part of how '
              'thoroughly you investigated.',
              style: PerceptTypography.subhead(context.textSecondary),
            ),
            const SizedBox(height: PerceptSpacing.lg),
            for (final ev in caseFile.evidence)
              _EvidenceTile(
                caseId: caseId,
                evidenceId: ev.id,
                title: ev.title,
                description: ev.description,
                subtle: ev.subtle,
                viewed: progress.evidenceViewed.contains(ev.id),
              ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _EvidenceTile extends ConsumerStatefulWidget {
  const _EvidenceTile({
    required this.caseId,
    required this.evidenceId,
    required this.title,
    required this.description,
    required this.subtle,
    required this.viewed,
  });

  final String caseId;
  final String evidenceId;
  final String title;
  final String description;
  final bool subtle;
  final bool viewed;

  @override
  ConsumerState<_EvidenceTile> createState() => _EvidenceTileState();
}

class _EvidenceTileState extends ConsumerState<_EvidenceTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
      child: GestureDetector(
        onTap: () {
          setState(() => _expanded = !_expanded);
          ref.read(caseActionsProvider).viewEvidence(widget.caseId, widget.evidenceId);
        },
        child: Container(
          padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
          decoration: BoxDecoration(
            color: context.perceptSurface,
            borderRadius: BorderRadius.circular(PerceptRadii.card),
            border: Border.all(color: context.perceptHairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.viewed ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash,
                    size: 16,
                    color: widget.viewed ? context.perceptPrimary : context.textTertiary,
                  ),
                  const SizedBox(width: PerceptSpacing.sm),
                  Expanded(
                    child: Text(widget.title, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: PerceptSpacing.sm),
                Text(
                  widget.description,
                  style: PerceptTypography.body(context.textSecondary, serif: true),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
