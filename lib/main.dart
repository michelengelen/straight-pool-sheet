import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/container/profile.dart';
import 'package:sps/container/settings.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/auth/auth_middleware.dart';
import 'package:sps/redux/root_reducer.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/settings/settings_actions.dart';
import 'package:sps/redux/settings/settings_middleware.dart';
import 'package:sps/redux/settings/settings_state.dart';
import 'package:sps/screens/home.dart';

Future<void> main() async {
  final SharedPreferences _sprefs = await SharedPreferences.getInstance();

  final Store<RootState> store = Store<RootState>(appReducer,
    initialState: RootState.initial(_sprefs),
    middleware: <Middleware<RootState>>[
      thunkMiddleware,
      ...createStoreSettingsMiddleware(),
      ...createStoreAuthMiddleware(),
    ]);

  runApp(SPS(store: store));
}

@immutable
class SPS extends StatelessWidget {
  const SPS({
    @required this.store,
  });

  final Store<RootState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<RootState>(
      store: store,
      child: StoreConnector<RootState, SettingsState>(
        converter: (Store<RootState> store) => store.state.settings,
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
                    StoreProvider.of<RootState>(context).dispatch(
                      ChangeLanguageAction(
                        languageCode: systemLocale.languageCode));
                    StoreProvider.of<RootState>(context)
                      .dispatch(LoadUserAction());
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
