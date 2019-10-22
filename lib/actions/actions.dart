import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sps/services/auth.dart';

final Auth auth = new Auth();

class AppIsLoaded {}

class ToggleTheme {}

ThunkAction toggleTheme(bool previous) {
  return (Store store) async {
    new Future(() async {
      SharedPreferences _sprefs = await SharedPreferences.getInstance();
      _sprefs.setBool('darkMode', !previous);
      store.dispatch(ToggleTheme());
    });
  };
}

class AppIsLoading {}

class AppErrorAction {
  final String errorMessage;

  AppErrorAction(this.errorMessage);

  @override
  String toString() {
    return 'AppErrorAction{errorMessage: $errorMessage}';
  }
}

class UserLoadedAction {
  final FirebaseUser user;

  UserLoadedAction(this.user);

  @override
  String toString() {
    return 'UserLoadedAction{user: $user}';
  }
}

class UserNotLoadedAction {}

void _toggleAppLoading(Store store, bool shouldLoad) {
  final bool isLoading = store.state.isLoading;
  if (!isLoading && shouldLoad) {
    store.dispatch(AppIsLoading());
  } else if (isLoading && !shouldLoad) {
    store.dispatch(AppIsLoaded());
  }
}

ThunkAction socialLogin(String type) {
  return (Store store) async {
    _toggleAppLoading(store, true);
    new Future(() async {
      AuthResponse authResponse;
      switch (type) {
        case "FB":
          authResponse = await auth.handleFacebookLogin();
          break;
        case "G":
          authResponse = await auth.handleGoogleLogin();
          break;
        default:
          authResponse = new AuthResponse(
            user: null,
            error: true,
            cancelled: false,
            message: "Something went terribly wrong!",
          );
          break;
      }
      if (authResponse != null && (!authResponse.error || !authResponse.cancelled)) {
        store.dispatch(UserLoadedAction(authResponse.user));
      } else store.dispatch(AppErrorAction(authResponse.message));
      _toggleAppLoading(store, false);
    });
  };
}

ThunkAction loadUserAction() {
  return (Store store) async {
    _toggleAppLoading(store, true);
    new Future(() async {
      auth.getCurrentUser()
        .then((user) {
          store.dispatch(UserLoadedAction(user));
          _toggleAppLoading(store, false);
        })
        .catchError((error) {
          store.dispatch(UserNotLoadedAction());
          _toggleAppLoading(store, false);
        });
    });
  };
}

ThunkAction logoutUserAction() {
  return (Store store) async {
    store.dispatch(AppIsLoading());
    new Future(() async {
      await auth.logOut();
      store.dispatch(UserNotLoadedAction());
      store.dispatch(AppIsLoaded());
    });
  };
}

ThunkAction registerUserAction(String email, String password) {
  return (Store store) async {
    store.dispatch(AppIsLoading());
    new Future(() async {
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