import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:ui/ui.dart';

/// {@template settings_screen}
/// SettingsScreen widget.
/// {@endtemplate}
class SettingsScreen extends StatelessWidget {
  /// {@macro settings_screen}
  const SettingsScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(title: Text('Settings')),
        SliverList.list(
          children: [
            ListTile(title: Text('Set biometry security')),
            ListTile(
              title: Text('Theme mode'),
              trailing: Switch(
                value: Dependencies.of(context).settingsController.state.settings.themeMode == ThemeMode.dark,
                onChanged:
                    (value) => Dependencies.of(
                      context,
                    ).settingsController.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
              ),
            ),
            ListTile(title: Text('Language')),
            ListTile(title: Text('About app')),
          ],
        ),
      ],
    ),
  );
}
