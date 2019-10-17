import 'package:redux/redux.dart';

import 'package:sps/actions/actions.dart';
import 'package:sps/models/models.dart';
import 'package:sps/services/auth.dart';
import 'package:sps/constants/constants.dart';

final Auth auth = new Auth();

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, UserLoadedAction>(_setUser),
  TypedReducer<AuthState, UserNotLoadedAction>(_unSetUser),
]);

AuthState _setUser(AuthState state, action) {
  return state.copyWith(user: action.user, status: AuthStatus.LOGGED_IN);
}

AuthState _unSetUser(AuthState state, action) {
  return state.copyWith(user: null, status: AuthStatus.NOT_LOGGED_IN);
}