import 'package:sps/redux/states/models.dart';
import 'package:sps/redux/reducers/loading_reducer.dart';
import 'package:sps/redux/reducers/auth_reducer.dart';
import 'package:sps/redux/reducers/settings_reducer.dart';

// We create the State reducer by combining many smaller redux.reducers into one!
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    auth: authReducer(state.auth, action),
    settings: settingsReducer(state.settings, action),
  );
}