import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/user_profile.dart';
import '../hive/hive_setup.dart';

/// Reads and writes the single on-device [UserProfile] record.
class ProfileRepository {
  Box get _box => Hive.box(HiveBoxes.profile);

  static const String _key = 'current';

  UserProfile load() {
    final existing = _box.get(_key) as UserProfile?;
    if (existing != null) return existing;
    final fresh = UserProfile.fresh();
    _box.put(_key, fresh);
    return fresh;
  }

  Future<void> save(UserProfile profile) => _box.put(_key, profile);

  Future<void> reset() => _box.clear();
}
