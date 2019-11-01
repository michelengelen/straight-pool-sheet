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

  @override
  Widget build(BuildContext context) {

    String _getCurrentRouteName() {
      String currentRouteName;

      Navigator.popUntil(context, (route) {
        currentRouteName = route.settings.name;
        return true;
      });

      return currentRouteName;
    }

    String currentRoute = _getCurrentRouteName();

    Function() _getNavigation(String route) {
      if (route == currentRoute) return () => Navigator.pop(context);
      return () => Navigator.popAndPushNamed(context, route);
    }

    Widget _getDrawerHeader() {
      if (auth.status == AuthStatus.LOGGED_IN && auth.user != null) {
        final String queryParam =
        auth.user.providerData[0].providerId.startsWith("facebook") ? "?width=400" : "";
        return UserAccountsDrawerHeader(
          accountName: Text(auth.user.displayName),
          accountEmail: Text(auth.user.email),
          currentAccountPicture: GestureDetector(
            onTap: _getNavigation(Routes.profile),
            child: auth.user.photoUrl != null
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
          ),
          otherAccountsPictures: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                semanticLabel: S.of(context).icon_settings_semantic,
              ),
              tooltip: S.of(context).icon_settings_semantic,
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
        child: Text('#-# Welcome to SPS #-#'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      );
    }

    final isUserLoggedIn = auth.status == AuthStatus.LOGGED_IN;
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
            leading: Icon(
              Icons.home,
              size: 24.0,
              semanticLabel: S.of(context).icon_home_semantic,
            ),
            title: Text(S.of(context).screen_home_title),
            selected: currentRoute == Routes.home,
            onTap: _getNavigation(Routes.home),
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin,
              size: 24.0,
              semanticLabel: S.of(context).icon_profile_semantic,
            ),
            title: Text(S.of(context).screen_profile_title),
            selected: currentRoute == Routes.profile,
            onTap: _getNavigation(Routes.profile),
          ),
          if (isUserLoggedIn) ListTile(
            leading: Icon(
              Icons.lock,
              color: Colors.red,
              size: 24.0,
              semanticLabel: S.of(context).icon_logout_semantic,
            ),
            title: new Text(S.of(context).logout),
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
