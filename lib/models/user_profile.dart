import 'package:hive_ce/hive.dart';
import 'dimension_scores.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 1)
class UserProfile {
  UserProfile({
    required this.id,
    required this.createdAt,
    this.goals = const [],
    this.dimensionScores = const DimensionScores(),
    this.onboardingCompleted = false,
    this.displayName,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final List<String> goals;
  @HiveField(3)
  final DimensionScores dimensionScores;
  @HiveField(4)
  final bool onboardingCompleted;
  @HiveField(5)
  final String? displayName;

  UserProfile copyWith({
    List<String>? goals,
    DimensionScores? dimensionScores,
    bool? onboardingCompleted,
    String? displayName,
  }) {
    return UserProfile(
      id: id,
      createdAt: createdAt,
      goals: goals ?? this.goals,
      dimensionScores: dimensionScores ?? this.dimensionScores,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      displayName: displayName ?? this.displayName,
    );
  }

  factory UserProfile.fresh() => UserProfile(
    id: 'local-user',
    createdAt: DateTime.now(),
    dimensionScores: const DimensionScores(
      observation: 50,
      memory: 50,
      socialIntelligence: 50,
      composure: 50,
      communication: 50,
      reasoning: 50,
      performance: 50,
    ),
  );
}
