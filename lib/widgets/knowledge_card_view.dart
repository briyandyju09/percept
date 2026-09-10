import 'package:flutter/cupertino.dart';
import '../models/discipline.dart';
import '../models/knowledge_card.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// The Deepstash-style swipeable idea card: Hook -> Concept -> Try It ->
/// Why, plus Save/Discuss actions.
class KnowledgeCardView extends StatelessWidget {
  const KnowledgeCardView({
    super.key,
    required this.card,
    required this.isSaved,
    required this.onSaveToggle,
  });

  final KnowledgeCard card;
  final bool isSaved;
  final VoidCallback onSaveToggle;

  @override
  Widget build(BuildContext context) {
    final discipline = Discipline.byId(card.disciplineId);

    return Container(
      padding: const EdgeInsets.all(PerceptSpacing.xl),
      decoration: BoxDecoration(
        color: context.perceptSurface,
        borderRadius: BorderRadius.circular(PerceptRadii.sheet),
        border: Border.all(color: context.perceptHairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(discipline.icon, style: const TextStyle(fontSize: PerceptGlyphSize.inline)),
              const SizedBox(width: PerceptSpacing.xs),
              Text(
                discipline.name.toUpperCase(),
                style: PerceptTypography.caption(context.textTertiary),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSaveToggle,
                child: Icon(
                  isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                  color: isSaved ? PerceptColors.accent : context.textTertiary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: PerceptSpacing.lg),
          Text(
            card.hook,
            style: PerceptTypography.title2(context.textPrimary),
          ),
          const SizedBox(height: PerceptSpacing.lg),
          _sectionLabel(context, 'CONCEPT'),
          const SizedBox(height: 4),
          Text(card.concept, style: PerceptTypography.body(context.textPrimary)),
          const SizedBox(height: PerceptSpacing.lg),
          _sectionLabel(context, 'TRY IT'),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(PerceptSpacing.md),
            decoration: BoxDecoration(
              color: PerceptColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(PerceptRadii.chip),
            ),
            child: Text(
              card.tryIt,
              style: PerceptTypography.bodyEmphasis(context.textPrimary),
            ),
          ),
          const SizedBox(height: PerceptSpacing.lg),
          _sectionLabel(context, 'WHY?'),
          const SizedBox(height: 4),
          Text(
            card.whyExplanation,
            style: PerceptTypography.subhead(context.textSecondary),
          ),
          if (card.sourceCitation != null) ...[
            const SizedBox(height: PerceptSpacing.sm),
            Text(
              card.sourceCitation!,
              style: PerceptTypography.footnote(context.textTertiary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) => Text(
    label,
    style: PerceptTypography.caption(context.perceptPrimary),
  );
}
