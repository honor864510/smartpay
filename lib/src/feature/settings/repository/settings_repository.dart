import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/feature/settings/entity/settings_entity.dart';

/// Repository interface for managing application settings
///
/// Defines the contract for reading and writing application settings
abstract interface class ISettingsRepository {
  /// Reads the current settings from storage
  ///
  /// Returns a [SettingsEntity] containing the current settings
  /// If no settings exist, returns default settings
  Future<SettingsEntity> read();

  /// Writes the provided settings to storage
  ///
  /// [settings] The settings to be saved
  Future<void> write(SettingsEntity settings);
}

/// Implementation of [ISettingsRepository] using SharedPreferences for storage
final class SettingsRepository implements ISettingsRepository {
  /// Creates a new [SettingsRepository] instance
  ///
  /// [preferences] SharedPreferences instance used for persistent storage
  SettingsRepository({required SharedPreferences preferences}) : _preferences = preferences;

  /// SharedPreferences instance for storing settings
  final SharedPreferences _preferences;

  /// Storage key for settings in SharedPreferences
  static const _key = 'settings__';

  @override
  Future<SettingsEntity> read() async {
    final encodedSettings = _preferences.getString(_key);

    if (encodedSettings == null) {
      return SettingsEntity.defaultSettings();
    }

    final settings = jsonDecode(encodedSettings) as Map<String, dynamic>;

    return SettingsEntity.fromJson(settings);
  }

  @override
  Future<void> write(SettingsEntity settings) async {
    final encodedSettings = jsonEncode(settings.toJson());

    await _preferences.setString(_key, encodedSettings);
  }
}
