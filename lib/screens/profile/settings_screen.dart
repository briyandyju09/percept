import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../routing/route_paths.dart';
import '../../state/profile_providers.dart';
import '../../state/settings_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/section_header.dart';

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
            const SectionHeader('Appearance'),
            CupertinoSlidingSegmentedControl<String>(
              groupValue: settings.themeMode,
              children: const {
                'system': Padding(
                  padding: EdgeInsets.all(PerceptSpacing.xs),
                  child: Text('System'),
                ),
                'light': Padding(
                  padding: EdgeInsets.all(PerceptSpacing.xs),
                  child: Text('Light'),
                ),
                'dark': Padding(
                  padding: EdgeInsets.all(PerceptSpacing.xs),
                  child: Text('Dark'),
                ),
              },
              onValueChanged: (v) {
                if (v != null) notifier.setThemeMode(v);
              },
            ),
            const SectionHeader('Notifications'),
            _switchRow(
              context,
              'Daily reminder',
              settings.dailyReminderEnabled,
              (v) async {
                final enabled = await notifier.setDailyReminderEnabled(v);
                if (v && !enabled && context.mounted) {
                  _showPermissionDeniedNotice(context);
                }
              },
            ),
            if (settings.dailyReminderEnabled) ...[
              const SizedBox(height: PerceptSpacing.sm),
              GestureDetector(
                onTap: () => _pickTime(
                  context,
                  notifier,
                  settings.dailyReminderHour,
                  settings.dailyReminderMinute,
                ),
                child: _switchRow(
                  context,
                  'Reminder time',
                  null,
                  null,
                  trailing: Text(
                    DateFormat.jm().format(
                      DateTime(
                        0,
                        1,
                        1,
                        settings.dailyReminderHour,
                        settings.dailyReminderMinute,
                      ),
                    ),
                    style: PerceptTypography.body(context.perceptPrimary),
                  ),
                ),
              ),
            ],
            const SectionHeader('Feedback'),
            _switchRow(
              context,
              'Haptics',
              settings.hapticsEnabled,
              notifier.setHapticsEnabled,
            ),
            const SizedBox(height: PerceptSpacing.sectionGap),
            CupertinoButton(
              onPressed: () => _confirmReset(context, ref),
              child: Text(
                'Reset all progress',
                style: PerceptTypography.body(PerceptColors.warning),
              ),
            ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _switchRow(
    BuildContext context,
    String label,
    bool? value,
    ValueChanged<bool>? onChanged, {
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PerceptSpacing.md,
        vertical: PerceptSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.perceptSurfaceRaised,
        borderRadius: BorderRadius.circular(PerceptRadii.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: PerceptTypography.body(context.textPrimary)),
          ),
          if (trailing != null)
            trailing
          else if (value != null && onChanged != null)
            CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    SettingsNotifier notifier,
    int currentHour,
    int currentMinute,
  ) async {
    var selectedHour = currentHour;
    var selectedMinute = currentMinute;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 260,
        color: popupContext.perceptSurface,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(0, 1, 1, currentHour, currentMinute),
                onDateTimeChanged: (dt) {
                  selectedHour = dt.hour;
                  selectedMinute = dt.minute;
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: () => Navigator.of(popupContext).pop(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
    await notifier.setDailyReminderTime(
      hour: selectedHour,
      minute: selectedMinute,
    );
  }

  void _showPermissionDeniedNotice(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Notifications not enabled'),
        content: const Text(
          "Percept doesn't have permission to send notifications. You can "
          'enable this in your device Settings and try again.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          "This clears your profile, streak, and history. This can't be undone.",
        ),
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
