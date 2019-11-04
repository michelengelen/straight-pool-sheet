import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/redux/states/app_state.dart';
import 'package:sps/services/auth.dart';

List<Middleware<AppState>> createStoreAuthMiddleware() {
  final Middleware<AppState> loadUser = _loadUser();
  final Middleware<AppState> signInUserSocial = _signInUserSocial();

  return <Middleware<AppState>>[
    TypedMiddleware<AppState, LoadUserAction>(loadUser),
    TypedMiddleware<AppState, SignInUserSocial>(signInUserSocial),
  ];
}

Middleware<AppState> _loadUser() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final LoadUserAction action = dynamicAction;

    next(action);

    store.dispatch(AppIsLoading());
    Future<void>(() async {
      auth.getCurrentUser().then((FirebaseUser user) {
        store.dispatch(LoadUserActionSuccess(user));
        store.dispatch(AppIsLoaded());
      }).catchError((Object error) {
        store.dispatch(LoadUserActionFailure());
        store.dispatch(AppIsLoaded());
      });
    }).then<void>((dynamic _) {
      if (action.completer != null)
        action.completer.complete();
    });
  };
}

Middleware<AppState> _signInUserSocial() {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignInUserSocial action = dynamicAction;

    next(action);

    store.dispatch(AppIsLoading());
    Future<AuthResponse>(() async {
      AuthResponse authResponse;
      switch (action.type) {
        case 'FB':
          authResponse = await auth.handleFacebookLogin();
          break;
        case 'G':
          authResponse = await auth.handleGoogleLogin();
          break;
        default:
          authResponse = const AuthResponse(
            user: null,
            error: true,
            cancelled: false,
            message: 'Something went terribly wrong!',
          );
          break;
      }
      if (authResponse.error || authResponse.cancelled)
        return Future<AuthResponse>.error(authResponse);

      return authResponse;
    }).then<void>((AuthResponse authResponse) {
      store.dispatch(LoadUserActionSuccess(authResponse.user));
      store.dispatch(AppIsLoaded());
      action.completer.complete();
    }).catchError((Object authResponse) {
      action.completer.completeError(authResponse);
      store.dispatch(LoadUserActionFailure());
      store.dispatch(AppIsLoaded());
    });
  };
}
