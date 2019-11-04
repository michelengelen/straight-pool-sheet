import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/redux/states/app_state.dart';
import 'package:sps/services/auth.dart';

final Auth auth = Auth();

/// action Base Class
class CompleterAction {
  CompleterAction({
    this.completer,
    this.errorCompleter,
  });

  final Completer<void> completer;
  final Completer<void> errorCompleter;
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

class UserLoadedAction {
  UserLoadedAction(this.user);

  final FirebaseUser user;

  @override
  String toString() {
    return 'UserLoadedAction{user: $user}';
  }
}

class UserNotLoadedAction {}

class NotificationAction {
  NotificationAction({
    this.message,
    this.type,
    this.duration,
  });

  final String message;
  final NotificationType type;
  final int duration;

  @override
  String toString() {
    return 'ShowSnackbarAction{message: $message, type: $type, duration: $duration}';
  }
}

class NotificationHandledAction {}

/// SETTINGS ACTIONS
class ChangeLanguageAction extends CompleterAction {
  ChangeLanguageAction({
    this.languageCode,
    Completer<void> completer,
    Completer<void> errorCompleter,
  }) : super(completer: completer, errorCompleter: errorCompleter);

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
    Completer<void> errorCompleter,
  }) : super(completer: completer, errorCompleter: errorCompleter);
}

class ToggleThemeActionSuccess {}

ThunkAction<AppState> toggleThemeAction(bool previous) {
  return (Store<AppState> store) async {
    Future<void>(() async {
      final SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setBool('darkMode', !previous);
      store.dispatch(ToggleThemeAction());
    });
  };
}

/// AUTH ACTIONS
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
        store.dispatch(UserLoadedAction(authResponse.user));
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
        store.dispatch(UserLoadedAction(user));
        _toggleAppLoading(store, false);
      }).catchError((Object error) {
        store.dispatch(UserNotLoadedAction());
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
      store.dispatch(UserNotLoadedAction());
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
        store.dispatch(UserLoadedAction(user));
        store.dispatch(AppIsLoaded());
      } catch (e) {
        store.dispatch(UserNotLoadedAction());
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
        store.dispatch(UserLoadedAction(user));
        store.dispatch(AppIsLoaded());
      } catch (e) {
        store.dispatch(UserNotLoadedAction());
        store.dispatch(AppIsLoaded());
      }
    });
  };
}
