import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/util/extension/extension.dart';
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
            _ThemeModeSelector(),
            ListTile(title: Text('Language')),
            ListTile(title: Text('About app')),
          ],
        ),
      ],
    ),
  );
}

class _ThemeModeSelector extends StatelessWidget {
  void _onToggleThemeMode(BuildContext context) {
    final settingsController = Dependencies.of(context).settingsController;
    final newThemeMode = context.colorScheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    settingsController.setThemeMode(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Dependencies.of(context).settingsController;

    return ListenableBuilder(
      listenable: settingsController.select((state) => state.settings.themeMode),
      builder: (context, child) {
        final themeMode = settingsController.select((state) => state.settings.themeMode);

        return ListTile(
          title: const Text('Theme mode'),
          onTap: () => _onToggleThemeMode(context),
          trailing: Switch(
            value: themeMode.value == ThemeMode.light,
            onChanged: (value) => _onToggleThemeMode(context),
          ),
        );
      },
    );
  }
}
