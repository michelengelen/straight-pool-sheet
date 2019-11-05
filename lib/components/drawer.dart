import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_state.dart';

@immutable
class DrawerMenuView extends StatelessWidget {
  const DrawerMenuView({
    this.onLogout,
    this.auth,
  });

  final Function(BuildContext context) onLogout;
  final AuthState auth;

  String _getInitials(String name) {
    String value = 'A';
    if (name == null)
      return value;

    final List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      value = parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
    } else if (parts.isEmpty) {
      value = parts[0].substring(0, 1);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {

    String _getCurrentRouteName() {
      String currentRouteName;

      Navigator.popUntil(context, (Route<dynamic> route) {
        currentRouteName = route.settings.name;
        return true;
      });

      return currentRouteName;
    }

    final String currentRoute = _getCurrentRouteName();

    Function() _getNavigation(String route) {
      if (route == currentRoute)
        return () => Navigator.pop(context);
      return () => Navigator.popAndPushNamed(context, route);
    }

    Widget _getDrawerHeader() {
      if (auth.status == AuthStatus.LOGGED_IN && auth.user != null) {
        final String queryParam =
        auth.user.providerData[0].providerId.startsWith('facebook') ? '?width=400' : '';
        return UserAccountsDrawerHeader(
          accountName: Text(auth.user.displayName ?? 'No name is set for the user'),
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
              onPressed: _getNavigation(Routes.settings),
            ),
          ],
        );
      }
      return UserAccountsDrawerHeader(
        accountName: const Text('Welcome to Straight Pool Sheet'),
        accountEmail: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).buttonColor,
              child: Text(S.of(context).login_button_login,
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: _getNavigation(Routes.home),
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
            onPressed: _getNavigation(Routes.settings),
          ),
        ],
      );
    }

    final bool isUserLoggedIn = auth.status == AuthStatus.LOGGED_IN;
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
          if (isUserLoggedIn) ListTile(
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
            title: Text(S.of(context).logout),
            onTap: () {
              if (currentRoute == Routes.home) {
                // use Navigators maybePop method, because it returns a Future
                // If we would use .pop() here the rendering of the Profile Page
                // would run into an error, because the state gets updated beforehand
                Navigator.maybePop(context).then<void>((bool _) => onLogout(context));
              } else {
                Navigator.popAndPushNamed(context, Routes.home).then<void>(onLogout);
              }
            },
          ),
        ],
      ),
    );
  }
}
