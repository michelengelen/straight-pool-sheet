import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/components/drawer.dart';
import 'package:sps/models/models.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return DrawerMenuView(
          onLogout: vm.logoutUser,
          auth: vm.authState,
        );
      },
    );
  }
}

class _ViewModel {
  final Function logoutUser;
  final AuthState authState;

  _ViewModel({
    @required this.logoutUser,
    @required this.authState,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      logoutUser: () {
        store.dispatch(logoutUserAction());
      },
      authState: store.state.auth,
    );
  }
}