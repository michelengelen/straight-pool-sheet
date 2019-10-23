import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/models/settings_state.dart';

final settingsReducer = combineReducers<SettingsState>([
  TypedReducer<SettingsState, ToggleThemeAction>(_toggleTheme),
  TypedReducer<SettingsState, ChangeLanguageAction>(_changeLocale),
]);

SettingsState _toggleTheme(SettingsState state, action) {
  return state.copyWith(darkMode: !state.darkMode);
}

SettingsState _changeLocale(SettingsState state, action) {
  return state.copyWith(locale: action.locale);
}