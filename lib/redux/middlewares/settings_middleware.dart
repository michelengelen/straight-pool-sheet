import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/redux/states/app_state.dart';

List<Middleware<AppState>> createStoreSettingsMiddleware() {
  final Middleware<AppState> changeLanguage = _changeLanguage();

  return <Middleware<AppState>>[
    TypedMiddleware<AppState, ChangeLanguageAction>(changeLanguage),
  ];
}

Middleware<AppState> _changeLanguage() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final ChangeLanguageAction action = dynamicAction;

    next(action);

    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setString('lnguageCode', action.languageCode);
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