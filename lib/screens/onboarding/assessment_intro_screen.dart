import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/section_header.dart';

class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Assessment')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader('Five real tests, not a survey'),
              Text(
                'We won\'t ask you to rate your own confidence from 1-10. '
                'Instead you\'ll do five short, real tests — the same way '
                'this app will keep measuring your progress later.',
                style: PerceptTypography.body(context.textPrimary),
              ),
              const SizedBox(height: PerceptSpacing.xl),
              _TestRow(glyph: '🧩', title: 'Memory', desc: 'Recall a short list of items.'),
              _TestRow(glyph: '👁', title: 'Observation', desc: 'Study a scene, then recall it.'),
              _TestRow(glyph: '🗣', title: 'Social Intelligence', desc: 'Respond to a real scenario.'),
              _TestRow(glyph: '🧘', title: 'Composure', desc: 'React to a frustrating situation.'),
              _TestRow(glyph: '🧠', title: 'Reasoning', desc: 'Solve a short ambiguity puzzle.'),
              const Spacer(),
              Text(
                'Takes about 4 minutes.',
                style: PerceptTypography.footnote(context.textTertiary),
              ),
              const SizedBox(height: PerceptSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () =>
                      context.go(RoutePaths.onboardingAssessmentMemory),
                  child: const Text('Begin'),
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

class _TestRow extends StatelessWidget {
  const _TestRow({required this.glyph, required this.title, required this.desc});
  final String glyph;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.sm),
      child: Row(
        children: [
          Text(glyph, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: PerceptSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                Text(desc, style: PerceptTypography.footnote(context.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
