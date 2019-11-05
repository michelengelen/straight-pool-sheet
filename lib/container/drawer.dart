import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/drawer.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/utils/snackbar_helper.dart';

@immutable
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  String getCurrentRouteName(BuildContext context) {
    String currentRouteName;

    Navigator.popUntil(context, (Route<dynamic> route) {
      currentRouteName = route.settings.name;
      return true;
    });

    return currentRouteName;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return DrawerMenuView(
          onLogout: vm.logoutUser,
          auth: vm.authState,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.logoutUser,
    @required this.authState,
  });

  final Function logoutUser;
  final AuthState authState;

  static _ViewModel fromStore(Store<RootState> store) {
    Future<void> _signOut(BuildContext context, String type) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          message: S
            .of(context)
            .snackbar_user_signout_success,
        ),
        SnackBarContent(
          message: S
            .of(context)
            .snackbar_user_signout_failure,
        ),
      );
      store.dispatch(
        SignOut(context: context, completer: completer),
      );

      return completer.future;
    }

    return _ViewModel(
      logoutUser: _signOut,
      authState: store.state.auth,
    );
  }
}
