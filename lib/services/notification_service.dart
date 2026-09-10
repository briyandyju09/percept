import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Wraps `flutter_local_notifications` behind a small, app-specific API:
/// initialize once at startup, ask for permission when the user actually
/// enables the daily reminder, and (re)schedule/cancel a single repeating
/// daily notification. Every call is wrapped so a platform this package
/// doesn't fully support (this repo is developed/verified on Windows,
/// which `flutter_local_notifications` does not support at all) fails
/// quietly instead of crashing the app — notifications are a nice-to-have
/// feature, never something that should take the rest of the app down.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderId = 1001;
  static const String _channelId = 'daily_reminder';
  static const String _channelName = 'Daily Reminder';
  static const String _channelDescription =
      "Today's mission reminder, once a day.";

  bool _initialized = false;

  /// Platforms `flutter_local_notifications` actually supports scheduling
  /// on. Windows/Linux are excluded even though the plugin technically
  /// builds there, since local scheduled notifications on desktop aren't
  /// this feature's target and haven't been exercised.
  bool get _isSupportedPlatform {
    if (kIsWeb) return true;
    return Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
  }

  Future<void> initialize() async {
    if (_initialized || !_isSupportedPlatform) return;
    try {
      tz_data.initializeTimeZones();
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      );
      await _plugin.initialize(settings: settings);
      _initialized = true;
    } catch (_) {
      // Notifications are optional — never let setup failure surface to
      // the user or block the rest of the app from working.
    }
  }

  /// Requests the platform's notification permission. Returns whether
  /// permission was granted (best-effort — `null`/unsupported reads as
  /// `false`, not an error).
  Future<bool> requestPermission() async {
    if (!_isSupportedPlatform) return false;
    await initialize();
    try {
      if (kIsWeb) {
        final web = _plugin
            .resolvePlatformSpecificImplementation<
              WebFlutterLocalNotificationsPlugin
            >();
        return await web?.requestNotificationsPermission() ?? false;
      }
      if (Platform.isIOS) {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      }
      if (Platform.isMacOS) {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      }
      if (Platform.isAndroid) {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
        return granted ?? false;
      }
    } catch (_) {
      // Fall through to false below.
    }
    return false;
  }

  /// Schedules (or reschedules, replacing any existing one) a daily
  /// notification at [hour]:[minute] local time.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_isSupportedPlatform) return;
    await initialize();
    try {
      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: 'Percept',
        body: "Today's mission is ready — a few minutes of practice.",
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Best-effort — scheduling failure shouldn't crash Settings.
    }
  }

  Future<void> cancelDailyReminder() async {
    if (!_isSupportedPlatform) return;
    await initialize();
    try {
      await _plugin.cancel(id: _dailyReminderId);
    } catch (_) {
      // Best-effort.
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
