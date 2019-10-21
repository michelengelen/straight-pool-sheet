import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sps/actions/actions.dart';

import 'package:sps/constants/routes.dart';
import 'package:sps/container/settings.dart';
import 'package:sps/pages/home.dart';
import 'package:sps/models/models.dart';
import 'package:sps/pages/profile.dart';
import 'package:sps/reducers/app_state_reducer.dart';

void main() => runApp(SPS());

class SPS extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new StoreConnector(
        converter: (Store<AppState> store) => store.state.settings,
        builder: (context, settings) {
          return MaterialApp(
            title: 'Straight Pool Sheet',
            theme: settings.darkMode ? ThemeData.dark() : ThemeData.light(),
            routes: {
              Routes.home: (context) {
                return HomeScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context).dispatch(loadUserAction());
                  },
                );
              },
              Routes.profile: (context) {
                return ProfileScreen();
              },
              Routes.settings: (context) {
                return SettingsScreen();
              },
            },
          );
        },
      ),
    );
  }
}