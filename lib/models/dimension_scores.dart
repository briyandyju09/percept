import 'package:hive_ce/hive.dart';

part 'dimension_scores.g.dart';

/// The 7 measured dimensions of a Percept user's "Personal Profile", each
/// 0-100. This intentionally replaces XP/levels with named, meaningful
/// capacities. `knowledgeScore` is tracked separately as a derived stat
/// (function of lessons completed and recency), not a raw assessed
/// dimension — see [DimensionScores.knowledgeScore] default handling in
/// the profile provider.
///
/// Note on consolidation vs. idea.txt: "Emotional Regulation" is merged
/// into [composure], and "Empathy" is merged into [socialIntelligence] —
/// they are the same underlying construct measured two different ways in
/// the source brainstorm.
@HiveType(typeId: 0)
class DimensionScores {
  const DimensionScores({
    this.observation = 50,
    this.memory = 50,
    this.socialIntelligence = 50,
    this.composure = 50,
    this.communication = 50,
    this.reasoning = 50,
    this.performance = 50,
  });

  @HiveField(0)
  final int observation;
  @HiveField(1)
  final int memory;
  @HiveField(2)
  final int socialIntelligence;
  @HiveField(3)
  final int composure;
  @HiveField(4)
  final int communication;
  @HiveField(5)
  final int reasoning;
  @HiveField(6)
  final int performance;

  static const List<String> dimensionKeys = [
    'observation',
    'memory',
    'socialIntelligence',
    'composure',
    'communication',
    'reasoning',
    'performance',
  ];

  int operator [](String key) {
    switch (key) {
      case 'observation':
        return observation;
      case 'memory':
        return memory;
      case 'socialIntelligence':
        return socialIntelligence;
      case 'composure':
        return composure;
      case 'communication':
        return communication;
      case 'reasoning':
        return reasoning;
      case 'performance':
        return performance;
      default:
        throw ArgumentError('Unknown dimension key: $key');
    }
  }

  double get average =>
      (observation +
          memory +
          socialIntelligence +
          composure +
          communication +
          reasoning +
          performance) /
      7;

  /// The lowest-scoring dimension — drives the "biggest opportunity" line
  /// on the Profile screen.
  String get lowestDimensionKey {
    var lowestKey = dimensionKeys.first;
    var lowestValue = this[lowestKey];
    for (final key in dimensionKeys.skip(1)) {
      final value = this[key];
      if (value < lowestValue) {
        lowestValue = value;
        lowestKey = key;
      }
    }
    return lowestKey;
  }

  DimensionScores copyWith({
    int? observation,
    int? memory,
    int? socialIntelligence,
    int? composure,
    int? communication,
    int? reasoning,
    int? performance,
  }) {
    return DimensionScores(
      observation: (observation ?? this.observation).clamp(0, 100),
      memory: (memory ?? this.memory).clamp(0, 100),
      socialIntelligence: (socialIntelligence ?? this.socialIntelligence)
          .clamp(0, 100),
      composure: (composure ?? this.composure).clamp(0, 100),
      communication: (communication ?? this.communication).clamp(0, 100),
      reasoning: (reasoning ?? this.reasoning).clamp(0, 100),
      performance: (performance ?? this.performance).clamp(0, 100),
    );
  }

  /// Nudges [key] by [delta] (positive or negative), clamped to 0-100.
  DimensionScores adjust(String key, int delta) {
    final current = this[key];
    final updated = (current + delta).clamp(0, 100);
    switch (key) {
      case 'observation':
        return copyWith(observation: updated);
      case 'memory':
        return copyWith(memory: updated);
      case 'socialIntelligence':
        return copyWith(socialIntelligence: updated);
      case 'composure':
        return copyWith(composure: updated);
      case 'communication':
        return copyWith(communication: updated);
      case 'reasoning':
        return copyWith(reasoning: updated);
      case 'performance':
        return copyWith(performance: updated);
      default:
        return this;
    }
  }

  factory DimensionScores.fromJson(Map<String, dynamic> json) =>
      DimensionScores(
        observation: json['observation'] as int? ?? 50,
        memory: json['memory'] as int? ?? 50,
        socialIntelligence: json['socialIntelligence'] as int? ?? 50,
        composure: json['composure'] as int? ?? 50,
        communication: json['communication'] as int? ?? 50,
        reasoning: json['reasoning'] as int? ?? 50,
        performance: json['performance'] as int? ?? 50,
      );

  Map<String, dynamic> toJson() => {
    'observation': observation,
    'memory': memory,
    'socialIntelligence': socialIntelligence,
    'composure': composure,
    'communication': communication,
    'reasoning': reasoning,
    'performance': performance,
  };
}

/// Human-readable label + icon glyph for each dimension key, for shared use
/// across the radar chart, bar rows, and discipline tiles.
class DimensionMeta {
  const DimensionMeta._();

  static const Map<String, String> labels = {
    'observation': 'Observation',
    'memory': 'Memory',
    'socialIntelligence': 'Social Intelligence',
    'composure': 'Composure',
    'communication': 'Communication',
    'reasoning': 'Reasoning',
    'performance': 'Performance',
    'knowledge': 'Knowledge',
  };

  static const Map<String, String> glyphs = {
    'observation': '👁',
    'memory': '🧩',
    'socialIntelligence': '❤️',
    'composure': '🧘',
    'communication': '🗣',
    'reasoning': '🧠',
    'performance': '🎭',
    'knowledge': '📚',
  };
}
