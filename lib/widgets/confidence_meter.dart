import 'package:flutter/cupertino.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// The visual embodiment of Reading People's core method:
/// Observation → Hypothesis → Alternative → Confidence. Renders a labeled
/// slider-style meter, used both as a display (result screens) and an
/// input (drill screens, via [onChanged]).
class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({
    super.key,
    required this.confidence,
    this.onChanged,
    this.label = 'Confidence',
  });

  final double confidence; // 0-100
  final ValueChanged<double>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: PerceptTypography.subhead(context.textSecondary)),
            const Spacer(),
            Text(
              '${confidence.round()}%',
              style: PerceptTypography.bodyEmphasis(context.perceptPrimary),
            ),
          ],
        ),
        const SizedBox(height: PerceptSpacing.xs),
        if (onChanged != null)
          CupertinoSlider(
            value: confidence,
            min: 0,
            max: 100,
            activeColor: context.perceptPrimary,
            onChanged: onChanged,
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Container(height: 8, color: context.perceptHairline),
                  Container(
                    height: 8,
                    width: constraints.maxWidth * (confidence / 100),
                    color: PerceptColors.accent,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
