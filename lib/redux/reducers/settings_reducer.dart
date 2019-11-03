import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/redux/states/settings_state.dart';

final Reducer<SettingsState> settingsReducer = combineReducers<SettingsState>(<Reducer<SettingsState>>[
  TypedReducer<SettingsState, ToggleThemeAction>(_toggleTheme),
  TypedReducer<SettingsState, ChangeLanguageActionSuccess>(_changeLocale),
]);

SettingsState _toggleTheme(SettingsState state, ToggleThemeAction action) {
  return state.copyWith(darkMode: !state.darkMode);
}

SettingsState _changeLocale(SettingsState state, ChangeLanguageActionSuccess action) {
  return state.copyWith(locale: action.locale);
}