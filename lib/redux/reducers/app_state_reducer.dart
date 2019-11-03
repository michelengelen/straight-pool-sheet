import 'package:sps/redux/states/models.dart';
import 'package:sps/redux/reducers/loading_reducer.dart';
import 'package:sps/redux/reducers/auth_reducer.dart';
import 'package:sps/redux/reducers/settings_reducer.dart';
import 'package:sps/redux/reducers/notification_reducer.dart';
// import 'package:sps/redux.reducers/todos_reducer.dart';
// import 'package:sps/redux.reducers/visibility_reducer.dart';

// We create the State reducer by combining many smaller redux.reducers into one!
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    notification: notificationReducer(state.notification, action),
    isLoading: loadingReducer(state.isLoading, action),
    auth: authReducer(state.auth, action),
    settings: settingsReducer(state.settings, action),
  );
}