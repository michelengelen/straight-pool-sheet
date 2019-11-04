import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/welcome.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/container/login.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/root_state.dart';

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({@required this.onInit}) : super(key: Keys.homeScreen);

  final void Function() onInit;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, FirebaseUser>(
      converter: (Store<RootState> store) => store.state.auth.user,
      builder: (BuildContext context, FirebaseUser user) {
        return Wrapper(
          title: S.of(context).screen_home_title,
          child: user != null
              ? WelcomeComponent(user: user)
              : const LoginSignupScreen(),
        );
      },
    );
  }
}
