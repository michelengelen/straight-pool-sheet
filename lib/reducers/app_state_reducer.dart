import 'package:sps/models/models.dart';
import 'package:sps/reducers/loading_reducer.dart';
import 'package:sps/reducers/auth_reducer.dart';
import 'package:sps/reducers/settings_reducer.dart';
import 'package:sps/reducers/notification_reducer.dart';
// import 'package:sps/reducers/todos_reducer.dart';
// import 'package:sps/reducers/visibility_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    notification: notificationReducer(state.notification, action),
    isLoading: loadingReducer(state.isLoading, action),
    auth: authReducer(state.auth, action),
    settings: settingsReducer(state.settings, action),
  );
}