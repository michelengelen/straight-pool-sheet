import 'package:redux/redux.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/services/auth.dart';

final Auth auth = Auth();

final Reducer<AuthState> authReducer = combineReducers<AuthState>(<Reducer<AuthState>>[
  TypedReducer<AuthState, SetUser>(_setUser),
  TypedReducer<AuthState, UnsetUser>(_unSetUser),
]);

AuthState _setUser(AuthState state, SetUser action) {
  return state.copyWith(user: action.user, status: AuthStatus.LOGGED_IN);
}

AuthState _unSetUser(AuthState state, UnsetUser action) {
  return state.copyWith(user: null, status: AuthStatus.NOT_LOGGED_IN);
}
