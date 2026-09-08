/// Base-4 spacing scale used everywhere instead of magic numbers.
class PerceptSpacing {
  PerceptSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;

  /// Standard horizontal screen margin.
  static const double screenMargin = 20;

  /// Standard card internal padding.
  static const double cardPadding = 16;

  /// Standard gap between stacked sections on a screen.
  static const double sectionGap = 28;
}

/// Corner radii — no drop shadows anywhere in Percept; separation comes
/// from background contrast and 1px hairlines only.
class PerceptRadii {
  PerceptRadii._();

  static const double chip = 8;
  static const double card = 14;
  static const double sheet = 20;
}
