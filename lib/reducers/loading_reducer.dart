import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, UserLoadedAction>(_setLoaded),
  TypedReducer<bool, UserNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}