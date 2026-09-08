import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/profile_providers.dart';
import '../../state/settings_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          children: [
            Text('APPEARANCE', style: PerceptTypography.caption(context.textTertiary)),
            const SizedBox(height: PerceptSpacing.sm),
            CupertinoSlidingSegmentedControl<String>(
              groupValue: settings.themeMode,
              children: const {
                'system': Padding(padding: EdgeInsets.all(6), child: Text('System')),
                'light': Padding(padding: EdgeInsets.all(6), child: Text('Light')),
                'dark': Padding(padding: EdgeInsets.all(6), child: Text('Dark')),
              },
              onValueChanged: (v) {
                if (v != null) notifier.setThemeMode(v);
              },
            ),
            const SizedBox(height: PerceptSpacing.xl),
            Text('NOTIFICATIONS', style: PerceptTypography.caption(context.textTertiary)),
            const SizedBox(height: PerceptSpacing.sm),
            _switchRow(
              context,
              'Daily reminder',
              settings.dailyReminderEnabled,
              (v) => notifier.setDailyReminder(enabled: v),
            ),
            const SizedBox(height: PerceptSpacing.xl),
            Text('FEEDBACK', style: PerceptTypography.caption(context.textTertiary)),
            const SizedBox(height: PerceptSpacing.sm),
            _switchRow(
              context,
              'Haptics',
              settings.hapticsEnabled,
              notifier.setHapticsEnabled,
            ),
            const SizedBox(height: PerceptSpacing.xl),
            CupertinoButton(
              onPressed: () => _confirmReset(context, ref),
              child: Text(
                'Reset all progress',
                style: PerceptTypography.body(PerceptColors.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchRow(BuildContext context, String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: context.perceptSurface,
        borderRadius: BorderRadius.circular(PerceptRadii.card),
        border: Border.all(color: context.perceptHairline),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: PerceptTypography.body(context.textPrimary))),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text('This clears your profile, streak, and history. This can\'t be undone.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(profileProvider.notifier).resetAll();
              if (context.mounted) context.go(RoutePaths.onboardingWelcome);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
