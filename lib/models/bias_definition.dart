/// A real-psychology concept paired explicitly with its pop-psychology
/// myth, shared between Human Psychology lesson content and the Case
/// Files debrief (so "you anchored on the first suspect" links back to the
/// same explanation used to teach anchoring bias in the library).
class BiasDefinition {
  const BiasDefinition({
    required this.id,
    required this.name,
    required this.myth,
    required this.fact,
    required this.explanation,
  });

  final String id;
  final String name;
  final String myth;
  final String fact;
  final String explanation;

  factory BiasDefinition.fromJson(Map<String, dynamic> json) =>
      BiasDefinition(
        id: json['id'] as String,
        name: json['name'] as String,
        myth: json['myth'] as String,
        fact: json['fact'] as String,
        explanation: json['explanation'] as String,
      );
}
