import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/components/drawer.dart';
import 'package:sps/redux/states/models.dart';

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
    return StoreConnector<AppState, _ViewModel>(
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

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      logoutUser: (bool success) {
        store.dispatch(logoutUserAction());
      },
      authState: store.state.auth,
    );
  }
}