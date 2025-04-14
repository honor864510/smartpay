import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:smartpay/src/common/util/app_zone.dart';
import 'package:smartpay/src/common/util/error_util/error_util.dart';
import 'package:smartpay/src/common/widget/app.dart';
import 'package:smartpay/src/common/widget/app_error.dart' deferred as app_error;
import 'package:smartpay/src/feature/initialization/data/initialization.dart'
    deferred as initialization;
import 'package:smartpay/src/feature/initialization/widget/initialization_splash_screen.dart';

void main() => appZone(() async {
  // Splash screen
  final initializationProgress = ValueNotifier<({int progress, String message})>((
    progress: 0,
    message: '',
  ));
  /* runApp(SplashScreen(progress: initializationProgress)); */
  await initialization.loadLibrary();

  runApp(InitializationSplashScreen(progress: initializationProgress));

  initialization
      .$initializeApp(
        onProgress:
            (progress, message) =>
                initializationProgress.value = (progress: progress, message: message),
        onSuccess: (dependencies) async => runApp(dependencies.inject(child: const App())),
        onError: (error, stackTrace) async {
          await app_error.loadLibrary();
          runApp(app_error.AppError(error: error));
          ErrorUtil.logError(error, stackTrace).ignore();
        },
        splashScreenDuration: const Duration(seconds: 3),
      )
      .ignore();
});
