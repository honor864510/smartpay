import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartpay/src/feature/authentication/screen/sign_in/sign_in_screen.dart';
import 'package:smartpay/src/feature/bank_card/widget/add_bank_card_screen.dart';
import 'package:smartpay/src/feature/home/widget/home_screen.dart';

/// Just for example, as one of possible ways to
/// represent the pages/routes in the app.
enum Routes {
  signIn,
  dashboard,
  addBankCard;

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
      Routes.signIn => const SignInScreen(isPartner: false),
      Routes.dashboard => const HomeScreen(),
      Routes.addBankCard => const AddBankCardScreen(),
    },
  );
}
