import 'package:flutter/cupertino.dart';
import 'colors.dart';

/// Percept's type scale. SF Pro (the Cupertino system default) is used for
/// all app chrome; a serif face is reserved for long-form reading content
/// inside the Lesson Reader only, so "reading mode" always feels visually
/// distinct from app chrome. Rather than bundling a custom font file, this
/// uses "Georgia" (a system-installed serif on iOS/macOS) with generic
/// fallbacks so non-Apple platforms still render a serif, not a hard
/// failure back to the default sans face.
class PerceptTypography {
  PerceptTypography._();

  static const String serifFamily = 'Georgia';
  static const List<String> serifFallback = ['Times New Roman', 'serif'];

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    required Color color,
    String? family,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: family == serifFamily ? serifFallback : null,
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle display(Color color) =>
      _style(size: 34, height: 41, weight: FontWeight.w600, color: color);

  static TextStyle title1(Color color) =>
      _style(size: 28, height: 34, weight: FontWeight.w600, color: color);

  static TextStyle title2(Color color) =>
      _style(size: 22, height: 28, weight: FontWeight.w600, color: color);

  static TextStyle title3(Color color) =>
      _style(size: 20, height: 25, weight: FontWeight.w600, color: color);

  static TextStyle body(Color color, {bool serif = false}) => _style(
    size: 17,
    height: 24,
    weight: FontWeight.w400,
    color: color,
    family: serif ? serifFamily : null,
  );

  static TextStyle bodyEmphasis(Color color, {bool serif = false}) => _style(
    size: 17,
    height: 25,
    weight: FontWeight.w600,
    color: color,
    family: serif ? serifFamily : null,
  );

  static TextStyle callout(Color color) =>
      _style(size: 16, height: 21, weight: FontWeight.w400, color: color);

  static TextStyle subhead(Color color) =>
      _style(size: 15, height: 20, weight: FontWeight.w400, color: color);

  static TextStyle footnote(Color color) =>
      _style(size: 13, height: 18, weight: FontWeight.w400, color: color);

  static TextStyle caption(Color color) => _style(
    size: 12,
    height: 16,
    weight: FontWeight.w500,
    color: color,
    letterSpacing: 0.2,
  );
}

/// Convenience extension so screens can write
/// `PerceptTypography.title1(context.textPrimary)`-free code by resolving
/// brightness-aware colors directly off [BuildContext].
extension PerceptTextColors on BuildContext {
  bool get _isDark => CupertinoTheme.brightnessOf(this) == Brightness.dark;

  Color get textPrimary =>
      _isDark ? PerceptColors.textPrimaryDark : PerceptColors.textPrimaryLight;
  Color get textSecondary => _isDark
      ? PerceptColors.textSecondaryDark
      : PerceptColors.textSecondaryLight;
  Color get textTertiary => _isDark
      ? PerceptColors.textTertiaryDark
      : PerceptColors.textTertiaryLight;
  Color get perceptSurface =>
      _isDark ? PerceptColors.surfaceDark : PerceptColors.surfaceLight;
  Color get perceptSurfaceRaised => _isDark
      ? PerceptColors.surfaceRaisedDark
      : PerceptColors.surfaceRaisedLight;
  Color get perceptBackground =>
      _isDark ? PerceptColors.backgroundDark : PerceptColors.backgroundLight;
  Color get perceptHairline =>
      _isDark ? PerceptColors.hairlineDark : PerceptColors.hairlineLight;
  Color get perceptPrimary =>
      _isDark ? PerceptColors.primaryDark : PerceptColors.primaryLight;
}
