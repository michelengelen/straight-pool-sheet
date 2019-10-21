import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sps/constants/keys.dart';
import 'package:sps/container/drawer.dart';
import 'package:sps/models/app_state.dart';

class Wrapper extends StatelessWidget {
  final String title;
  final Widget child;

  Wrapper({
    @required this.title,
    @required this.child,
  }) : super(key: Keys.wrapper);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: (context, isLoading) {
        return new Scaffold(
          drawer: new DrawerMenu(),
          appBar: new AppBar(
            title: new Text(title),
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
              child
          ),
        );
      },
    );
  }
}