import 'package:meta/meta.dart';
import 'package:sps/models/auth_state.dart';

@immutable
class AppState {
  final bool isLoading;
  final AuthState auth;

  AppState({
    this.isLoading = false,
    this.auth,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    AuthState auth,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      auth: auth ?? this.auth,
    );
  }

  @override
  int get hashCode => isLoading.hashCode ^ auth.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          auth == other.auth;

  @override
  String toString() {
    return 'AppState: {isLoading: $isLoading, auth: $auth}';
  }
}
