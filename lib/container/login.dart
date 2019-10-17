import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/components/login.dart';
import 'package:sps/models/models.dart';

class LoginSignupScreen extends StatelessWidget {
  LoginSignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return LoginSignup(
          onLogin: vm.onLogin,
          onSocialLogin: vm.onSocialLogin,
        );
      },
    );
  }
}

class _ViewModel {
  final Function onLogin;
  final Function onSocialLogin;

  _ViewModel({
    @required this.onLogin,
    @required this.onSocialLogin,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onLogin: () {
        store.dispatch(loadUserAction());
      },
      onSocialLogin: (String type) {
        store.dispatch(socialLogin(type));
      },
    );
  }
}