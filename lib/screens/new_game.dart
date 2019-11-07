import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/root_state.dart';

@immutable
class NewGameScreen extends StatefulWidget {
  const NewGameScreen() : super(key: Keys.newGameScreen);

  @override
  NewGameScreenState createState() {
    return NewGameScreenState();
  }
}

class NewGameScreenState extends State<NewGameScreen> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, FirebaseUser>(
      converter: (Store<RootState> store) => store.state.auth.user,
      builder: (BuildContext context, FirebaseUser user) {
        return Wrapper(
          title: S
            .of(context)
            .screen_new_game_title,
          child: Center(
            child: const Text('New Game Screen'),
          ),
        );
      },
    );
  }
}
