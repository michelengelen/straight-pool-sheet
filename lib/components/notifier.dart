import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

import 'package:sps/constants/keys.dart';
import 'package:sps/models/app_state.dart';
import 'package:sps/models/models.dart';

class Notifier extends StatelessWidget {
  final Widget child;

  Notifier({
    @required this.child,
  }) : super(key: Keys.wrapper);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) => child,
      onWillChange: (vm) {
        if (vm.notification.message.length > 0) {
          print(vm.notification.toString());
          Scaffold.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: vm.notification.duration),
              content: Text(vm.notification.message),
              action: SnackBarAction(
                label: 'X',
                onPressed: () {
                  Scaffold.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
          vm.notificationHandled();
        }
      },
      distinct: true,
    );
  }
}

class _ViewModel {
  final NotificationState notification;
  final Function notificationHandled;

  _ViewModel({
    @required this.notification,
    @required this.notificationHandled,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      notification: store.state.notification,
      notificationHandled: () {
        store.dispatch(NotificationHandledAction());
      },
    );
  }
}