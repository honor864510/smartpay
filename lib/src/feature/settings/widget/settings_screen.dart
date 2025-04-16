import 'package:flutter/cupertino.dart';
import 'package:smartpay/src/common/localization/localization.dart';
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
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text(l10n.settings)),
          SliverList.list(
            children: [
              ...[
                _BiometricalSecurity(),
                _ThemeModeSelector(),
                _LocaleSelector(),
                _AboutApp(),
              ].expand((e) => [e, const Divider()]),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);

    return ListTile(title: Text(l10n.aboutApp), leading: const Icon(CupertinoIcons.info_circle));
  }
}

class _BiometricalSecurity extends StatelessWidget {
  void _onToggleSecurity(BuildContext context) {
    // TODO ADD Biometrical Security

    final settingsController = Dependencies.of(context).settingsController;
    final value = !settingsController.select((state) => state.settings.enableBiometricalSecurity).value;
    settingsController.setBiometricalSecurity(value: value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);
    final settingsController = Dependencies.of(context).settingsController;

    return ListenableBuilder(
      listenable: settingsController.select((state) => state.settings.enableBiometricalSecurity),
      builder: (context, _) {
        final isBiometricalSecurityEnabled =
            settingsController.select((state) => state.settings.enableBiometricalSecurity).value;

        return ListTile(
          title: Text(l10n.biometricalSecurity),
          leading: const Icon(Icons.fingerprint),
          onTap: () => _onToggleSecurity(context),
          trailing: Switch(value: isBiometricalSecurityEnabled, onChanged: (value) => _onToggleSecurity(context)),
        );
      },
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  void _onToggleThemeMode(BuildContext context) {
    final settingsController = Dependencies.of(context).settingsController;
    final newThemeMode = context.colorScheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    settingsController.setThemeMode(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);
    final settingsController = Dependencies.of(context).settingsController;

    return ListenableBuilder(
      listenable: settingsController.select((state) => state.settings.themeMode),
      builder: (context, child) {
        final themeMode = settingsController.select((state) => state.settings.themeMode);

        return ListTile(
          title: Text(l10n.themeMode),
          leading: const Icon(Icons.dark_mode_outlined),
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

class _LocaleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = Localization.of(context);
    final settingsController = Dependencies.of(context).settingsController;
    final currentLocale = settingsController.select((state) => state.settings.locale);
    final supportedLocales = Localization.supportedLocales;

    return ListTile(
      title: Text(l10n.language),
      leading: const Icon(Icons.language_outlined),
      trailing: ListenableBuilder(
        listenable: settingsController,
        builder:
            (context, _) => PopupBuilder(
              followerAnchor: Alignment.topRight,
              targetAnchor: Alignment.topRight,
              enforceLeaderWidth: true,
              followerBuilder:
                  (context, controller) => PopupFollower(
                    onDismiss: () => controller.hide(),
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 8,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: supportedLocales.length,
                        itemBuilder: (context, index) {
                          final locale = supportedLocales[index];
                          final isSelected = locale.languageCode == currentLocale.value.languageCode;
                          final language = Localization.getLanguageByCode(locale.languageCode);

                          final borderRadiusTop = Radius.circular(supportedLocales.first == locale ? 12 : 0);
                          final borderRadiusBottom = Radius.circular(supportedLocales.last == locale ? 12 : 0);
                          final borderRadius = BorderRadius.vertical(top: borderRadiusTop, bottom: borderRadiusBottom);

                          return ListTile(
                            title: Center(child: Text(language!.nativeName)),
                            titleTextStyle: context.textTheme.labelLarge,
                            selected: isSelected,
                            shape: RoundedRectangleBorder(borderRadius: borderRadius),
                            onTap: () {
                              settingsController.setLocale(locale);
                              controller.hide();
                            },
                          );
                        },
                      ),
                    ),
                  ),
              targetBuilder: (context, controller) {
                final language = Localization.getLanguageByCode(currentLocale.value.languageCode);

                return Card(
                  child: InkWell(
                    onTap: () => controller.show(),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language!.nativeName, style: context.textTheme.labelLarge),
                          const SizedBox(width: 12),
                          const Icon(CupertinoIcons.chevron_down, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
