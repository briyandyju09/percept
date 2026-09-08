/// A single Deepstash-style swipeable idea card:
/// Hook -> Concept -> "Try It" behavioral prompt -> Why.
class KnowledgeCard {
  const KnowledgeCard({
    required this.id,
    required this.disciplineId,
    required this.hook,
    required this.concept,
    required this.tryIt,
    required this.whyExplanation,
    this.sourceCitation,
    this.tags = const [],
  });

  final String id;
  final String disciplineId;
  final String hook;
  final String concept;
  final String tryIt;
  final String whyExplanation;
  final String? sourceCitation;
  final List<String> tags;

  factory KnowledgeCard.fromJson(Map<String, dynamic> json) => KnowledgeCard(
    id: json['id'] as String,
    disciplineId: json['disciplineId'] as String,
    hook: json['hook'] as String,
    concept: json['concept'] as String,
    tryIt: json['tryIt'] as String,
    whyExplanation: json['whyExplanation'] as String,
    sourceCitation: json['sourceCitation'] as String?,
    tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
  );
}
