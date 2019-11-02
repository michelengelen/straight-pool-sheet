import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';

final Reducer<bool> loadingReducer = combineReducers<bool>(<Reducer<bool>>[
  TypedReducer<bool, AppIsLoaded>(_setLoaded),
  TypedReducer<bool, AppIsLoading>(_setLoading),
]);

bool _setLoaded(bool state, AppIsLoaded action) {
  return false;
}

bool _setLoading(bool state, AppIsLoading action) {
  return true;
}