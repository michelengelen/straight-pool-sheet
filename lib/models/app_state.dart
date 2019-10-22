import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sps/models/auth_state.dart';
import 'package:sps/models/settings_state.dart';

@immutable
class AppState {
  final bool isLoading;
  final AuthState auth;
  final SettingsState settings;

  AppState({
    this.isLoading = false,
    this.auth,
    this.settings,
  });

  factory AppState.loading() => AppState(isLoading: true);

  factory AppState.initial(SharedPreferences settings) {
    return new AppState(
      isLoading: true,
      auth: AuthState.initial(),
      settings: SettingsState.initial(settings),
    );
  }

  AppState copyWith({
    bool isLoading,
    AuthState auth,
    SettingsState settings,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      auth: auth ?? this.auth,
      settings: settings ?? this.settings,
    );
  }

  @override
  int get hashCode => isLoading.hashCode ^ auth.hashCode ^ settings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          auth == other.auth &&
          settings == other.settings;

  @override
  String toString() {
    return 'AppState: {isLoading: $isLoading, auth: $auth, settings: $settings}';
  }
}
