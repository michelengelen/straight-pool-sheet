import 'package:flutter/material.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/models/settings_state.dart';

final List<Locale> supportedLanguages = S.delegate.supportedLocales;

_getLanguageString(context, languageCode) {
  switch (languageCode) {
    case "de":
      return S.of(context).locales_de;
      break;
    case "en":
    default:
      return S.of(context).locales_en;
      break;
  }
}

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
        title: S.of(context).screen_settings_title,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                SwitchListTile(
                  title: Text(S.of(context).setting_darkMode_title),
                  subtitle: Text(S.of(context).setting_darkMode_subtitle),
                  value: darkMode,
                  onChanged: (bool value) {
                    toggleTheme();
                  },
                  secondary: Icon(
                    Icons.brightness_3,
                  ),
                ),
                ListTile(
                  title: Text(S.of(context).setting_language_title),
                  subtitle: Text(S.of(context).setting_language_subtitle(
                      _getLanguageString(context, currentSettings.locale),
                  )),
                  leading: Icon(Icons.flag),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String locale) {
                      switchLocale(locale);
                    },
                    itemBuilder: (BuildContext context) => supportedLanguages.map((Locale item) => PopupMenuItem(
                        value: item.languageCode,
                        child: new Text(_getLanguageString(context, item.languageCode)),
                      )).toList(),
                  ),
                ),
              ],
            ).toList(),
          ),
        ));
  }
}
