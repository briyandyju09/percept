import 'package:flutter/cupertino.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/section_header.dart';

class AboutEthicsScreen extends StatelessWidget {
  const AboutEthicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Our Philosophy')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          children: [
            Text(
              'Learn to notice more.\nUnderstand better. React less.',
              style: PerceptTypography.title2(context.textPrimary),
            ),
            const SizedBox(height: PerceptSpacing.lg),
            Text(
              'Percept does not teach you how to manipulate people. It teaches '
              'you to understand people so you can treat them better.',
              style: PerceptTypography.body(context.textPrimary),
            ),
            const SectionHeader('The progression'),
            for (final step in const [
              'Notice.',
              'Understand.',
              'Think.',
              'Communicate.',
              'Control yourself.',
              'Help others.',
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
                child: Text(step, style: PerceptTypography.title3(context.perceptPrimary)),
              ),
            const SectionHeader('On mentalism & reading people'),
            Text(
              'Every technique in the Mentalism & Performance discipline is '
              'tagged honestly: 🎭 Performance, 🧠 Psychological principle, '
              '⚠️ Manipulation risk, 🤝 Ethical use. Nothing here claims real '
              'psychic ability, and nothing here is a substitute for asking '
              'someone directly what they think or feel.',
              style: PerceptTypography.body(context.textPrimary),
            ),
            const SizedBox(height: PerceptSpacing.md),
            Text(
              'When we teach you to read a room, we also teach you that a '
              'single cue is never proof. Look for clusters of signals, '
              'always consider an alternative explanation, and hold your '
              'conclusions as loosely as the evidence deserves.',
              style: PerceptTypography.body(context.textPrimary),
            ),
            const SectionHeader('On composure'),
            Text(
              'The goal is high awareness with low reactivity — not '
              'becoming a paranoid person who over-analyzes everyone around '
              'them. Notice more, react less.',
              style: PerceptTypography.body(context.textPrimary),
            ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
