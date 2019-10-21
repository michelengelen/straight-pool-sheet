import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/models/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final void Function() onInit;

  ProfileScreen({@required this.onInit}) : super(key: Keys.homeScreen);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        final FirebaseUser user = state.auth.user;
        print(user);
        return new Wrapper(
          title: 'Profile',
          child: new Center(
            child: new Text(
              user.displayName + "Profile Page"
            ),
          ),
        );
      },
    );
  }
}