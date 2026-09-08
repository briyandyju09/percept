class OnboardingGoal {
  const OnboardingGoal({
    required this.id,
    required this.label,
    required this.icon,
    this.mappedDimensions = const {},
  });

  final String id;
  final String label;
  final String icon;

  /// dimensionKey -> weight, used to bias the initial program.
  final Map<String, int> mappedDimensions;

  factory OnboardingGoal.fromJson(Map<String, dynamic> json) =>
      OnboardingGoal(
        id: json['id'] as String,
        label: json['label'] as String,
        icon: json['icon'] as String,
        mappedDimensions: Map<String, int>.from(
          json['mappedDimensions'] as Map? ?? {},
        ),
      );
}
