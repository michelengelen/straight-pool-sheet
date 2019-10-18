import 'package:flutter/material.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/models/auth_state.dart';

class DrawerMenuView extends StatelessWidget {
  final Function onLogout;
  final AuthState auth;

  DrawerMenuView({
    this.onLogout,
    this.auth,
  });

  _getInitials(String name) {
    final List parts = name.split(' ');
    String value = 'A';
    if (parts.length >= 2) {
      value = parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
    } else if (parts.length == 0) {
      value = parts[0].substring(0, 1);
    }
    return value;
  }

  _getDrawerHeader() {
    if (auth.status == AuthStatus.LOGGED_IN && auth.user != null) {
      return UserAccountsDrawerHeader(
        accountName: Text(auth.user.displayName),
        accountEmail: Text(auth.user.email),
        currentAccountPicture: auth.user.photoUrl != null ?
          CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: NetworkImage(
              auth.user.photoUrl + "?width=400"
            ),
          ) :
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              _getInitials(auth.user.displayName),
              style: TextStyle(fontSize: 40.0),
            ),
          ),
      );
    }
    return DrawerHeader(
      child: Text('Drawer Header'),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }

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
          _getDrawerHeader(),
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