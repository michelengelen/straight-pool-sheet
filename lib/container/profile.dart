import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/pages/profile.dart';
import 'package:sps/models/models.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Profile(
          user: vm.user,
          changePassword: vm.changePassword,
          // changeName: vm.changeName,
        );
      },
    );
  }
}

class _ViewModel {
  final FirebaseUser user;
  final Function changePassword;

  _ViewModel({
    @required this.user,
    @required this.changePassword,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.auth.user,
      changePassword: (newPassword) {
        store.dispatch(ChangePasswordAction(newPassword));
      },
    );
  }
}