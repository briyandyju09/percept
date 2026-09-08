/// Static metadata for the 7 disciplines (skill trees). Not content-loaded
/// from JSON since this list is fixed and small; lives here as a single
/// source of truth referenced by discipline id everywhere else.
class Discipline {
  const Discipline({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.primaryDimension,
    required this.labName,
  });

  final String id;
  final String name;
  final String tagline;
  final String icon;

  /// The [DimensionScores] key most improved by training this discipline.
  final String primaryDimension;

  /// The exact `Drill.labCategory` string this discipline's Practice Lab
  /// uses (doesn't always match [name] 1:1 — e.g. "Human Psychology" ->
  /// "Psychology Lab").
  final String labName;

  static const List<Discipline> all = [
    Discipline(
      id: 'observation',
      name: 'Observation',
      tagline: 'The foundation — notice what others miss.',
      icon: '👁',
      primaryDimension: 'observation',
      labName: 'Observation Lab',
    ),
    Discipline(
      id: 'psychology',
      name: 'Human Psychology',
      tagline: 'Real mechanisms of mind, not pop-psychology myths.',
      icon: '🧠',
      primaryDimension: 'reasoning',
      labName: 'Psychology Lab',
    ),
    Discipline(
      id: 'reading_people',
      name: 'Reading People',
      tagline: 'Observation → hypothesis → alternative → confidence.',
      icon: '🎭',
      primaryDimension: 'socialIntelligence',
      labName: 'Reading People Lab',
    ),
    Discipline(
      id: 'conversation',
      name: 'Conversation & Social Intelligence',
      tagline: 'Listen better. Ask better. Connect for real.',
      icon: '🗣',
      primaryDimension: 'communication',
      labName: 'Conversation Lab',
    ),
    Discipline(
      id: 'mentalism',
      name: 'Mentalism & Performance',
      tagline: 'The craft of attention, presented ethically.',
      icon: '🃏',
      primaryDimension: 'performance',
      labName: 'Performance Lab',
    ),
    Discipline(
      id: 'composure',
      name: 'Composure',
      tagline: 'High awareness, low reactivity.',
      icon: '🧘',
      primaryDimension: 'composure',
      labName: 'Composure Lab',
    ),
    Discipline(
      id: 'character',
      name: 'Character',
      tagline: 'Becoming someone worth being.',
      icon: '🧭',
      primaryDimension: 'socialIntelligence',
      labName: 'Character Lab',
    ),
  ];

  static Discipline byId(String id) =>
      all.firstWhere((d) => d.id == id, orElse: () => all.first);

  static Discipline byLabName(String labName) => all.firstWhere(
    (d) => d.labName == labName,
    orElse: () => all.first,
  );
}
