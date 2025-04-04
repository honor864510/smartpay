import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

export 'package:ui/src/theme/extensions/colors.dart';

/// {@template theme}
/// App theme data.
/// {@endtemplate}
extension type AppThemeData._(ThemeData data) implements ThemeData {
  /// {@macro theme}
  factory AppThemeData.light() => AppThemeData._(_buildTheme(_appLightTheme));

  /// {@macro theme}
  factory AppThemeData.dark() => AppThemeData._(_buildTheme(_appDarkTheme));

  static ThemeData _buildTheme(ThemeData theme) {
    const borderSide = BorderSide(
      color: Color.fromRGBO(0, 0, 0, 0.6), // Color.fromRGBO(43, 45, 39, 0.24)
    );

    return theme.copyWith(
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UiConstant.borderRadius)),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UiConstant.borderRadius)),
        elevation: 4,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UiConstant.borderRadius)),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        isCollapsed: false,
        isDense: false,
        filled: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide.copyWith(color: theme.colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide.copyWith(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide.copyWith(color: theme.colorScheme.error),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide.copyWith(color: const Color.fromRGBO(0, 0, 0, 0.24)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiConstant.borderRadius),
          borderSide: borderSide.copyWith(color: const Color.fromRGBO(0, 0, 0, 0.24)),
        ),
        outlineBorder: borderSide,
      ),
    );
  }
}

/// Extension on [ThemeData] to provide App theme data.
extension AudoThemeExtension on ThemeData {
  /// Returns the App theme colors.
  AppColors get appColors =>
      extension<AppColors>() ??
      switch (brightness) {
        Brightness.light => AppColors.light,
        Brightness.dark => AppColors.dark,
      };
}

// --- Light Theme --- //

/// Light theme data for the App.
final ThemeData _appLightTheme = ThemeData.light().copyWith(
  colorScheme: AppColors.light.scheme,
  extensions: const <ThemeExtension>[AppColors.light],
);

// --- Dark Theme --- //

/// Dark theme data for the App.
final ThemeData _appDarkTheme = ThemeData.dark().copyWith(
  colorScheme: AppColors.dark.scheme,
  extensions: const <ThemeExtension>[AppColors.dark],
);
