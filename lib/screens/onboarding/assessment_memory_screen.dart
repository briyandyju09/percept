import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/onboarding_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/assessment_scaffold.dart';
import '../../widgets/timer_ring.dart';

class AssessmentMemoryScreen extends ConsumerStatefulWidget {
  const AssessmentMemoryScreen({super.key});

  @override
  ConsumerState<AssessmentMemoryScreen> createState() =>
      _AssessmentMemoryScreenState();
}

class _AssessmentMemoryScreenState
    extends ConsumerState<AssessmentMemoryScreen> {
  int _index = 0;
  bool _studying = true;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref
        .read(contentRepositoryProvider)
        .assessmentQuestions
        .where((q) => q.dimension == 'memory')
        .toList();
    final question = questions[_index];

    return AssessmentScaffold(
      dimensionLabel: 'Memory · ${_index + 1} of ${questions.length}',
      stepIndex: _index,
      stepCount: questions.length,
      canContinue: !_studying,
      continueLabel: _studying ? 'Studying…' : 'Continue',
      onContinue: () {
        ref
            .read(onboardingDraftProvider.notifier)
            .recordAnswer(question.id, _controller.text);
        _controller.clear();
        if (_index < questions.length - 1) {
          setState(() {
            _index++;
            _studying = true;
          });
        } else {
          context.go(RoutePaths.onboardingAssessmentObservation);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _studying
                ? 'Study this list. It will hide automatically.'
                : question.prompt,
            style: PerceptTypography.title3(context.textPrimary),
          ),
          const SizedBox(height: PerceptSpacing.xl),
          if (_studying) ...[
            Center(
              child: TimerRing(
                totalSeconds: (question.stimulusList.length * 1.4).ceil(),
                onComplete: () => setState(() => _studying = false),
              ),
            ),
            const SizedBox(height: PerceptSpacing.xl),
            Wrap(
              spacing: PerceptSpacing.sm,
              runSpacing: PerceptSpacing.sm,
              children: [
                for (final item in question.stimulusList)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PerceptSpacing.md,
                      vertical: PerceptSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: context.perceptSurfaceRaised,
                      borderRadius: BorderRadius.circular(PerceptRadii.chip),
                    ),
                    child: Text(item, style: PerceptTypography.body(context.textPrimary)),
                  ),
              ],
            ),
          ] else
            CupertinoTextField(
              controller: _controller,
              placeholder: 'List everything you remember…',
              maxLines: 5,
              padding: const EdgeInsets.all(PerceptSpacing.md),
              decoration: BoxDecoration(
                color: context.perceptSurface,
                borderRadius: BorderRadius.circular(PerceptRadii.card),
                border: Border.all(color: context.perceptHairline),
              ),
              onChanged: (_) => setState(() {}),
            ),
        ],
      ),
    );
  }
}
