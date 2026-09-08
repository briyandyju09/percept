import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/app_settings.dart';
import '../hive/hive_setup.dart';

class SettingsRepository {
  Box get _box => Hive.box(HiveBoxes.settings);
  static const String _key = 'current';

  AppSettings load() {
    final existing = _box.get(_key) as AppSettings?;
    if (existing != null) return existing;
    final fresh = AppSettings();
    _box.put(_key, fresh);
    return fresh;
  }

  Future<void> save(AppSettings settings) => _box.put(_key, settings);
}
