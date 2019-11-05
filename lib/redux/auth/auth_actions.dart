import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sps/components/login.dart';
import 'package:sps/redux/_helper/completer.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/view/view_actions.dart';
import 'package:sps/services/auth.dart';

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
    this.context,
    Completer<void> completer,
  }) : super(completer: completer);

  final String type;
  final BuildContext context;

  @override
  String toString() {
    return 'SignInUserSocial{type: $type, context: $context}';
  }
}

ThunkAction<RootState> loadUserAction() {
  return (Store<RootState> store) async {
    store.dispatch(AppIsLoading());
    Future<void>(() async {
      auth.getCurrentUser().then((FirebaseUser user) {
        store.dispatch(LoadUserActionSuccess(user));
        store.dispatch(AppIsLoaded());
      }).catchError((Object error) {
        store.dispatch(LoadUserActionFailure());
        store.dispatch(AppIsLoaded());
      });
    });
  };
}

ThunkAction<RootState> logoutUserAction() {
  return (Store<RootState> store) async {
    store.dispatch(AppIsLoading());
    Future<void>(() async {
      await auth.logOut();
      store.dispatch(LoadUserActionFailure());
      store.dispatch(AppIsLoaded());
    });
  };
}

ThunkAction<RootState> registerUserAction(String email, String password) {
  return (Store<RootState> store) async {
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
ThunkAction<RootState> changePasswordAction(String newPassword) {
  return (Store<RootState> store) async {
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