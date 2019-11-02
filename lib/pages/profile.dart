import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/components/notifier.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/models/app_state.dart';

class Profile extends StatelessWidget {
  final FirebaseUser user;
  final Function changePassword;

  Profile({
    @required this.user,
    @required this.changePassword,
  }) : super(key: Keys.profileScreen);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: (Store<AppState> store) => store,
      builder: (context, store) {
        final FirebaseUser user = store.state.auth.user;
        return new Wrapper(
          title: S.of(context).screen_profile_title,
          child: Notifier(
            child: new Center(
                child: new Column(
                  children: [
                    new Text(user.displayName + "'s Profile Page"),
                    new RaisedButton(
                      child: new Text('SHOW SNACKBAR'),
                      onPressed: () {
                        store.dispatch(NotificationAction(message: 'TEST SNACKBAR', type: NotificationType.INFO, duration: 20));
                      }
                    ),
                  ],
                )
            ),
          )
        );
      },
    );
  }
}
