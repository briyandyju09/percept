import 'package:flutter/cupertino.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Shared chrome for every onboarding-assessment mini-test screen: a
/// dimension label, a step-progress bar (question N of total), the
/// question content itself, and a Continue button that's disabled until
/// [canContinue].
class AssessmentScaffold extends StatelessWidget {
  const AssessmentScaffold({
    super.key,
    required this.dimensionLabel,
    required this.stepIndex,
    required this.stepCount,
    required this.child,
    required this.onContinue,
    this.canContinue = true,
    this.continueLabel = 'Continue',
  });

  final String dimensionLabel;
  final int stepIndex;
  final int stepCount;
  final Widget child;
  final VoidCallback? onContinue;
  final bool canContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.md),
              Text(
                dimensionLabel.toUpperCase(),
                style: PerceptTypography.caption(context.perceptPrimary),
              ),
              const SizedBox(height: PerceptSpacing.sm),
              Row(
                children: List.generate(stepCount, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= stepIndex
                            ? context.perceptPrimary
                            : context.perceptHairline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: PerceptSpacing.xl),
              Expanded(child: SingleChildScrollView(child: child)),
              const SizedBox(height: PerceptSpacing.md),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: canContinue ? onContinue : null,
                  child: Text(continueLabel),
                ),
              ),
              const SizedBox(height: PerceptSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
