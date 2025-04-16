import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartpay/src/common/localization/localization.dart';

/// A class responsible for managing application settings including theme and localization preferences
@immutable
final class SettingsEntity {
  /// Constructs a [SettingsEntity] instance
  ///
  /// [themeMode] - The theme mode to be used by the application
  /// [locale] - The locale/language setting for the application
  /// [enableBiometricalSecurity] - Whether biometrical security is enabled
  const SettingsEntity({required this.themeMode, required this.locale, required this.enableBiometricalSecurity});

  /// Deserializes a JSON map into a [SettingsEntity] instance
  ///
  /// [json] - A map containing settings data with:
  ///   - 'themeMode': Integer representing the theme mode index
  ///   - 'locale': String representing the language code
  ///   - 'enableBiometricalSecurity': Boolean indicating if biometric security is enabled
  ///
  /// Returns a new [SettingsEntity] instance with the deserialized values
  factory SettingsEntity.fromJson(Map<String, dynamic> json) => SettingsEntity(
    themeMode: ThemeMode.values[json['themeMode'] as int],
    locale: Locale(json['locale'] as String),
    enableBiometricalSecurity: json['enableBiometricalSecurity'] as bool? ?? false,
  );

  /// Creates a default instance of [SettingsEntity]
  ///
  /// Returns a new instance with system default theme mode and system locale
  factory SettingsEntity.defaultSettings() =>
      SettingsEntity(themeMode: ThemeMode.system, locale: _systemLocale, enableBiometricalSecurity: false);

  static Locale get _systemLocale {
    final platformLocale = Platform.localeName;

    final systemLocaleWithCountryCode = Locale.fromSubtags(
      languageCode: platformLocale.split('_')[0],
      countryCode: platformLocale.split('_')[1],
    );

    if (Localization.supportedLocales.contains(systemLocaleWithCountryCode)) {
      return systemLocaleWithCountryCode;
    }

    final systemLocale = Locale.fromSubtags(languageCode: platformLocale.split('_')[0]);

    if (Localization.supportedLocales.contains(systemLocale)) {
      return systemLocaleWithCountryCode;
    }

    return Localization.supportedLocales.first;
  }

  /// The currently active theme mode setting
  final ThemeMode themeMode;

  /// The currently active locale/language setting
  final Locale locale;

  /// Whether biometrical security is enabled for the app
  final bool enableBiometricalSecurity;

  /// Serializes the current settings into a JSON map
  ///
  /// Returns a map containing:
  ///   - 'themeMode': Integer representing the theme mode index
  ///   - 'locale': String representing the language code
  ///   - 'enableBiometricalSecurity': Boolean indicating if biometric security is enabled
  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'locale': locale.languageCode,
    'enableBiometricalSecurity': enableBiometricalSecurity,
  };

  /// Creates a new instance of [SettingsEntity] with optionally modified values
  ///
  /// [themeMode] - Optional new theme mode value
  /// [locale] - Optional new locale value
  /// [enableBiometricalSecurity] - Optional new biometrical security setting
  ///
  /// Returns a new instance with updated values, maintaining current values for null parameters
  SettingsEntity copyWith({ThemeMode? themeMode, Locale? locale, bool? enableBiometricalSecurity}) => SettingsEntity(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    enableBiometricalSecurity: enableBiometricalSecurity ?? this.enableBiometricalSecurity,
  );

  @override
  int get hashCode => Object.hashAll([themeMode, locale, enableBiometricalSecurity]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsEntity &&
          themeMode == other.themeMode &&
          locale == other.locale &&
          enableBiometricalSecurity == other.enableBiometricalSecurity;
}
