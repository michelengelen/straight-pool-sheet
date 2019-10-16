import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

final authReducer = combineReducers<FirebaseUser>([
  TypedReducer<FirebaseUser, UserLoadedAction>(_setUser),
  TypedReducer<FirebaseUser, UserNotLoadedAction>(_unSetUser),
]);

FirebaseUser _setUser(FirebaseUser state, action) {
  return action.user;
}

FirebaseUser _unSetUser(FirebaseUser state, action) {
  return null;
}