import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/redux/states/app_state.dart';
import 'package:sps/services/auth.dart';

final Auth auth = Auth();

/// action Base Class
class CompleterAction {
  CompleterAction({
    this.completer,
  });

  final Completer<void> completer;
}

/// APP ACTIONS
class AppIsLoaded {}

class AppIsLoading {}

void _toggleAppLoading(Store<AppState> store, bool shouldLoad) {
  final bool isLoading = store.state.isLoading;
  if (!isLoading && shouldLoad) {
    store.dispatch(AppIsLoading());
  } else if (isLoading && !shouldLoad) {
    store.dispatch(AppIsLoaded());
  }
}

class AppErrorAction {
  AppErrorAction(this.errorMessage);

  final String errorMessage;

  @override
  String toString() {
    return 'AppErrorAction{errorMessage: $errorMessage}';
  }
}

/// SETTINGS ACTIONS
class ChangeLanguageAction extends CompleterAction {
  ChangeLanguageAction({
    this.languageCode,
    Completer<void> completer,
  }) : super(completer: completer);

  final String languageCode;

  @override
  String toString() {
    return 'ChangeLanguageAction{languageCode: $languageCode}';
  }
}

class ChangeLanguageActionSuccess {
  ChangeLanguageActionSuccess(this.locale);

  final String locale;

  @override
  String toString() {
    return 'ChangeLanguageAction{locale: $locale}';
  }
}

class ToggleThemeAction extends CompleterAction {
  ToggleThemeAction({
    Completer<void> completer,
  }) : super(completer: completer);
}

class ToggleThemeActionSuccess {}

/// AUTH ACTIONS
class LoadUserAction extends CompleterAction {
  LoadUserAction({
    Completer<void> completer,
  }) : super(completer: completer);
}

class LoadUserActionSuccess {
  LoadUserActionSuccess(this.user);

  final FirebaseUser user;

  @override
  String toString() {
    return 'UserLoadedAction{user: $user}';
  }
}

class LoadUserActionFailure {}

class SignInUserSocial extends CompleterAction {
  SignInUserSocial({
    this.type,
    Completer<void> completer,
  }) : super(completer: completer);

  final String type;

  @override
  String toString() {
    return 'SignInUserSocial{type: $type}';
  }
}

ThunkAction<AppState> socialLogin(String type) {
  return (Store<AppState> store) {
    _toggleAppLoading(store, true);
    Future<void>(() async {
      AuthResponse authResponse;
      switch (type) {
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
      if (authResponse != null &&
          (!authResponse.error || !authResponse.cancelled)) {
        store.dispatch(LoadUserActionSuccess(authResponse.user));
      } else {
        store.dispatch(AppErrorAction(authResponse.message));
      }
      _toggleAppLoading(store, false);
    });
  };
}

ThunkAction<AppState> loadUserAction() {
  return (Store<AppState> store) async {
    _toggleAppLoading(store, true);
    Future<void>(() async {
      auth.getCurrentUser().then((FirebaseUser user) {
        store.dispatch(LoadUserActionSuccess(user));
        _toggleAppLoading(store, false);
      }).catchError((Object error) {
        store.dispatch(LoadUserActionFailure());
        _toggleAppLoading(store, false);
      });
    });
  };
}

ThunkAction<AppState> logoutUserAction() {
  return (Store<AppState> store) async {
    store.dispatch(AppIsLoading());
    Future<void>(() async {
      await auth.logOut();
      store.dispatch(LoadUserActionFailure());
      store.dispatch(AppIsLoaded());
    });
  };
}

ThunkAction<AppState> registerUserAction(String email, String password) {
  return (Store<AppState> store) async {
    store.dispatch(AppIsLoading());
    Future<void>(() async {
      FirebaseUser user;
      try {
        user = await auth.register(email, password);
        store.dispatch(LoadUserActionSuccess(user));
        store.dispatch(AppIsLoaded());
      } catch (e) {
        store.dispatch(LoadUserActionFailure());
        store.dispatch(AppIsLoaded());
      }
    });
  };
}

/// PROFILE ACTIONS
ThunkAction<AppState> changePasswordAction(String newPassword) {
  return (Store<AppState> store) async {
    store.dispatch(AppIsLoading());
    Future<void>(() async {
      final FirebaseUser user = store.state.auth.user;
      try {
        user.updatePassword(newPassword);
        store.dispatch(LoadUserActionSuccess(user));
        store.dispatch(AppIsLoaded());
      } catch (e) {
        store.dispatch(LoadUserActionFailure());
        store.dispatch(AppIsLoaded());
      }
    });
  };
}
