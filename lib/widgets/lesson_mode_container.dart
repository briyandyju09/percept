import 'package:flutter/cupertino.dart';
import '../models/lesson.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Renders a [Lesson]'s blocks with a layout that visually matches its
/// [LessonMode] — this is v1's stand-in for real audio narration modes
/// (idea.txt's Quick Brief / Deep Dive / Story / Socratic / Case Study /
/// Coach), each with a distinct reading treatment rather than a real TTS
/// pipeline.
class LessonModeContainer extends StatelessWidget {
  const LessonModeContainer({super.key, required this.lesson});

  final Lesson lesson;

  String get _modeLabel => switch (lesson.mode) {
    LessonMode.quickBrief => 'QUICK BRIEF',
    LessonMode.deepDive => 'DEEP DIVE',
    LessonMode.story => 'STORY MODE',
    LessonMode.socratic => 'SOCRATIC',
    LessonMode.caseStudy => 'CASE STUDY',
    LessonMode.coach => 'COACH',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.md,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: context.perceptSurfaceRaised,
            borderRadius: BorderRadius.circular(PerceptRadii.chip),
            border: Border.all(color: context.perceptHairline),
          ),
          child: Text(_modeLabel, style: PerceptTypography.caption(context.perceptPrimary)),
        ),
        const SizedBox(height: PerceptSpacing.lg),
        for (final block in lesson.blocks) ...[
          _buildBlock(context, block),
          const SizedBox(height: PerceptSpacing.lg),
        ],
      ],
    );
  }

  Widget _buildBlock(BuildContext context, LessonBlock block) {
    switch (block.type) {
      case 'keyPoint':
        return Container(
          padding: const EdgeInsets.all(PerceptSpacing.lg),
          decoration: BoxDecoration(
            color: context.perceptPrimary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(PerceptRadii.card),
          ),
          child: Text(
            block.text,
            style: PerceptTypography.bodyEmphasis(
              context.textPrimary,
              serif: true,
            ),
          ),
        );
      case 'quote':
        return Padding(
          padding: const EdgeInsets.only(left: PerceptSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: PerceptColors.accent, width: 3),
              ),
            ),
            padding: const EdgeInsets.only(left: PerceptSpacing.md),
            child: Text(
              block.text,
              style: PerceptTypography.body(
                context.textSecondary,
                serif: true,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        );
      case 'mythVsFact':
        final myth = block.meta?['myth'] as String? ?? '';
        final fact = block.meta?['fact'] as String? ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mythFactRow(context, '❌', myth, PerceptColors.warning),
            const SizedBox(height: PerceptSpacing.sm),
            _mythFactRow(context, '✅', fact, PerceptColors.success),
            if (block.text.isNotEmpty) ...[
              const SizedBox(height: PerceptSpacing.sm),
              Text(block.text, style: PerceptTypography.footnote(context.textSecondary)),
            ],
          ],
        );
      case 'question':
        return Text(
          block.text,
          style: PerceptTypography.bodyEmphasis(
            context.textPrimary,
            serif: true,
          ).copyWith(fontStyle: FontStyle.italic),
        );
      case 'paragraph':
      default:
        return Text(
          block.text,
          style: PerceptTypography.body(context.textPrimary, serif: true),
        );
    }
  }

  Widget _mythFactRow(BuildContext context, String glyph, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(glyph, style: const TextStyle(fontSize: PerceptGlyphSize.inline)),
        const SizedBox(width: PerceptSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: PerceptTypography.body(context.textPrimary).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
