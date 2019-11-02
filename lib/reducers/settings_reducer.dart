import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/models/settings_state.dart';

final Reducer<SettingsState> settingsReducer = combineReducers<SettingsState>(<Reducer<SettingsState>>[
  TypedReducer<SettingsState, ToggleThemeAction>(_toggleTheme),
  TypedReducer<SettingsState, ChangeLanguageAction>(_changeLocale),
]);

SettingsState _toggleTheme(SettingsState state, ToggleThemeAction action) {
  return state.copyWith(darkMode: !state.darkMode);
}

SettingsState _changeLocale(SettingsState state, ChangeLanguageAction action) {
  return state.copyWith(locale: action.locale);
}