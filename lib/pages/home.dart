import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/welcome.dart';
import 'package:sps/constants/keys.dart';
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
      converter: (Store<AppState> store) => store.state.auth.user,
      builder: (context, user) {
        print('########### FROM HOME SCREEN ###########');
        print(user);
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('HomePage'),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                    'Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () {print('### BTNpress');},
              )
            ],
          ),
          body: user != null ? new WelcomeComponent(user: user) : new LoginSignupScreen(),
        );
      },
    );
  }
}