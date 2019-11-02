import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sps/actions/actions.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/models/app_state.dart';

@immutable
class Profile extends StatelessWidget {
  const Profile({
    @required this.user,
    @required this.changePassword,
  }) : super(key: Keys.profileScreen);

  final FirebaseUser user;
  final Function changePassword;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        final FirebaseUser user = store.state.auth.user;
        return Wrapper(
          title: S.of(context).screen_profile_title,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(user.displayName + "'s Profile Page"),
                RaisedButton(
                  child: const Text('SHOW SNACKBAR'),
                  onPressed: () {
                    store.dispatch(NotificationAction(
                      message: 'TEST SNACKBAR',
                      type: NotificationType.INFO,
                      duration: 200));
                  }),
              ],
          )),
        );
      },
    );
  }
}
