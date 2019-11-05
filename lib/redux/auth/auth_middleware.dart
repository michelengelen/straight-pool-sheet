import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/login.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/view/view_actions.dart';
import 'package:sps/services/auth.dart';

List<Middleware<RootState>> createStoreAuthMiddleware() {
  final Middleware<RootState> loadUser = _loadUser();
  final Middleware<RootState> signInUserSocial = _signInUserSocial();

  return <Middleware<RootState>>[
    TypedMiddleware<RootState, LoadUserAction>(loadUser),
    TypedMiddleware<RootState, SignInUserSocial>(signInUserSocial),
  ];
}

Middleware<RootState> _loadUser() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
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

Middleware<RootState> _signInUserSocial() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignInUserSocial action = dynamicAction;
    final BuildContext context = action.context;

    next(action);

    store.dispatch(AppIsLoading());
    Future<AuthResponse>(() async {
      AuthResponse authResponse;
      switch (action.type) {
        case 'FB':
          authResponse = await auth.handleFacebookLogin(context);
          break;
        case 'G':
          authResponse = await auth.handleGoogleLogin(context);
          break;
        default:
          authResponse = AuthResponse(
            user: null,
            error: true,
            cancelled: false,
            message: S.of(context).ERROR_CRITICAL,
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
