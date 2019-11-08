import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/settings/settings_actions.dart';

List<Middleware<RootState>> createStoreSettingsMiddleware() {
  final Middleware<RootState> changeLanguage = _changeLanguage();
  final Middleware<RootState> toggleTheme = _toggleTheme();

  return <Middleware<RootState>>[
    TypedMiddleware<RootState, ChangeLanguageAction>(changeLanguage),
    TypedMiddleware<RootState, ToggleThemeAction>(toggleTheme),
  ];
}

Middleware<RootState> _changeLanguage() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final ChangeLanguageAction action = dynamicAction;

    next(action);

    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setString('languageCode', action.languageCode);
      store.dispatch(ChangeLanguageActionSuccess(action.languageCode));
    }).then<void>((dynamic _) {
      if (action.completer != null) action.completer.complete();
    });
  };
}

Middleware<RootState> _toggleTheme() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final ToggleThemeAction action = dynamicAction;
    final bool previous = store.state.settings.darkMode;

    next(action);

    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setBool('darkMode', !previous);
      store.dispatch(ToggleThemeActionSuccess());
    }).then<void>((dynamic _) {
      if (action.completer != null) action.completer.complete();
    });
  };
}
