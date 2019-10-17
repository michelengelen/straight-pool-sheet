import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/loading.dart';
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
        var body = new List<Widget>();
        if (user != null) {
          body.add(new WelcomeComponent(user: user));
        } else {
          body.add(new LoginSignupScreen());
        }
        if (isLoading) {
          var loader = new Stack(
            children: [
              new Opacity(
                opacity: 0.8,
                // The green box must be a child of the AnimatedOpacity widget.
                child: const ModalBarrier(dismissible: false, color: Colors.black),
              ),
              new Center(
                child: new CircularProgressIndicator(),
              ),
            ],
          );
          body.add(loader);
        }
        return new Scaffold(
          endDrawer: new DrawerMenu(),
          appBar: new AppBar(
            title: new Text('HomePage'),
          ),
          body: new Stack(
            children: body,
          )
        );
      },
    );
  }
}