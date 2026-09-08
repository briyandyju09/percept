import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            children: [
              const Spacer(flex: 3),
              Text('👁', style: const TextStyle(fontSize: 56)),
              const SizedBox(height: PerceptSpacing.xl),
              Text(
                'Percept',
                style: PerceptTypography.display(context.textPrimary),
              ),
              const SizedBox(height: PerceptSpacing.sm),
              Text(
                'Learn to notice more.\nUnderstand better. React less.',
                textAlign: TextAlign.center,
                style: PerceptTypography.title3(context.textSecondary),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PerceptSpacing.md,
                ),
                child: Text(
                  'A training system for observation, psychology, '
                  'communication, composure, and understanding people — '
                  'built to help you treat people better, not read minds.',
                  textAlign: TextAlign.center,
                  style: PerceptTypography.subhead(context.textSecondary),
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.go(RoutePaths.onboardingGoals),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
