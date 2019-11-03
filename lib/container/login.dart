import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/components/login.dart';
import 'package:sps/redux/states/models.dart';

@immutable
class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
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

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onLogin: () {
        store.dispatch(loadUserAction());
      },
      onRegister: (String email, String password) {
        store.dispatch(registerUserAction(email, password));
      },
      onSocialLogin: (String type) {
        store.dispatch(socialLogin(type));
      },
    );
  }
}