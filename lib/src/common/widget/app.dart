import 'package:control/control.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartpay/src/common/localization/localization.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/navigator/router_state_mixin.dart';
import 'package:smartpay/src/feature/authentication/widget/authentication_scope.dart';
import 'package:smartpay/src/feature/settings/controller/settings_controller.dart';
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

class _AppState extends State<App> with RouterStateMixin {
  final GlobalKey<State<StatefulWidget>> _preserveKey = GlobalKey<State<StatefulWidget>>();

  @override
  Widget build(BuildContext context) => StateConsumer<SettingsController, SettingsState>(
    buildWhen: (previous, current) => previous.settings != current.settings || previous.idle != current.idle,
    controller: Dependencies.of(context).settingsController,
    builder:
        (context, state, child) => MaterialApp(
          debugShowCheckedModeBanner: false,

          // Theme
          themeMode: state.settings.themeMode,
          theme: AppThemeData.dark(),
          darkTheme: AppThemeData.light(),

          // Localizations
          locale: state.settings.locale,
          localizationsDelegates: const <LocalizationsDelegate<Object?>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...TkDelegates.delegates,
            Localization.delegate,
          ],
          supportedLocales: Localization.supportedLocales,

          builder:
              (context, _) => MediaQuery(
                key: _preserveKey,
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: AuthenticationScope(child: buildNavigator()),
              ),
        ),
  );
}
