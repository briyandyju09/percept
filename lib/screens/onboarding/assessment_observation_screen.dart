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
import '../../widgets/timer_ring.dart';

class AssessmentObservationScreen extends ConsumerStatefulWidget {
  const AssessmentObservationScreen({super.key});

  @override
  ConsumerState<AssessmentObservationScreen> createState() =>
      _AssessmentObservationScreenState();
}

class _AssessmentObservationScreenState
    extends ConsumerState<AssessmentObservationScreen> {
  int _index = 0;
  bool _studying = true;
  String? _answer;

  @override
  Widget build(BuildContext context) {
    final questions = ref
        .read(contentRepositoryProvider)
        .assessmentQuestions
        .where((q) => q.dimension == 'observation')
        .toList();
    final question = questions[_index];

    return AssessmentScaffold(
      dimensionLabel: 'Observation · ${_index + 1} of ${questions.length}',
      stepIndex: _index,
      stepCount: questions.length,
      canContinue: _studying || (_answer?.isNotEmpty ?? false),
      continueLabel: _studying ? 'Studying…' : 'Continue',
      onContinue: () {
        if (!_studying) {
          ref
              .read(onboardingDraftProvider.notifier)
              .recordAnswer(question.id, _answer);
        }
        if (_index < questions.length - 1) {
          setState(() {
            _index++;
            _studying = true;
            _answer = null;
          });
        } else {
          context.go(RoutePaths.onboardingAssessmentSocial);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _studying ? 'Study this scene.' : question.prompt,
            style: PerceptTypography.title3(context.textPrimary),
          ),
          const SizedBox(height: PerceptSpacing.xl),
          if (_studying) ...[
            Text(
              question.stimulus ?? '',
              style: PerceptTypography.body(context.textPrimary, serif: true),
            ),
            const SizedBox(height: PerceptSpacing.xl),
            Center(
              child: TimerRing(
                totalSeconds: 12,
                onComplete: () => setState(() => _studying = false),
              ),
            ),
          ] else
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
