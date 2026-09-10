import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/hive/hive_setup.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'services/notification_service.dart';
import 'state/repository_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpHive();

  final content = ContentRepository();
  await content.load();

  // Notification setup is best-effort and never blocks app startup — see
  // NotificationService's own try/catch guards for why.
  await NotificationService.instance.initialize();
  final settings = SettingsRepository().load();
  if (settings.dailyReminderEnabled) {
    await NotificationService.instance.scheduleDailyReminder(
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    );
  }

  runApp(
    ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(content)],
      child: const PerceptApp(),
    ),
  );
}
