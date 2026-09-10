import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/daily_mission_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class SocialChallengeDetailScreen extends ConsumerWidget {
  const SocialChallengeDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dailyMissionProvider);
    final item = items.firstWhere((i) => i.type == 'socialChallenge');

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Social Challenge')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.xl),
              const Text('🗣', style: TextStyle(fontSize: PerceptGlyphSize.hero)),
              const SizedBox(height: PerceptSpacing.lg),
              Text(
                'Today\'s challenge',
                style: PerceptTypography.caption(context.perceptPrimary),
              ),
              const SizedBox(height: PerceptSpacing.xs),
              Text(
                item.subtitle,
                style: PerceptTypography.title2(context.textPrimary, ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
              Text(
                'Do this the next chance you get today, then come back and '
                'mark it done. There\'s no one checking — this only works if '
                'you actually do it.',
                style: PerceptTypography.subhead(context.textSecondary),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: item.completed
                      ? null
                      : () {
                          ref
                              .read(dailyMissionProvider.notifier)
                              .toggleComplete(item.id);
                          Navigator.of(context).maybePop();
                        },
                  child: Text(item.completed ? 'Done ✓' : 'Mark as done'),
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
