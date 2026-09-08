import 'package:flutter/cupertino.dart';
import '../models/daily_mission_item.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class DailyMissionCard extends StatelessWidget {
  const DailyMissionCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggle,
  });

  final DailyMissionItem item;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  static const Map<String, String> _glyphs = {
    'learn': '🧠',
    'practice': '👁',
    'socialChallenge': '🗣',
    'composure': '🧘',
    'reflect': '📓',
  };

  static const Map<String, String> _labels = {
    'learn': 'Learn',
    'practice': 'Practice',
    'socialChallenge': 'Social Challenge',
    'composure': 'Composure',
    'reflect': 'Reflect',
  };

  @override
  Widget build(BuildContext context) {
    final glyph = _glyphs[item.type] ?? '•';
    final label = _labels[item.type] ?? item.type;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
        padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
        decoration: BoxDecoration(
          color: context.perceptSurface,
          borderRadius: BorderRadius.circular(PerceptRadii.card),
          border: Border.all(color: context.perceptHairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(glyph, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: PerceptSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: PerceptTypography.caption(context.textTertiary),
                      ),
                      const SizedBox(width: PerceptSpacing.sm),
                      Text(
                        '${item.estimatedMinutes} min',
                        style: PerceptTypography.caption(context.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    style: PerceptTypography.bodyEmphasis(context.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    decoration: item.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: PerceptTypography.footnote(context.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: PerceptSpacing.sm),
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.completed
                      ? PerceptColors.success
                      : const Color(0x00000000),
                  border: Border.all(
                    color: item.completed
                        ? PerceptColors.success
                        : context.perceptHairline,
                    width: 1.5,
                  ),
                ),
                child: item.completed
                    ? const Icon(
                        CupertinoIcons.checkmark,
                        size: 14,
                        color: CupertinoColors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
