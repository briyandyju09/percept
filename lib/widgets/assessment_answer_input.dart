import 'package:flutter/cupertino.dart';
import '../models/assessment_question.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Renders the right input control for an [AssessmentQuestion]: a choice
/// list when `options` is populated, otherwise a free-text field.
class AssessmentAnswerInput extends StatelessWidget {
  const AssessmentAnswerInput({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
    this.maxLines = 4,
    this.placeholder = 'Type your answer…',
  });

  final AssessmentQuestion question;
  final dynamic value;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    if (question.options.isNotEmpty) {
      return Column(
        children: [
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: value == option
                        ? context.perceptPrimary.withValues(alpha: 0.1)
                        : context.perceptSurface,
                    borderRadius: BorderRadius.circular(PerceptRadii.card),
                    border: Border.all(
                      color: value == option
                          ? context.perceptPrimary
                          : context.perceptHairline,
                    ),
                  ),
                  child: Text(
                    option,
                    style: PerceptTypography.body(context.textPrimary),
                  ),
                ),
              ),
            ),
        ],
      );
    }
    return CupertinoTextField(
      placeholder: placeholder,
      maxLines: maxLines,
      padding: const EdgeInsets.all(PerceptSpacing.md),
      decoration: BoxDecoration(
        color: context.perceptSurface,
        borderRadius: BorderRadius.circular(PerceptRadii.card),
        border: Border.all(color: context.perceptHairline),
      ),
      onChanged: onChanged,
    );
  }
}
