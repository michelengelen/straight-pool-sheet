import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/models/app_state.dart';

class Settings extends StatelessWidget {
  final void Function() toggleTheme;

  Settings({@required this.toggleTheme}) : super(key: Keys.settingsScreen);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: (Store<AppState> store) => store.state.settings,
      builder: (context, settings) {
        final bool darkMode = settings.darkMode;
        print(settings);
        return new Wrapper(
          title: 'Settings',
          child: new Center(
            child: new Switch(
              value: darkMode,
              onChanged: (bool darkMode) { toggleTheme(); },
            ),
          ),
        );
      },
    );
  }
}