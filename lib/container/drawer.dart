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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return DrawerMenuView(
          onLogout: vm.signOut,
          auth: vm.auth,
          darkMode: vm.darkMode,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.signOut,
    @required this.auth,
    @required this.darkMode,
  });

  final Function signOut;
  final AuthState auth;
  final bool darkMode;

  static _ViewModel fromStore(Store<RootState> store) {
    Future<void> _signOut(BuildContext context) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          title: S.of(context).SUCCESS,
          message: S.of(context).snackbar_user_signout_success,
        ),
        SnackBarContent(
          title: S.of(context).ERROR,
          message: S.of(context).snackbar_user_signout_failure,
        ),
      );
      store.dispatch(
        SignOut(completer: completer),
      );

      return completer.future;
    }

    return _ViewModel(
      signOut: _signOut,
      auth: store.state.auth,
      darkMode: store.state.settings.darkMode,
    );
  }
}
