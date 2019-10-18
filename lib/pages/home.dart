import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/welcome.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/container/drawer.dart';
import 'package:sps/container/login.dart';
import 'package:sps/models/app_state.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;

  HomeScreen({@required this.onInit}) : super(key: Keys.homeScreen);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
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
    return new StoreConnector(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        final bool isLoading = state.isLoading;
        final FirebaseUser user = state.auth.user;
        print(user);
        return new Scaffold(
          drawer: new DrawerMenu(),
          appBar: new AppBar(
            title: new Text('HomePage'),
          ),
          body: new AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              child: isLoading ?
                new Stack(
                  children: [
                    new ModalBarrier(
                        dismissible: false,
                        color: Colors.black
                    ),
                    new Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ],
                ) :
                user != null ? new WelcomeComponent(user: user) : new LoginSignupScreen()
          ),
        );
      },
    );
  }
}