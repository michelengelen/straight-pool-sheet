import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sps/constants/keys.dart';
import 'package:sps/container/drawer.dart';
import 'package:sps/models/app_state.dart';

class TabbedWrapper extends StatelessWidget {
  final String title;
  final List<Map> tabs;

  TabbedWrapper({
    @required this.title,
    @required this.tabs,
  }) : super(key: Keys.wrapper);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: (context, isLoading) {
        return new DefaultTabController(
          length: tabs.length,
          child: new Scaffold(
            drawer: new DrawerMenu(),
            appBar: new AppBar(
              bottom: TabBar(
                tabs: tabs.map((tab) => tab['icon']).toList(),
              ),
              title: new Text(title),
            ),
            body: TabBarView(
              children: isLoading ?
                [
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
                  )
                ] : tabs.map((tab) => tab['view']).toList(),
            ),
          ),
        );
      },
    );
  }
}