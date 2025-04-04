import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/feature/settings/data/app_settings_repository.dart';
import 'package:sizzle_starter/src/feature/settings/model/app_settings.dart';

/// {@template app_settings_bloc}
/// A [Bloc] that handles [AppSettings].
/// {@endtemplate}
final class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  /// {@macro app_settings_bloc}
  AppSettingsBloc({
    required AppSettingsRepository appSettingsRepository,
    required AppSettingsState initialState,
  }) : _appSettingsRepository = appSettingsRepository,
       super(initialState) {
    on<AppSettingsEvent>(
      (event, emit) => switch (event) {
        final _AppSettingsEvent$Update e => _updateAppSettings(e, emit),
      },
    );
  }

  final AppSettingsRepository _appSettingsRepository;

  Future<void> _updateAppSettings(
    _AppSettingsEvent$Update event,
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      emit(_AppSettingsState$Loading(appSettings: state.appSettings));
      await _appSettingsRepository.setAppSettings(event.appSettings);
      emit(_AppSettingsState$Idle(appSettings: event.appSettings));
    } catch (error) {
      emit(_AppSettingsState$Error(appSettings: event.appSettings, error: error));
    }
  }
}

/// States for the [AppSettingsBloc].
sealed class AppSettingsState {
  const AppSettingsState({this.appSettings});

  /// Application locale.
  final AppSettings? appSettings;

  /// The app settings are idle.
  const factory AppSettingsState.idle({AppSettings? appSettings}) = _AppSettingsState$Idle;

  /// The app settings are loading.
  const factory AppSettingsState.loading({AppSettings? appSettings}) = _AppSettingsState$Loading;

  /// The app settings have an error.
  const factory AppSettingsState.error({required Object error, AppSettings? appSettings}) =
      _AppSettingsState$Error;
}

final class _AppSettingsState$Idle extends AppSettingsState {
  const _AppSettingsState$Idle({super.appSettings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _AppSettingsState$Idle && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.idle(appSettings: $appSettings)';
}

final class _AppSettingsState$Loading extends AppSettingsState {
  const _AppSettingsState$Loading({super.appSettings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _AppSettingsState$Loading && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.loading(appSettings: $appSettings)';
}

final class _AppSettingsState$Error extends AppSettingsState {
  const _AppSettingsState$Error({required this.error, super.appSettings});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _AppSettingsState$Error &&
        other.appSettings == appSettings &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(appSettings, error);

  @override
  String toString() => 'SettingsState.error(appSettings: $appSettings, error: $error)';
}

/// Events for the [AppSettingsBloc].
sealed class AppSettingsEvent {
  const AppSettingsEvent();

  /// Update the app settings.
  const factory AppSettingsEvent.updateAppSettings({required AppSettings appSettings}) =
      _AppSettingsEvent$Update;
}

final class _AppSettingsEvent$Update extends AppSettingsEvent {
  const _AppSettingsEvent$Update({required this.appSettings});

  /// The theme to update.
  final AppSettings appSettings;

  @override
  String toString() => 'SettingsEvent.updateAppSettings(appSettings: $appSettings)';
}
