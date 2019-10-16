import 'package:sps/models/models.dart';
import 'package:sps/reducers/loading_reducer.dart';
import 'package:sps/reducers/auth_reducer.dart';
// import 'package:sps/reducers/tabs_reducer.dart';
// import 'package:sps/reducers/todos_reducer.dart';
// import 'package:sps/reducers/visibility_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    activeUser: authReducer(state.activeUser, action),
    // todos: todosReducer(state.todos, action),
    // activeFilter: visibilityReducer(state.activeFilter, action),
    // activeTab: tabsReducer(state.activeTab, action),
  );
}