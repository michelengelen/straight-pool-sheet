import 'package:flutter/material.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/models/auth_state.dart';

class DrawerMenuView extends StatelessWidget {
  final Function onLogout;
  final AuthState auth;

  DrawerMenuView({
    this.onLogout,
    this.auth,
  });

  String _getCurrentRouteName(context) {
    String currentRouteName;

    Navigator.popUntil(context, (route) {
      currentRouteName = route.settings.name;
      return true;
    });

    return currentRouteName;
  }

  _getInitials(String name) {
    final List parts = name.split(' ');
    String value = 'A';
    if (parts.length >= 2) {
      value =
          parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
    } else if (parts.length == 0) {
      value = parts[0].substring(0, 1);
    }
    return value;
  }

  _getDrawerHeader() {
    if (auth.status == AuthStatus.LOGGED_IN && auth.user != null) {
      final String queryParam =
          auth.user.providerId.startsWith("facebook") ? "?width=400" : "";
      return UserAccountsDrawerHeader(
        accountName: Text(auth.user.displayName),
        accountEmail: Text(auth.user.email),
        currentAccountPicture: auth.user.photoUrl != null
            ? CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(auth.user.photoUrl + queryParam),
              )
            : CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  _getInitials(auth.user.displayName),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
        otherAccountsPictures: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              print('Settings');
            },
          ),
        ],
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
    final isUserLoggedIn = auth.status == AuthStatus.LOGGED_IN;
    final currentRoute = _getCurrentRouteName(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          _getDrawerHeader(),
          new ListTile(
            leading: Icon(
              Icons.home,
              size: 24.0,
              semanticLabel: 'Home Screen',
            ),
            title: Text('Home'),
            selected: currentRoute == Routes.home,
            onTap: () {
              print('### tabbed home item');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin,
              size: 24.0,
              semanticLabel: 'Home Screen',
            ),
            title: Text('Profile'),
            selected: currentRoute == Routes.profile,
            onTap: () {
              print('### tabbed profile item');
            },
          ),
          ListTile(
            leading: Icon(
              isUserLoggedIn ? Icons.lock : Icons.lock_open,
              color: isUserLoggedIn ? Colors.red : Theme.of(context).accentColor,
              size: 24.0,
              semanticLabel: 'Log ${isUserLoggedIn ? 'out' : 'in'} the current user',
            ),
            title: Text(isUserLoggedIn ? 'Logout' : 'Login'),
            onTap: () {
              if (isUserLoggedIn) {
                onLogout();
              }
              if (currentRoute != Routes.home){
                Navigator.popAndPushNamed(context, Routes.home);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
