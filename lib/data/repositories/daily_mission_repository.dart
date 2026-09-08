import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/daily_mission_item.dart';
import '../hive/hive_setup.dart';

class DailyMissionRepository {
  Box get _box => Hive.box(HiveBoxes.dailyMissions);

  List<DailyMissionItem> forDate(String yyyyMmDd) => _box.values
      .cast<DailyMissionItem>()
      .where((m) => m.date == yyyyMmDd)
      .toList();

  Future<void> save(DailyMissionItem item) => _box.put(item.id, item);

  Future<void> saveAll(List<DailyMissionItem> items) async {
    for (final item in items) {
      await _box.put(item.id, item);
    }
  }
}
