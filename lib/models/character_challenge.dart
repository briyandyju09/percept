/// A single day's real-world behavioral challenge for the Character
/// discipline (idea.txt's "Daily character challenges" — never just
/// "read about empathy," always an action to take today).
class CharacterChallenge {
  const CharacterChallenge({
    required this.id,
    required this.text,
    required this.dimension,
    this.virtue = '',
  });

  final String id;
  final String text;
  final String dimension;
  final String virtue; // e.g. empathy, patience, humility, honesty...

  factory CharacterChallenge.fromJson(Map<String, dynamic> json) =>
      CharacterChallenge(
        id: json['id'] as String,
        text: json['text'] as String,
        dimension: json['dimension'] as String? ?? 'socialIntelligence',
        virtue: json['virtue'] as String? ?? '',
      );
}
