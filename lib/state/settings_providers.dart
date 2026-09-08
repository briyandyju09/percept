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

  Future<void> setDailyReminder({
    required bool enabled,
    int? hour,
    int? minute,
  }) async {
    state = state.copyWith(
      dailyReminderEnabled: enabled,
      dailyReminderHour: hour,
      dailyReminderMinute: minute,
    );
    await _persist();
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    await _persist();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
