import 'package:control/control.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/feature/home/widget/home_screen.dart';
import 'package:smartpay/src/feature/settings/controller/settings_controller.dart';
import 'package:smartpay/src/feature/settings/entity/settings_entity.dart';
import 'package:turkmen_localization_support/turkmen_localization_support.dart';
import 'package:ui/ui.dart';

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
  Widget build(BuildContext context) => StateConsumer<SettingsController, SettingsState>(
    buildWhen: (previous, current) => previous.settings != current.settings || previous.idle != current.idle,
    controller: Dependencies.of(context).settingsController,
    builder: (context, state, child) => _App(preserveKey: _preserveKey, settingsEntity: state.settings),
  );
}

class _App extends StatelessWidget {
  const _App({required GlobalKey<State<StatefulWidget>> preserveKey, required SettingsEntity settingsEntity})
    : _preserveKey = preserveKey,
      _settingsEntity = settingsEntity;

  final GlobalKey<State<StatefulWidget>> _preserveKey;
  final SettingsEntity _settingsEntity;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,

    // Theme
    themeMode: _settingsEntity.themeMode,
    theme: AppThemeData.dark(),
    darkTheme: AppThemeData.light(),

    // Localizations
    locale: _settingsEntity.locale,
    localizationsDelegates: const <LocalizationsDelegate<Object?>>[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      ...TkDelegates.delegates,
      Localization.delegate,
    ],
    supportedLocales: Localization.supportedLocales,

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
