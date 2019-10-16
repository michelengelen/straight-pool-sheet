import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, AppIsLoaded>(_setLoaded),
  TypedReducer<bool, AppIsLoading>(_setLoading),
]);

bool _setLoaded(bool state, action) {
  return false;
}

bool _setLoading(bool state, action) {
  return true;
}