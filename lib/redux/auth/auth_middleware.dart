import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/view/view_actions.dart';
import 'package:sps/services/auth.dart';

final Auth auth = Auth();

List<Middleware<RootState>> createStoreAuthMiddleware() {
  final Middleware<RootState> loadUser = _loadUser();
  final Middleware<RootState> signInUser = _signInUser();
  final Middleware<RootState> signUpUser = _signUpUser();
  final Middleware<RootState> signOutUser = _signOutUser();
  final Middleware<RootState> signInUserSocial = _signInUserSocial();

  return <Middleware<RootState>>[
    TypedMiddleware<RootState, LoadUserAction>(loadUser),
    TypedMiddleware<RootState, SignIn>(signInUser),
    TypedMiddleware<RootState, SignUp>(signUpUser),
    TypedMiddleware<RootState, SignOut>(signOutUser),
    TypedMiddleware<RootState, SignInSocial>(signInUserSocial),
  ];
}

Middleware<RootState> _loadUser() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final LoadUserAction action = dynamicAction;

    next(action);

    store.dispatch(AppIsLoading());
    Future<void>(() async {
      auth.getCurrentUser().then((FirebaseUser user) {
        store.dispatch(SetUser(user));
        store.dispatch(AppIsLoaded());
      }).catchError((Object error) {
        store.dispatch(UnsetUser());
        store.dispatch(AppIsLoaded());
      });
    }).then<void>((dynamic _) {
      if (action.completer != null)
        action.completer.complete();
    });
  };
}

Middleware<RootState> _signInUser() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignIn action = dynamicAction;
    final BuildContext context = action.context;

    next(action);

    store.dispatch(AppIsLoading());
    Future<AuthResponse>(() async {
      final AuthResponse authResponse = await auth.signIn(context, action.email, action.password);
      if (authResponse.error || authResponse.cancelled)
        return Future<AuthResponse>.error(authResponse);

      return authResponse;
    }).then<void>((AuthResponse authResponse) {
      store.dispatch(SetUser(authResponse.user));
      store.dispatch(AppIsLoaded());
      action.completer.complete();
    }).catchError((Object authResponse) {
      action.completer.completeError(authResponse);
      store.dispatch(UnsetUser());
      store.dispatch(AppIsLoaded());
    });
  };
}

Middleware<RootState> _signUpUser() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignUp action = dynamicAction;
    final BuildContext context = action.context;

    next(action);

    store.dispatch(AppIsLoading());
    Future<AuthResponse>(() async {
      final AuthResponse authResponse = await auth.signUp(context, action.email, action.password);
      if (authResponse.error || authResponse.cancelled)
        return Future<AuthResponse>.error(authResponse);

      return authResponse;
    }).then<void>((AuthResponse authResponse) {
      store.dispatch(SetUser(authResponse.user));
      store.dispatch(AppIsLoaded());
      action.completer.complete();
    }).catchError((Object authResponse) {
      action.completer.completeError(authResponse);
      store.dispatch(UnsetUser());
      store.dispatch(AppIsLoaded());
    });
  };
}

Middleware<RootState> _signOutUser() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignOut action = dynamicAction;

    next(action);

    store.dispatch(AppIsLoading());
    Future<dynamic>(() async {
      try {
        await auth.signOut();
      } on PlatformException catch (error) {
        return Future<void>.error(error);
      }
    }).then<void>((dynamic _) {
      store.dispatch(UnsetUser());
      store.dispatch(AppIsLoaded());
      action.completer.complete();
    }).catchError((Object response) {
      action.completer.completeError(response);
      store.dispatch(AppIsLoaded());
    });
  };
}

Middleware<RootState> _signInUserSocial() {
  return (Store<RootState> store, dynamic dynamicAction, NextDispatcher next) {
    final SignInSocial action = dynamicAction;
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
            message: S.of(context).ERROR_UNDEFINED,
          );
          break;
      }
      if (authResponse.error || authResponse.cancelled)
        return Future<AuthResponse>.error(authResponse);

      return authResponse;
    }).then<void>((AuthResponse authResponse) {
      store.dispatch(SetUser(authResponse.user));
      store.dispatch(AppIsLoaded());
      action.completer.complete();
    }).catchError((Object authResponse) {
      action.completer.completeError(authResponse);
      store.dispatch(UnsetUser());
      store.dispatch(AppIsLoaded());
    });
  };
}
