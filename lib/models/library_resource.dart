/// One entry in Percept's Library tab: a real book, researcher/expert,
/// research area, or paper — honest reference material, never a
/// fabricated citation. One shape covers all four kinds so they can share
/// a single JSON file and a single browsing UI.
class LibraryResource {
  const LibraryResource({
    required this.id,
    required this.disciplineId,
    required this.type,
    required this.title,
    this.subtitle = '',
    required this.description,
    this.tags = const [],
  });

  final String id;

  /// One of the 7 discipline ids, or `"general"` for a cross-discipline
  /// resource that doesn't belong to a single skill tree.
  final String disciplineId;

  /// book | expert | researchArea | paper
  final String type;
  final String title;

  /// Author (for books), affiliation/one-line credential (for experts),
  /// or empty for research areas/papers.
  final String subtitle;
  final String description;
  final List<String> tags;

  factory LibraryResource.fromJson(Map<String, dynamic> json) =>
      LibraryResource(
        id: json['id'] as String,
        disciplineId: json['disciplineId'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        description: json['description'] as String,
        tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      );
}
