import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/container/drawer.dart';
import 'package:sps/redux/root_state.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    @required this.title,
    @required this.child,
  }) : super(key: Keys.wrapper);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, bool>(
      converter: (Store<RootState> store) => store.state.view.isLoading,
      builder: (BuildContext context, bool isLoading) {
        return Scaffold(
          drawer: const DrawerMenu(),
          appBar: AppBar(
            title: Text(title),
          ),
          body: Stack(
            children: <Widget>[
              child,
              AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: isLoading
                    ? Stack(
                        children: <Widget>[
                          ModalBarrier(dismissible: false, color: Colors.black),
                          Center(
                            child: const CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
