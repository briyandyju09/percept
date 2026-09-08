import 'package:hive_ce/hive.dart';

part 'saved_card.g.dart';

@HiveType(typeId: 4)
class SavedCard {
  SavedCard({required this.cardId, required this.savedAt});

  @HiveField(0)
  final String cardId;
  @HiveField(1)
  final DateTime savedAt;
}
