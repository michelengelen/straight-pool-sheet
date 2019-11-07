import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/redux/settings/settings_state.dart';
import 'package:sps/redux/view/view_state.dart';

@immutable
class RootState {
  const RootState({
    this.view,
    this.auth,
    this.settings,
  });

  factory RootState.initial(SharedPreferences _sprefs) {
    return RootState(
      view: ViewState.initial(),
      auth: AuthState.initial(),
      settings: SettingsState.initial(_sprefs),
    );
  }

  final ViewState view;
  final AuthState auth;
  final SettingsState settings;

  RootState copyWith({
    ViewState view,
    AuthState auth,
    SettingsState settings,
  }) {
    return RootState(
      view: view ?? this.view,
      auth: auth ?? this.auth,
      settings: settings ?? this.settings,
    );
  }

  @override
  int get hashCode => view.hashCode ^ auth.hashCode ^ settings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RootState &&
          runtimeType == other.runtimeType &&
          view == other.view &&
          auth == other.auth &&
          settings == other.settings;

  @override
  String toString() {
    return 'RootState: {view: $view, auth: $auth, settings: $settings}';
  }
}
