import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/screens/login.dart';
import 'package:sps/utils/snackbar_helper.dart';

@immutable
class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return LoginSignup(
          onSignIn: vm.onSignIn,
          onSignUp: vm.onSignUp,
          onSignInSocial: vm.onSignInSocial,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onSignIn,
    @required this.onSignUp,
    @required this.onSignInSocial,
  });

  final Function onSignIn;
  final Function onSignUp;
  final Function onSignInSocial;

  static _ViewModel fromStore(Store<RootState> store) {
    Completer<void> getStandardCompleter(BuildContext context) {
      return snackBarCompleter(
        context,
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_success,
        ),
        SnackBarContent(
          message: S.of(context).snackbar_user_loaded_failure,
        ),
      );
    }

    Future<void> _signIn(BuildContext context, String email, String password) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = getStandardCompleter(context);
      store.dispatch(
        SignIn(context: context, email: email, password: password, completer: completer),
      );

      return completer.future;
    }

    Future<void> _signUp(BuildContext context, String email, String password) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = getStandardCompleter(context);
      store.dispatch(
        SignUp(context: context, email: email, password: password, completer: completer),
      );

      return completer.future;
    }

    Future<void> _signInSocial(BuildContext context, String type) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = getStandardCompleter(context);
      store.dispatch(
        SignInSocial(context: context, type: type, completer: completer),
      );

      return completer.future;
    }

    return _ViewModel(
      onSignIn: _signIn,
      onSignUp: _signUp,
      onSignInSocial: _signInSocial,
    );
  }
}
