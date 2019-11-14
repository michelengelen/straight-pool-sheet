import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/constants/images.dart';
import 'package:sps/constants/routes.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/utils/utils.dart';

@immutable
class DrawerMenuView extends StatefulWidget {
  const DrawerMenuView({
    this.onLogout,
    this.auth,
    this.darkMode,
  }) : super();

  final Function(BuildContext context) onLogout;
  final AuthState auth;
  final bool darkMode;

  @override
  State<StatefulWidget> createState() => _DrawerMenuViewState();
}

class _DrawerMenuViewState extends State<DrawerMenuView> {
  String _getInitials(String name) {
    String value = 'A';
    if (name == null) return value;

    final List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      value = parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
    } else if (parts.isEmpty) {
      value = parts[0].substring(0, 1);
    }
    return value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('#### context from drawer: ${context.toString()}');
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
      if (route == currentRoute) return () => Navigator.pop(context);
      return () => Navigator.popAndPushNamed(context, route);
    }

    Widget _getDrawerHeader() {
      if (widget.auth.status == AuthStatus.LOGGED_IN && widget.auth.user != null) {
        print('###### USER from DRAWER!!!!');
        print(widget.auth.user.toString());
        final String avatarPicture = getProfilePictureUrl(widget.auth.user);
        return UserAccountsDrawerHeader(
          accountName: Text(widget.auth.user.displayName ?? 'No name is set for the user'),
          accountEmail: widget.auth.user.email != null ? Text(widget.auth.user.email) : null,
          currentAccountPicture: widget.auth.user.photoUrl != null
              ? CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: CachedNetworkImageProvider(avatarPicture),
                )
              : CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    _getInitials(widget.auth.user.displayName),
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
          otherAccountsPictures: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                semanticLabel: S.of(context).icon_profile_semantic,
              ),
              tooltip: S.of(context).icon_profile_semantic,
              onPressed: _getNavigation(Routes.profile),
            ),
          ],
        );
      }
      return DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: widget.darkMode
                  ? const AssetImage(ImageLinks.drawer_bg_dark)
                  : const AssetImage(ImageLinks.drawer_bg_light),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                S.of(context).welcome_message,
                style: Theme.of(context).textTheme.title,
              ),
              RaisedButton(
                color: Theme.of(context).buttonColor,
                child: Text(S.of(context).login_button_login, style: TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: _getNavigation(Routes.login),
              ),
            ],
          ));
    }

    final bool isUserLoggedIn = widget.auth.status == AuthStatus.LOGGED_IN;
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
              Icons.play_circle_filled,
              size: 24.0,
              semanticLabel: S.of(context).icon_new_game_semantic,
            ),
            title: Text(S.of(context).screen_new_game_title),
            selected: currentRoute == Routes.new_game,
            onTap: _getNavigation(Routes.new_game),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 24.0,
              semanticLabel: S.of(context).icon_settings_semantic,
            ),
            title: Text(S.of(context).screen_settings_title),
            selected: currentRoute == Routes.settings,
            onTap: _getNavigation(Routes.settings),
          ),
          if (isUserLoggedIn)
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
          if (isUserLoggedIn)
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.red,
                size: 24.0,
                semanticLabel: S.of(context).icon_logout_semantic,
              ),
              title: Text(S.of(context).logout),
              onTap: () => widget.onLogout(context),
            ),
        ],
      ),
    );
  }
}
