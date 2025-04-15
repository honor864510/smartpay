import 'package:control/control.dart';
import 'package:smartpay/src/feature/settings/entity/settings_entity.dart';
import 'package:smartpay/src/feature/settings/repository/settings_repository.dart';
import 'package:ui/ui.dart';

/// Settings state for [SettingsController]
typedef SettingsState = ({SettingsEntity settings, bool idle});

/// {@template settings_controller}
/// SettingsController.
/// {@endtemplate}
final class SettingsController extends StateController<SettingsState> with DroppableControllerHandler {
  /// {@macro settings_controller}
  SettingsController({required super.initialState, required SettingsRepository repository}) : _repository = repository;

  /// SettingsRepository
  final SettingsRepository _repository;

  void setThemeMode(ThemeMode themeMode) => handle(() async {
    final newSettings = state.settings.copyWith(themeMode: themeMode);
    setState((settings: newSettings, idle: false));
    await _repository.write(newSettings);
    setState((settings: state.settings, idle: true));
  });

  void setLocale(Locale locale) => handle(() async {
    final newSettings = state.settings.copyWith(locale: locale);
    setState((settings: newSettings, idle: false));
    await _repository.write(newSettings);
    setState((settings: state.settings, idle: true));
  });
}
