import 'package:flutter/cupertino.dart';
import '../models/dimension_scores.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// One row of the Profile screen's dimension breakdown: glyph, label, a
/// horizontal fill bar, and the number. Used for all 7 dimensions plus the
/// derived 8th "Knowledge" stat.
class DimensionBarRow extends StatelessWidget {
  const DimensionBarRow({
    super.key,
    required this.dimensionKey,
    required this.value,
    this.color,
  });

  final String dimensionKey;
  final int value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final label = DimensionMeta.labels[dimensionKey] ?? dimensionKey;
    final glyph = DimensionMeta.glyphs[dimensionKey] ?? '•';
    final barColor = color ?? context.perceptPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(glyph, style: const TextStyle(fontSize: 16)),
          ),
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: PerceptTypography.subhead(context.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 8,
                        color: PerceptColors.hairlineLight.withValues(
                          alpha: context.textPrimary == PerceptColors.textPrimaryDark
                              ? 0.15
                              : 1,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        height: 8,
                        width: constraints.maxWidth * (value.clamp(0, 100) / 100),
                        color: barColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: PerceptSpacing.sm),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: PerceptTypography.bodyEmphasis(context.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
