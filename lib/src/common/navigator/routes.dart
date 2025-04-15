import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartpay/src/feature/home/widget/home_screen.dart';

/// Just for example, as one of possible ways to
/// represent the pages/routes in the app.
enum Routes {
  home;

  const Routes();

  /// Converts the route to a [MaterialPage].
  Page<Object?> page({Map<String, Object?>? arguments, LocalKey? key}) => MaterialPage<void>(
    name: name,
    arguments: arguments,
    key: switch ((key, arguments)) {
      (final LocalKey key, _) => key,
      (_, final Map<String, Object?> arguments) => ValueKey('$name#${shortHash(arguments)}'),
      _ => ValueKey<String>(name),
    },
    child: switch (this) {
      Routes.home => const HomeScreen(),
    },
  );
}
