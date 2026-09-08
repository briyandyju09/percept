import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../models/saved_card.dart';
import '../hive/hive_setup.dart';

class SavedCardsRepository {
  Box get _box => Hive.box(HiveBoxes.savedCards);

  bool isSaved(String cardId) => _box.containsKey(cardId);

  Future<void> toggle(String cardId) async {
    if (_box.containsKey(cardId)) {
      await _box.delete(cardId);
    } else {
      await _box.put(cardId, SavedCard(cardId: cardId, savedAt: DateTime.now()));
    }
  }

  List<SavedCard> all() {
    final list = _box.values.cast<SavedCard>().toList();
    list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return list;
  }
}
