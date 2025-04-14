import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/feature/home/home_screen.dart';
import 'package:turkmen_localization_support/turkmen_localization_support.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<State<StatefulWidget>> _preserveKey = GlobalKey<State<StatefulWidget>>();

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,

    // Theme
    /* theme: SettingsScope.themeOf(context), */
    theme: ThemeData.dark(),

    // Localizations
    localizationsDelegates: const <LocalizationsDelegate<Object?>>[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      ...TkDelegates.delegates,
      // Localization.delegate,
    ],
    // supportedLocales: Localization.supportedLocales,

    /* locale: SettingsScope.localOf(context), */
    builder:
        (context, _) => MediaQuery(
          key: _preserveKey,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: AppNavigator(
            pages: const [MaterialPage<void>(child: HomeScreen())],
            guards: [
              (pages) => pages.length > 1 ? pages : [const MaterialPage(child: HomeScreen())],
            ],
          ),
        ),
  );
}
