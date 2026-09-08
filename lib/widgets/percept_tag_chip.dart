import 'package:flutter/cupertino.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

enum PerceptTag { performance, psychology, risk, ethical }

extension PerceptTagMeta on PerceptTag {
  String get glyph => switch (this) {
    PerceptTag.performance => '🎭',
    PerceptTag.psychology => '🧠',
    PerceptTag.risk => '⚠️',
    PerceptTag.ethical => '🤝',
  };

  String get label => switch (this) {
    PerceptTag.performance => 'Performance',
    PerceptTag.psychology => 'Psychological principle',
    PerceptTag.risk => 'Manipulation risk',
    PerceptTag.ethical => 'Ethical use',
  };

  Color get color => switch (this) {
    PerceptTag.performance => PerceptColors.tagPerformance,
    PerceptTag.psychology => PerceptColors.tagPsychology,
    PerceptTag.risk => PerceptColors.tagRisk,
    PerceptTag.ethical => PerceptColors.tagEthical,
  };
}

/// The 🎭/🧠/⚠️/🤝 ethical-tag pill used throughout the Mentalism &
/// Performance discipline, and anywhere else a technique needs an honest
/// label about how it should and shouldn't be used.
class PerceptTagChip extends StatelessWidget {
  const PerceptTagChip(this.tag, {super.key, this.compact = false});

  final PerceptTag tag;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? PerceptSpacing.sm : PerceptSpacing.md,
        vertical: PerceptSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(PerceptRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag.glyph, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: PerceptTypography.caption(tag.color),
          ),
        ],
      ),
    );
  }
}

/// A plain topic/discipline tag pill (not an ethical tag) for lesson tags,
/// card tags, etc.
class PerceptPlainChip extends StatelessWidget {
  const PerceptPlainChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PerceptSpacing.md,
        vertical: PerceptSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.perceptSurfaceRaised,
        borderRadius: BorderRadius.circular(PerceptRadii.chip),
        border: Border.all(color: context.perceptHairline),
      ),
      child: Text(label, style: PerceptTypography.caption(context.textSecondary)),
    );
  }
}
