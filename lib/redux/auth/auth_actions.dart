import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sps/utils/redux_helper.dart';

/// AUTH ACTIONS
class LoadUserAction extends CompleterAction {
  LoadUserAction({
    Completer<void> completer,
  }) : super(completer: completer);
}

class SetUser {
  SetUser(this.user);

  final FirebaseUser user;

  @override
  String toString() {
    return 'UserLoadedAction{user: $user}';
  }
}

class UnsetUser {}

class SignIn extends CompleterAction {
  SignIn({
    this.email,
    this.password,
    this.context,
    Completer<void> completer,
  }) : super(completer: completer);

  final String email;
  final String password;
  final BuildContext context;

  @override
  String toString() {
    return 'SignIn{email: $email, password: $password, context: $context}';
  }
}

class SignUp extends CompleterAction {
  SignUp({
    this.email,
    this.password,
    this.context,
    Completer<void> completer,
  }) : super(completer: completer);

  final String email;
  final String password;
  final BuildContext context;

  @override
  String toString() {
    return 'SignUp{email: $email, password: $password, context: $context}';
  }
}

class SignOut extends CompleterAction {
  SignOut({
    Completer<void> completer,
  }) : super(completer: completer);

  @override
  String toString() {
    return 'SignOut{}';
  }
}

class SignInSocial extends CompleterAction {
  SignInSocial({
    this.type,
    this.context,
    Completer<void> completer,
  }) : super(completer: completer);

  final String type;
  final BuildContext context;

  @override
  String toString() {
    return 'SignInSocial{type: $type, context: $context}';
  }
}

//ThunkAction<RootState> logoutUserAction() {
//  return (Store<RootState> store) async {
//    store.dispatch(AppIsLoading());
//    Future<void>(() async {
//      await auth.signOut();
//      store.dispatch(LoadUserActionFailure());
//      store.dispatch(AppIsLoaded());
//    });
//  };
//}