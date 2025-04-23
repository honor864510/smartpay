import 'dart:async';

import 'package:control/control.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';
import 'package:pocketbase_sdk/pocketbase_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpay/src/common/constant/pubspec.yaml.g.dart';
import 'package:smartpay/src/common/controller/controller_observer.dart';
import 'package:smartpay/src/common/model/app_metadata.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/util/screen_util.dart';
import 'package:smartpay/src/feature/authentication/controller/authentication_controller.dart';
import 'package:smartpay/src/feature/authentication/data/authentication_repository.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_card_controller.dart';
import 'package:smartpay/src/feature/bank_card/controller/bank_list_controller.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_card_repository.dart';
import 'package:smartpay/src/feature/bank_card/repository/bank_repository.dart';
import 'package:smartpay/src/feature/bank_transaction/repository/bank_transaction_local_data_source.dart';
import 'package:smartpay/src/feature/bank_transaction/repository/bank_transaction_repository.dart';
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
  'Load dotenv': (_) async {
    await dotenv.load();
  },
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
  'Initialize local data source': (dependencies) {
    dependencies.bankTransactionLocalDataSource = BankTransactionLocalDataSource(
      preferences: dependencies.sharedPreferences,
    );
  },
  'Init API SDK\'s': (dependencies) async {
    final pb = await PocketbaseSdkInitializer.init(
      serverUrl: dotenv.env['POCKETBASE_URL']!,
      prefs: dependencies.sharedPreferences,
      lang: 'ru',
    );

    dependencies
      ..pocketBase = pb
      ..userSdk = UserSdk(pb: pb)
      ..p2pTransactionSdk = P2pTransactionSdk(pb: pb);
  },
  'Init repository':
      (dependencies) =>
          dependencies
            ..settingsRepository = SettingsRepository(preferences: dependencies.sharedPreferences)
            ..authenticationRepository = AuthenticationRepository(userSdk: dependencies.userSdk)
            ..bankRepository = MockBankRepository()
            ..bankCardRepository = BankCardRepository(prefs: dependencies.sharedPreferences)
            ..bankTransactionRepository = BankTransactionRepository(
              localDataSource: dependencies.bankTransactionLocalDataSource,
              p2pTransactionSdk: dependencies.p2pTransactionSdk,
            ),
  'Initialize settings': (dependencies) async {
    dependencies.settingsController = SettingsController(
      repository: dependencies.settingsRepository,
      initialState: (settings: await dependencies.settingsRepository.read(), idle: true),
    );

    dependencies.settingsController.addListener(
      () => dependencies.pocketBase.lang = dependencies.settingsController.state.settings.locale.languageCode,
    );
  },
  'Initialize controllers':
      (dependencies) =>
          dependencies
            ..bankCardController = BankCardController(repository: dependencies.bankCardRepository)
            ..bankListController = BankListController(repository: dependencies.bankRepository),
  'Connect to database': (_) {},
  'Shrink database': (_) {},
  'Migrate app from previous version': (_) {},
  'API Client': (_) {},
  'Prepare authentication controller': (dependencies) {
    dependencies.authenticationController = AuthenticationController(repository: dependencies.authenticationRepository);
  },
  'Restore last user': (dependencies) => dependencies.authenticationController.restore(),
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
