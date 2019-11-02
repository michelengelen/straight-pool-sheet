import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

import 'package:sps/constants/keys.dart';
import 'package:sps/models/app_state.dart';
import 'package:sps/models/models.dart';

@immutable
class Notifier extends StatelessWidget {
  const Notifier({
    @required this.child,
  }) : super(key: Keys.notifier);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Future<void> _showSnack(Widget snack) {
      return Future<void>(() async {
        Scaffold.of(context).showSnackBar(snack);
      });
    }

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) => child,
      onWillChange: (_ViewModel vm) {
        if (vm.notification.message.isNotEmpty) {
          print(vm.notification.toString());
          final SnackBar snack = SnackBar(
            duration: Duration(seconds: vm.notification.duration),
            content: Text(vm.notification.message),
            action: SnackBarAction(
              label: 'X',
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
          );
          _showSnack(snack).then<void>(vm.notificationHandled);
        }
      },
      distinct: true,
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.notification,
    @required this.notificationHandled,
  });

  final NotificationState notification;
  final Function notificationHandled;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      notification: store.state.notification,
      notificationHandled: () {
        store.dispatch(NotificationHandledAction());
      },
    );
  }
}