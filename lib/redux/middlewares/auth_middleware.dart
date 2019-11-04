import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/redux/states/app_state.dart';

List<Middleware<AppState>> createStoreSettingsMiddleware() {
  final Middleware<AppState> changeLanguage = _changeLanguage();
  final Middleware<AppState> toggleTheme = _toggleTheme();

  return <Middleware<AppState>>[
    TypedMiddleware<AppState, ChangeLanguageAction>(changeLanguage),
    TypedMiddleware<AppState, ToggleThemeAction>(toggleTheme),
  ];
}

Middleware<AppState> _changeLanguage() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final ChangeLanguageAction action = dynamicAction;

    next(action);

    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setString('languageCode', action.languageCode);
      store.dispatch(ChangeLanguageActionSuccess(action.languageCode));
    })
    .then<void>((dynamic _) {
      if (action.completer != null)
        action.completer.complete();
    })
    .catchError((Object error) {
      if (action.errorCompleter != null)
        action.errorCompleter.complete();
    });
  };
}

Middleware<AppState> _toggleTheme() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final ToggleThemeAction action = dynamicAction;
    final bool previous = store.state.settings.darkMode;

    next(action);

    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setBool('darkMode', !previous);
      store.dispatch(ToggleThemeActionSuccess());
    })
    .then<void>((dynamic _) {
      if (action.completer != null)
        action.completer.complete();
    })
    .catchError((Object error) {
      if (action.errorCompleter != null)
        action.errorCompleter.complete();
    });
  };
}