import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hive boxes aren't natively `Listenable` in a way Riverpod can `watch`
/// without extra plumbing. Instead, every repository-mutating action bumps
/// the relevant revision counter here (`ref.read(xRevisionProvider.notifier)
/// .state++`), and any provider that reads a list out of that box `watch`es
/// the counter so it recomputes right after a write — a small, explicit
/// alternative to wiring up Hive's `ValueListenable` box streams for every
/// box.
final completionsRevisionProvider = StateProvider<int>((ref) => 0);
final savedCardsRevisionProvider = StateProvider<int>((ref) => 0);
final caseProgressRevisionProvider = StateProvider<int>((ref) => 0);
final progressEntriesRevisionProvider = StateProvider<int>((ref) => 0);
final streakRevisionProvider = StateProvider<int>((ref) => 0);
