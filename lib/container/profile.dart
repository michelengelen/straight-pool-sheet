import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/screens/profile.dart';

@immutable
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return Profile(
          user: vm.user,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.user,
  });

  final FirebaseUser user;

  static _ViewModel fromStore(Store<RootState> store) {
    return _ViewModel(
      user: store.state.auth.user,
    );
  }
}
