/// `yyyy-MM-dd` formatting without pulling in `intl`'s heavier DateFormat
/// for this one very simple, very hot-path need.
String dateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String todayKey() => dateKey(DateTime.now());

bool isYesterday(String key, DateTime today) {
  final yesterday = today.subtract(const Duration(days: 1));
  return key == dateKey(yesterday);
}

bool isSameDay(String key, DateTime today) => key == dateKey(today);
