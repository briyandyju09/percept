import 'package:flutter/cupertino.dart';

/// Percept's color system. Calm, editorial, low-saturation — "clarity and
/// composure," not a gamified neon palette. Every token has a light and a
/// dark value; screens should never reach for a raw [Color] literal.
class PerceptColors {
  PerceptColors._();

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF7F7F5);
  static const Color backgroundDark = Color(0xFF101214);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1B1E21);

  static const Color surfaceRaisedLight = Color(0xFFFCFCFB);
  static const Color surfaceRaisedDark = Color(0xFF212428);

  // Brand
  /// "Percept Slate" — the primary brand color. Used sparingly: active tab,
  /// primary buttons, key numerals.
  static const Color primaryLight = Color(0xFF33415C);
  static const Color primaryDark = Color(0xFF7A8CAE);

  /// "Signal Amber" — the single warm accent. Streak flame, highlighted
  /// numerals, the one "look here" color in the whole app.
  static const Color accent = Color(0xFFC98A3B);

  // Text
  static const Color textPrimaryLight = Color(0xFF14161A);
  static const Color textPrimaryDark = Color(0xFFECEDEE);

  static const Color textSecondaryLight = Color(0x9914161A); // 60% opacity
  static const Color textSecondaryDark = Color(0x99ECEDEE);

  static const Color textTertiaryLight = Color(0x6614161A); // 40% opacity
  static const Color textTertiaryDark = Color(0x66ECEDEE);

  // Structure
  static const Color hairlineLight = Color(0xFFE1E1DE);
  static const Color hairlineDark = Color(0xFF2A2D31);

  // Semantic / feedback
  static const Color success = Color(0xFF3E7C74);
  static const Color warning = Color(0xFFB5533C);
  static const Color info = Color(0xFF5B6B8C);

  // Ethical-tag palette — used consistently anywhere a Mentalism technique
  // is labeled, and nowhere else, so the tags stay recognizable.
  static const Color tagPerformance = Color(0xFF5B6B8C); // 🎭
  static const Color tagPsychology = Color(0xFF3E7C74); // 🧠
  static const Color tagRisk = Color(0xFFB5533C); // ⚠️
  static const Color tagEthical = Color(0xFF5C7A5C); // 🤝

  // The 7 dimension colors used consistently across radar chart, bars,
  // discipline icons, and lab tiles.
  static const Color dimObservation = Color(0xFF3E7C9A);
  static const Color dimMemory = Color(0xFF6B5B95);
  static const Color dimSocial = Color(0xFFB5653C);
  static const Color dimComposure = Color(0xFF5C7A5C);
  static const Color dimCommunication = Color(0xFFC98A3B);
  static const Color dimReasoning = Color(0xFF33415C);
  static const Color dimPerformance = Color(0xFF8C4A6B);
  static const Color dimKnowledge = Color(0xFF4A7A8C);
}
