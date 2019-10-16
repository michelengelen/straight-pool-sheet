import 'package:flutter/material.dart';
import 'package:sps/constants/keys.dart';

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
    );
  }
}