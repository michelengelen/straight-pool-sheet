import 'package:sps/redux/auth/auth_reducer.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/settings/settings_reducer.dart';
import 'package:sps/redux/view/view_reducer.dart';

// We create the State reducer by combining many smaller redux.reducers into one!
RootState appReducer(RootState state, dynamic action) {
  return RootState(
    view: viewReducer(state.view, action),
    auth: authReducer(state.auth, action),
    settings: settingsReducer(state.settings, action),
  );
}
