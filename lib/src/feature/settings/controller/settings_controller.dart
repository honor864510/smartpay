import 'package:control/control.dart';
import 'package:smartpay/src/feature/settings/entity/settings_entity.dart';
import 'package:smartpay/src/feature/settings/repository/settings_repository.dart';
import 'package:ui/ui.dart';

/// {@template settings_controller}
/// SettingsController.
/// {@endtemplate}
final class SettingsController extends StateController<SettingsEntity> with DroppableControllerHandler {
  /// {@macro settings_controller}
  SettingsController({required super.initialState, required SettingsRepository repository}) : _repository = repository;

  /// SettingsRepository
  final SettingsRepository _repository;

  void setThemeMode(ThemeMode themeMode) => handle(() async {
    final newState = state.copyWith(themeMode: themeMode);
    await _repository.write(newState);
    setState(newState);
  });

  void setLocale(Locale locale) => handle(() async {
    final newState = state.copyWith(locale: locale);
    await _repository.write(newState);
    setState(newState);
  });
}
