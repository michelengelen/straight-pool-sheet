import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/login.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/utils/snackbar.dart';

@immutable
class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return LoginSignup(
          onLogin: vm.onLogin,
          onRegister: vm.onRegister,
          onSocialLogin: vm.onSocialLogin,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onLogin,
    @required this.onRegister,
    @required this.onSocialLogin,
  });

  final Function onLogin;
  final Function onRegister;
  final Function onSocialLogin;

  static _ViewModel fromStore(Store<RootState> store) {
    Future<void> _loadUser(BuildContext context) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_success,
        ),
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_failure,
          action: () => store.dispatch(LoadUserAction()),
          actionLabel: S.of(context).snackbar_retry,
        ),
      );
      store.dispatch(
        LoadUserAction(completer: completer),
      );

      return completer.future;
    }

    Future<void> _signInUserSocial(BuildContext context, String type) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_success,
        ),
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_failure,
        ),
      );
      store.dispatch(
        SignInUserSocial(type: type, completer: completer),
      );

      return completer.future;
    }

    return _ViewModel(
      onLogin: _loadUser,
      onRegister: (String email, String password) {
        store.dispatch(registerUserAction(email, password));
      },
      onSocialLogin: _signInUserSocial,
    );
  }
}
