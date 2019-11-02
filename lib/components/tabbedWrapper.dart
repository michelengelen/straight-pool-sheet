import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/notifier.dart';

import 'package:sps/constants/keys.dart';
import 'package:sps/container/drawer.dart';
import 'package:sps/models/app_state.dart';

@immutable
class TabbedWrapper extends StatelessWidget {
  const TabbedWrapper({
    @required this.title,
    @required this.tabs,
  }) : super(key: Keys.wrapper);

  final String title;
  final List<Map<dynamic, dynamic>> tabs;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: (BuildContext context, bool isLoading) {
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            drawer: const DrawerMenu(),
            appBar: AppBar(
              bottomOpacity: 1,
              bottom: TabBar(
                tabs: isLoading ?
                  <Tab>[
                    const Tab(child: CircularProgressIndicator()),
                  ] : tabs.map<Tab>((Map<dynamic, dynamic> tab) => Tab(icon: tab['icon'])).toList(),
              ),
              title: Text(title),
            ),
            body: Notifier(
              child: TabBarView(
                children: isLoading ?
                <Widget>[
                  Stack(
                    children: <Widget>[
                      ModalBarrier(
                          dismissible: false,
                          color: Colors.black
                      ),
                      Center(
                        child: const CircularProgressIndicator(),
                      ),
                    ],
                  )
                ] : tabs.map<Widget>((Map<dynamic, dynamic> tab) => tab['view']).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}