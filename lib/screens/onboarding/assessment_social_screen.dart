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

class AssessmentSocialScreen extends ConsumerStatefulWidget {
  const AssessmentSocialScreen({super.key});

  @override
  ConsumerState<AssessmentSocialScreen> createState() =>
      _AssessmentSocialScreenState();
}

class _AssessmentSocialScreenState
    extends ConsumerState<AssessmentSocialScreen> {
  int _index = 0;
  String _answer = '';

  @override
  Widget build(BuildContext context) {
    final questions = ref
        .read(contentRepositoryProvider)
        .assessmentQuestions
        .where((q) => q.dimension == 'socialIntelligence')
        .toList();
    final question = questions[_index];

    return AssessmentScaffold(
      dimensionLabel: 'Social Intelligence · ${_index + 1} of ${questions.length}',
      stepIndex: _index,
      stepCount: questions.length,
      canContinue: _answer.trim().isNotEmpty,
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
          context.go(RoutePaths.onboardingAssessmentEmotional);
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
            maxLines: 5,
            placeholder: 'Write what you\'d actually say or do…',
          ),
        ],
      ),
    );
  }
}
