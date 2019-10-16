import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/models/models.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, UserLoadedAction>(_setUser),
  TypedReducer<AuthState, UserNotLoadedAction>(_unSetUser),
]);

AuthState _setUser(AuthState state, action) {
  return action.user;
}

AuthState _unSetUser(AuthState state, action) {
  return null;
}