import 'package:flutter/material.dart';

class DrawerMenuView extends StatelessWidget {
  final Function onLogout;

  DrawerMenuView({
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.red,
              size: 24.0,
              semanticLabel: 'Log out the current user',
            ),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}