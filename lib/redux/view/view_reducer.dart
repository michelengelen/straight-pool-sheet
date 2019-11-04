import 'package:redux/redux.dart';
import 'package:sps/redux/view/view_actions.dart';
import 'package:sps/redux/view/view_state.dart';

final Reducer<ViewState> viewReducer = combineReducers<ViewState>(<Reducer<ViewState>>[
  TypedReducer<ViewState, AppIsLoaded>(_setLoaded),
  TypedReducer<ViewState, AppIsLoading>(_setLoading),
]);

ViewState _setLoaded(ViewState state, AppIsLoaded action) {
  return state.copyWith(isLoading: false);
}

ViewState _setLoading(ViewState state, AppIsLoading action) {
  return state.copyWith(isLoading: true);
}