import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sps/actions/actions.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/container/settings.dart';
import 'package:sps/pages/home.dart';
import 'package:sps/models/models.dart';
import 'package:sps/pages/profile.dart';
import 'package:sps/reducers/app_state_reducer.dart';
import 'package:sps/generated/i18n.dart';

void main() async {
  SharedPreferences _sprefs = await SharedPreferences.getInstance();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(_sprefs),
    middleware: [thunkMiddleware],
  );

  runApp(SPS(store: store));
}

class SPS extends StatelessWidget {
  final Store<AppState> store;

  SPS({
    @required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new StoreConnector(
        converter: (Store<AppState> store) => store.state.settings,
        builder: (context, settings) {
          return MaterialApp(
            locale: new Locale(settings.locale, ""),
            localizationsDelegates: [
              S.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback:
                S.delegate.resolution(fallback: new Locale("en", "")),
            title: 'Straight Pool Sheet',
            theme: settings.darkMode ? ThemeData.dark() : ThemeData.light(),
            routes: {
              Routes.home: (context) {
                return HomeScreen(
                  onInit: () {
                    final Locale systemLocale = Localizations.localeOf(context);
                    StoreProvider.of<AppState>(context).dispatch(changeLocaleAction(systemLocale.languageCode));
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
