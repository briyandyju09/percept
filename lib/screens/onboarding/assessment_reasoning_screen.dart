import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/onboarding_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/assessment_answer_input.dart';
import '../../widgets/assessment_scaffold.dart';

class AssessmentReasoningScreen extends ConsumerStatefulWidget {
  const AssessmentReasoningScreen({super.key});

  @override
  ConsumerState<AssessmentReasoningScreen> createState() =>
      _AssessmentReasoningScreenState();
}

class _AssessmentReasoningScreenState
    extends ConsumerState<AssessmentReasoningScreen> {
  int _index = 0;
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    final questions = ref
        .read(contentRepositoryProvider)
        .assessmentQuestions
        .where((q) => q.dimension == 'reasoning')
        .toList();
    final question = questions[_index];

    return AssessmentScaffold(
      dimensionLabel: 'Reasoning · ${_index + 1} of ${questions.length}',
      stepIndex: _index,
      stepCount: questions.length,
      canContinue: _answer.trim().isNotEmpty,
      continueLabel: _index < questions.length - 1 ? 'Continue' : 'See my results',
      onContinue: () {
        ref
            .read(onboardingDraftProvider.notifier)
            .recordAnswer(question.id, _answer);
        if (_index < questions.length - 1) {
          setState(() {
            _index++;
            _answer = '';
          });
        } else {
          context.go(RoutePaths.onboardingResults);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.stimulus != null) ...[
            Text(
              question.stimulus!,
              style: PerceptTypography.body(context.textPrimary, serif: true),
            ),
            const SizedBox(height: PerceptSpacing.lg),
          ],
          Text(question.prompt, style: PerceptTypography.title3(context.textPrimary)),
          const SizedBox(height: PerceptSpacing.lg),
          AssessmentAnswerInput(
            question: question,
            value: _answer,
            onChanged: (v) => setState(() => _answer = v),
          ),
        ],
      ),
    );
  }
}
