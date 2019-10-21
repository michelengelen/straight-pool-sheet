import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/models/app_state.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

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
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: ListView(
                children: ListTile.divideTiles(context: context, tiles: [
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
                    // leading: Text('EN'),
                    trailing: PopupMenuButton<WhyFarther>(
                      onSelected: (WhyFarther result) {},
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<WhyFarther>>[
                        const PopupMenuItem<WhyFarther>(
                          value: WhyFarther.harder,
                          child: Text('Working a lot harder'),
                        ),
                        const PopupMenuItem<WhyFarther>(
                          value: WhyFarther.smarter,
                          child: Text('Being a lot smarter'),
                        ),
                        const PopupMenuItem<WhyFarther>(
                          value: WhyFarther.selfStarter,
                          child: Text('Being a self-starter'),
                        ),
                        const PopupMenuItem<WhyFarther>(
                          value: WhyFarther.tradingCharter,
                          child: Text('Placed in charge of trading charter'),
                        ),
                      ],
                    ),
                  ),
                ]).toList(),
              )),
        );
      },
    );
  }
}
