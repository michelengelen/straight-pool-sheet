import 'package:flutter/material.dart';
import 'package:sps/components/tabbedWrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/settings/settings_state.dart';

final List<Locale> supportedLanguages = S.delegate.supportedLocales;

String _getLanguageString(BuildContext context, String languageCode) {
  switch (languageCode) {
    case 'de':
      return S.of(context).locales_de;
      break;
    case 'en':
    default:
      return S.of(context).locales_en;
      break;
  }
}

String _getSwitchedLanguageMessage(String languageCode) {
  switch (languageCode) {
    case 'de':
      return const $de().setting_language_switched;
      break;
    case 'en':
    default:
      return const $en().setting_language_switched;
      break;
  }
}

@immutable
class Settings extends StatelessWidget {
  const Settings({
    @required this.toggleTheme,
    @required this.switchLocale,
    @required this.currentSettings,
  }) : super(key: Keys.settingsScreen);

  final void Function(BuildContext context) toggleTheme;
  final void Function(BuildContext context, String locale, String message) switchLocale;
  final SettingsState currentSettings;

  // TODO(michel): definitely make this better somehow!!!
  @override
  Widget build(BuildContext context) {
    final bool darkMode = currentSettings.darkMode;
    final List<Map<String, dynamic>> tabs = <Map<String, dynamic>>[
      <String, dynamic>{
        'icon': const Icon(Icons.settings),
        'view': (BuildContext context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: <Widget>[
                    ListTile(
                      title: Text(
                        'App-Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text(S.of(context).setting_darkMode_title),
                      subtitle: Text(S.of(context).setting_darkMode_subtitle),
                      value: darkMode,
                      onChanged: (bool value) {
                        toggleTheme(context);
                      },
                      secondary: const Icon(Icons.brightness_3),
                    ),
                    ListTile(
                      title: Text(S.of(context).setting_language_title),
                      subtitle: Text(S.of(context).setting_language_subtitle(
                            _getLanguageString(context, currentSettings.locale),
                          )),
                      leading: const Icon(Icons.flag),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String languageCode) {
                          final String message = _getSwitchedLanguageMessage(languageCode);
                          switchLocale(context, languageCode, message);
                        },
                        itemBuilder: (BuildContext context) => supportedLanguages
                            .map((Locale item) => PopupMenuItem<String>(
                                  value: item.languageCode,
                                  child: Text(_getLanguageString(context, item.languageCode)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ).toList(),
              ),
            )
      },
      <String, dynamic>{
        'icon': const Icon(Icons.videogame_asset),
        'view': (BuildContext context) => Center(
              child: const Text('GameSettings'),
            ),
      }
    ];
    return TabbedWrapper(
      title: S.of(context).screen_settings_title,
      tabs: tabs,
    );
  }
}
