import 'package:flutter/cupertino.dart';
import 'colors.dart';
import 'typography.dart';

/// Builds the light and dark [CupertinoThemeData] for Percept.
class PerceptTheme {
  PerceptTheme._();

  static CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: PerceptColors.primaryLight,
    scaffoldBackgroundColor: PerceptColors.backgroundLight,
    barBackgroundColor: PerceptColors.surfaceLight.withValues(alpha: 0.94),
    textTheme: CupertinoTextThemeData(
      primaryColor: PerceptColors.primaryLight,
      textStyle: PerceptTypography.body(PerceptColors.textPrimaryLight),
      navTitleTextStyle: PerceptTypography.title3(
        PerceptColors.textPrimaryLight,
      ),
      navLargeTitleTextStyle: PerceptTypography.display(
        PerceptColors.textPrimaryLight,
      ),
      actionTextStyle: PerceptTypography.body(PerceptColors.primaryLight),
      tabLabelTextStyle: PerceptTypography.caption(
        PerceptColors.textSecondaryLight,
      ),
    ),
  );

  static CupertinoThemeData dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: PerceptColors.primaryDark,
    scaffoldBackgroundColor: PerceptColors.backgroundDark,
    barBackgroundColor: PerceptColors.surfaceDark.withValues(alpha: 0.94),
    textTheme: CupertinoTextThemeData(
      primaryColor: PerceptColors.primaryDark,
      textStyle: PerceptTypography.body(PerceptColors.textPrimaryDark),
      navTitleTextStyle: PerceptTypography.title3(
        PerceptColors.textPrimaryDark,
      ),
      navLargeTitleTextStyle: PerceptTypography.display(
        PerceptColors.textPrimaryDark,
      ),
      actionTextStyle: PerceptTypography.body(PerceptColors.primaryDark),
      tabLabelTextStyle: PerceptTypography.caption(
        PerceptColors.textSecondaryDark,
      ),
    ),
  );
}
