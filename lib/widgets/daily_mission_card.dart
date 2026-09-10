import 'package:flutter/cupertino.dart';
import '../models/daily_mission_item.dart';
import '../theme/colors.dart';
import '../theme/glyphs.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import 'percept_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final glyph = PerceptGlyphs.missionType[item.type] ?? '•';
    final label = PerceptGlyphs.missionTypeLabel[item.type] ?? item.type;

    return PerceptCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(glyph, style: const TextStyle(fontSize: PerceptGlyphSize.row)),
          const SizedBox(width: PerceptSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PerceptMetaLine([label.toUpperCase(), '${item.estimatedMinutes} min']),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: PerceptTypography.bodyEmphasis(context.textPrimary).copyWith(
                    decoration: item.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                    : CupertinoColors.transparent,
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
    );
  }
}
