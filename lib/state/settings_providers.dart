import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import 'repository_providers.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsRepositoryProvider).load();

  Future<void> _persist() => ref.read(settingsRepositoryProvider).save(state);

  Future<void> setThemeMode(String mode) async {
    state = state.copyWith(themeMode: mode);
    await _persist();
  }

  /// Toggles the daily reminder. When enabling, requests notification
  /// permission first — if it's denied, the setting stays off rather than
  /// silently scheduling something that will never actually fire. Returns
  /// whether the reminder ended up enabled, so the Settings screen can
  /// show a message if permission was refused.
  Future<bool> setDailyReminderEnabled(bool enabled) async {
    final service = ref.read(notificationServiceProvider);

    if (enabled) {
      final granted = await service.requestPermission();
      if (!granted) return false;
      state = state.copyWith(dailyReminderEnabled: true);
      await _persist();
      await service.scheduleDailyReminder(
        hour: state.dailyReminderHour,
        minute: state.dailyReminderMinute,
      );
      return true;
    }

    state = state.copyWith(dailyReminderEnabled: false);
    await _persist();
    await service.cancelDailyReminder();
    return false;
  }

  /// Updates the reminder time and reschedules immediately if the
  /// reminder is currently enabled.
  Future<void> setDailyReminderTime({
    required int hour,
    required int minute,
  }) async {
    state = state.copyWith(dailyReminderHour: hour, dailyReminderMinute: minute);
    await _persist();
    if (state.dailyReminderEnabled) {
      await ref
          .read(notificationServiceProvider)
          .scheduleDailyReminder(hour: hour, minute: minute);
    }
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    await _persist();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
