import 'dart:math';

final _rand = Random();

/// A short, sufficiently-unique id for locally-created records (completion
/// records, etc). Not a UUID — this app has no server to collide with, so
/// a timestamp + a few random base36 chars is plenty.
String generateLocalId(String prefix) {
  final time = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final salt = _rand.nextInt(46656).toRadixString(36).padLeft(3, '0');
  return '${prefix}_${time}_$salt';
}
