import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sps/constants/constants.dart';

@immutable
class AuthState {
  const AuthState({
    this.user,
    this.status = AuthStatus.NOT_DETERMINED,
  });

  factory AuthState.initial() {
    return const AuthState(
      user: null,
      status: AuthStatus.NOT_LOGGED_IN,
    );
  }

  final FirebaseUser user;
  final AuthStatus status;

  AuthState copyWith({
    FirebaseUser user,
    AuthStatus status,
  }) {
    return AuthState(
      user: user,
      status: status ?? this.status,
    );
  }

  @override
  int get hashCode => user.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AuthState &&
              runtimeType == other.runtimeType &&
              user == other.user;

  @override
  String toString() {
    return 'AuthState: {user: $user, status: $status}';
  }
}
