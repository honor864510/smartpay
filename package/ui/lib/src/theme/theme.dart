import 'package:flutter/material.dart';
import 'package:ui/src/theme/app_colors.dart';

/// {@template theme}
/// App theme data.
/// {@endtemplate}
extension type AppThemeData._(ThemeData data) implements ThemeData {
  /// {@macro theme}
  factory AppThemeData.light() => AppThemeData._(_appLightTheme);

  /// {@macro theme}
  factory AppThemeData.dark() => AppThemeData._(_appDarkTheme);
}

/// Light theme data for the App.
final ThemeData _appLightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: AppColors.blue,
    secondary: AppColors.lightBlue,
    tertiary: AppColors.green,
    error: AppColors.pink,
  ),
);

// --- Dark Theme --- //

/// Dark theme data for the App.
final ThemeData _appDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.blue,
    secondary: AppColors.lightBlue,
    tertiary: AppColors.green,
    error: AppColors.pink,
  ),
);
