import 'package:flutter/material.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/models/settings_state.dart';

final List<Locale> supportedLanguages = S.delegate.supportedLocales;

class Settings extends StatelessWidget {
  final void Function() toggleTheme;
  final void Function(String locale) switchLocale;
  final SettingsState currentSettings;

  Settings({
    @required this.toggleTheme,
    @required this.switchLocale,
    @required this.currentSettings,
  }) : super(key: Keys.settingsScreen);

  @override
  Widget build(BuildContext context) {
    final bool darkMode = currentSettings.darkMode;
    print(currentSettings);
    return new Wrapper(
        title: 'Settings',
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                SwitchListTile(
                  title: Text('Enable Dark Mode'),
                  value: darkMode,
                  onChanged: (bool value) {
                    toggleTheme();
                  },
                  secondary: Icon(Icons.brightness_3),
                ),
                ListTile(
                  title: Text('Language'),
                  leading: Icon(Icons.flag),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String locale) {
                      switchLocale(locale);
                    },
                    itemBuilder: (BuildContext context) => supportedLanguages.map((Locale item) => PopupMenuItem(
                        value: item.languageCode,
                        child: new Text(item.languageCode),
                      )).toList(),
                  ),
                ),
              ],
            ).toList(),
          ),
        ));
  }
}
