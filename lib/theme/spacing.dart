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

/// The 3-tier size scale every emoji/glyph icon in the app should use —
/// replaces 15+ one-off `fontSize` literals that had accumulated with no
/// shared scale. Pick the tier by the glyph's role, not by eyeballing a
/// number: inline next to text, a list-row leading icon, or a full-screen
/// hero moment.
class PerceptGlyphSize {
  PerceptGlyphSize._();

  /// Sitting inline next to a caption/label (e.g. a small "🔥 3" streak).
  static const double inline = 16;

  /// A list-row's leading icon (discipline tile, lab tile, case row).
  static const double row = 22;

  /// The one-off, larger-than-hero brand moment on the onboarding
  /// welcome screen only — deliberately its own tier rather than another
  /// ad hoc literal.
  static const double splash = 56;

  /// A full-screen hero moment (empty states, completion screens,
  /// onboarding welcome).
  static const double hero = 40;
}

/// Corner radii — no drop shadows anywhere in Percept; separation comes
/// from background contrast and 1px hairlines only.
class PerceptRadii {
  PerceptRadii._();

  static const double chip = 8;
  static const double card = 14;
  static const double sheet = 20;
}
