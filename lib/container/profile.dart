import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/screens/profile.dart';
import 'package:sps/redux/states/models.dart';

@immutable
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
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
  _ViewModel({
    @required this.user,
    @required this.changePassword,
  });

  final FirebaseUser user;
  final Function changePassword;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.auth.user,
      changePassword: (String newPassword) {
        store.dispatch(changePasswordAction(newPassword));
      },
    );
  }
}