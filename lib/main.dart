import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sps/redux/actions/actions.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/container/settings.dart';
import 'package:sps/redux/middlewares/settings_middleware.dart';
import 'package:sps/redux/states/settings_state.dart';
import 'package:sps/screens/home.dart';
import 'package:sps/redux/states/models.dart';
import 'package:sps/container/profile.dart';
import 'package:sps/redux/reducers/app_state_reducer.dart';
import 'package:sps/generated/i18n.dart';

Future<void> main() async {
  final SharedPreferences _sprefs = await SharedPreferences.getInstance();

  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(_sprefs),
    middleware: <Middleware<AppState>>[
      thunkMiddleware,
      ...createStoreSettingsMiddleware(),
    ]
  );

  runApp(SPS(store: store));
}

@immutable
class SPS extends StatelessWidget {
  const SPS({
    @required this.store,
  });

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, SettingsState>(
        converter: (Store<AppState> store) => store.state.settings,
        builder: (BuildContext context, SettingsState settings) {
          return MaterialApp(
            locale: Locale(settings.locale, ''),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              S.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback:
                S.delegate.resolution(fallback: const Locale('en', '')),
            title: 'Straight Pool Sheet',
            theme: settings.darkMode ? ThemeData.dark() : ThemeData.light(),
            routes: <String, Widget Function(BuildContext)>{
              Routes.home: (BuildContext context) {
                return HomeScreen(
                  onInit: () {
                    final Locale systemLocale = Localizations.localeOf(context);
                    StoreProvider.of<AppState>(context).dispatch(ChangeLanguageAction(languageCode: systemLocale.languageCode));
                    StoreProvider.of<AppState>(context).dispatch(loadUserAction());
                  },
                );
              },
              Routes.profile: (BuildContext context) {
                return const ProfileScreen();
              },
              Routes.settings: (BuildContext context) {
                return const SettingsScreen();
              },
            },
          );
        },
      ),
    );
  }
}
