import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/models/settings_state.dart';

final settingsReducer = combineReducers<SettingsState>([
  TypedReducer<SettingsState, ToggleTheme>(_toggleTheme),
]);

SettingsState _toggleTheme(SettingsState state, action) {
  return state.copyWith(darkMode: !state.darkMode);
}