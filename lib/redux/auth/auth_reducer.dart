import 'package:redux/redux.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/redux/auth/auth_actions.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/services/auth.dart';

final Auth auth = Auth();

final Reducer<AuthState> authReducer =
    combineReducers<AuthState>(<Reducer<AuthState>>[
  TypedReducer<AuthState, LoadUserActionSuccess>(_setUser),
  TypedReducer<AuthState, LoadUserActionFailure>(_unSetUser),
]);

AuthState _setUser(AuthState state, LoadUserActionSuccess action) {
  return state.copyWith(user: action.user, status: AuthStatus.LOGGED_IN);
}

AuthState _unSetUser(AuthState state, LoadUserActionFailure action) {
  return state.copyWith(user: null, status: AuthStatus.NOT_LOGGED_IN);
}