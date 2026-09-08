import 'package:flutter/cupertino.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.glyph,
    required this.title,
    required this.message,
    this.action,
  });

  final String glyph;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: PerceptSpacing.xxxl,
        horizontal: PerceptSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(glyph, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: PerceptSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: PerceptTypography.title3(context.textPrimary),
          ),
          const SizedBox(height: PerceptSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: PerceptTypography.subhead(context.textSecondary),
          ),
          if (action != null) ...[
            const SizedBox(height: PerceptSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
