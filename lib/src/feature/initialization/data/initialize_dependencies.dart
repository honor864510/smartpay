import 'dart:async';

import 'package:control/control.dart';
import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/common/constant/pubspec.yaml.g.dart';
import 'package:smartpay/src/common/controller/controller_observer.dart';
import 'package:smartpay/src/common/model/app_metadata.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/util/screen_util.dart';
import 'package:smartpay/src/feature/initialization/data/platform/platform_initialization.dart';
import 'package:smartpay/src/feature/settings/controller/settings_controller.dart';
import 'package:smartpay/src/feature/settings/repository/settings_repository.dart';

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({void Function(int progress, String message)? onProgress}) async {
  final dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      l.v6('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      l.e('Initialization failed at step "${step.key}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Dependencies dependencies);
final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Creating app metadata':
      (dependencies) =>
          dependencies.metadata = AppMetadata(
            isWeb: platform.js,
            isRelease: platform.buildMode.release,
            appName: Pubspec.name,
            appVersion: Pubspec.version.representation,
            appVersionMajor: Pubspec.version.major,
            appVersionMinor: Pubspec.version.minor,
            appVersionPatch: Pubspec.version.patch,
            appBuildTimestamp:
                Pubspec.version.build.isNotEmpty ? (int.tryParse(Pubspec.version.build.firstOrNull ?? '-1') ?? -1) : -1,
            operatingSystem: platform.operatingSystem.name,
            processorsCount: platform.numberOfProcessors,
            appLaunchedTimestamp: DateTime.now(),
            locale: platform.locale,
            deviceVersion: platform.version,
            deviceScreenSize: ScreenUtil.screenSize().representation,
          ),
  'Observer state managment': (_) => Controller.observer = const ControllerObserver(),
  'Initializing analytics': (_) {},
  'Log app open': (_) {},
  'Get remote config': (_) {},
  'Initialize shared preferences':
      (dependencies) async => dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  'Init repository':
      (dependencies) =>
          dependencies.settingsRepository = SettingsRepository(preferences: dependencies.sharedPreferences),
  'Initialize settings':
      (dependencies) async =>
          dependencies.settingsController = SettingsController(
            repository: dependencies.settingsRepository,
            initialState: await dependencies.settingsRepository.read(),
          ),
  'Connect to database': (_) {},
  'Shrink database': (_) {},
  'Migrate app from previous version': (_) {},
  'API Client': (_) {},
  'Prepare authentication controller': (_) {},
  // 'Restore last user': (dependencies) => dependencies.authenticationController.restore(),
  'Initialize localization': (_) {},
  // 'Collect logs': (dependencies) async {
  //   await (dependencies.database.select<LogTbl, LogTblData>(dependencies.database.logTbl)
  //         ..orderBy([(tbl) => OrderingTerm(expression: tbl.time, mode: OrderingMode.desc)])
  //         ..limit(LogBuffer.bufferLimit))
  //       .get()
  //       .then<List<LogMessage>>(
  //         (logs) => logs
  //             .map<LogMessage>(
  //               (l) =>
  //                   l.stack != null
  //                       ? LogMessageError(
  //                         timestamp: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
  //                         level: LogLevel.fromValue(l.level),
  //                         message: l.message,
  //                         stackTrace: StackTrace.fromString(l.stack!),
  //                       )
  //                       : LogMessageVerbose(
  //                         timestamp: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
  //                         level: LogLevel.fromValue(l.level),
  //                         message: l.message,
  //                       ),
  //             )
  //             .toList(growable: false),
  //       )
  //       .then<void>(LogBuffer.instance.addAll);
  //   l
  //       .bufferTime(const Duration(seconds: 1))
  //       .where((logs) => logs.isNotEmpty)
  //       .listen(LogBuffer.instance.addAll, cancelOnError: false);
  //   l
  //       .map<LogTblCompanion>(
  //         (log) => LogTblCompanion.insert(
  //           level: log.level.level,
  //           message: log.message.toString(),
  //           time: Value<int>(log.timestamp.millisecondsSinceEpoch ~/ 1000),
  //           stack: Value<String?>(switch (log) {
  //             LogMessageError l => l.stackTrace.toString(),
  //             _ => null,
  //           }),
  //         ),
  //       )
  //       .bufferTime(const Duration(seconds: 5))
  //       .where((logs) => logs.isNotEmpty)
  //       .listen(
  //         (logs) =>
  //             dependencies.database
  //                 .batch((batch) => batch.insertAll(dependencies.database.logTbl, logs))
  //                 .ignore(),
  //         cancelOnError: false,
  //       );
  // },
  'Log app initialized': (_) {},
};
