import 'package:redux/redux.dart';
import 'package:sps/redux/settings/settings_actions.dart';
import 'package:sps/redux/settings/settings_state.dart';

final Reducer<SettingsState> settingsReducer =
    combineReducers<SettingsState>(<Reducer<SettingsState>>[
  TypedReducer<SettingsState, ToggleThemeActionSuccess>(_toggleTheme),
  TypedReducer<SettingsState, ChangeLanguageActionSuccess>(_changeLocale),
]);

SettingsState _toggleTheme(
    SettingsState state, ToggleThemeActionSuccess action) {
  return state.copyWith(darkMode: !state.darkMode);
}

SettingsState _changeLocale(
    SettingsState state, ChangeLanguageActionSuccess action) {
  return state.copyWith(locale: action.locale);
}
