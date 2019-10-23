import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/generated/i18n.dart';
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

  _getDrawerHeader(context) {
    final currentRoute = _getCurrentRouteName(context);
    if (auth.status == AuthStatus.LOGGED_IN && auth.user != null) {
      final String queryParam =
          auth.user.providerId.startsWith("facebook") ? "?width=400" : "";
      return UserAccountsDrawerHeader(
        accountName: Text(auth.user.displayName),
        accountEmail: Text(auth.user.email),
        currentAccountPicture: auth.user.photoUrl != null
            ? CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: CachedNetworkImageProvider(auth.user.photoUrl + queryParam),
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
              if (currentRoute == Routes.settings) {
                Navigator.pop(context);
              } else {
                Navigator.popAndPushNamed(context, Routes.settings);
              }
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
          _getDrawerHeader(context),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 24.0,
              semanticLabel: S.of(context).drawer_home,
            ),
            title: Text(S.of(context).drawer_home),
            selected: currentRoute == Routes.home,
            onTap: () {
              if (currentRoute == Routes.home) {
                Navigator.pop(context);
              } else {
                Navigator.popAndPushNamed(context, Routes.home);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin,
              size: 24.0,
              semanticLabel: S.of(context).drawer_profile,
            ),
            title: Text(S.of(context).drawer_profile),
            selected: currentRoute == Routes.profile,
            onTap: () {
              if (currentRoute == Routes.profile) {
                Navigator.pop(context);
              } else {
                Navigator.popAndPushNamed(context, Routes.profile);
              }
            },
          ),
          if (isUserLoggedIn) ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.red,
              size: 24.0,
              semanticLabel: 'Log out the current user',
            ),
            title: new Text(S.of(context).drawer_logout),
            onTap: () {
              if (currentRoute == Routes.home) {
                // use Navigators maybePop method, because it returns a Future
                // If we would use .pop() here the rendering of the Profile Page
                // would run into an error, because the state gets updated beforehand
                Navigator.maybePop(context).then(onLogout);
              } else {
                Navigator.popAndPushNamed(context, Routes.home).then(onLogout);
              }
            },
          ),
        ],
      ),
    );
  }
}
