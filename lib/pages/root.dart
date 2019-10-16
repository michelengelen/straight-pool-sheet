import 'package:flutter/material.dart';
import 'package:sps/pages/login.dart';
import 'package:sps/services/auth.dart';
import 'package:sps/models/models.dart';
import 'package:sps/actions/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RootPage extends StatelessWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnLoginCallback>(
      converter: (Store<AppState> store) {
        return (FirebaseUser user) {
          store.dispatch(
            UserLoadedAction(user),
          );
        };
      },
      builder: (context, OnLoginCallback onLogin) {
        return new LoginSignupPage(
          auth: auth,
          loginCallback: onLogin,
        );
      },
    );
  }
}