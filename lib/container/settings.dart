import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/pages/settings.dart';
import 'package:sps/models/models.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Settings(
          toggleTheme: vm.toggleTheme,
        );
      },
    );
  }
}

class _ViewModel {
  final Function toggleTheme;

  _ViewModel({
    @required this.toggleTheme,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      toggleTheme: () {
        store.dispatch(ToggleTheme());
      },
    );
  }
}