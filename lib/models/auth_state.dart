import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sps/constants/constants.dart';

@immutable
class AuthState {
  final FirebaseUser user;
  final AuthStatus status;

  AuthState({
    this.user,
    this.status = AuthStatus.NOT_DETERMINED,
  });

  factory AuthState.initial() {
    return new AuthState(
      user: null,
      status: AuthStatus.NOT_LOGGED_IN,
    );
  }

  AuthState copyWith({
    FirebaseUser user,
    AuthStatus status,
  }) {
    return new AuthState(
      user: user ?? this.user,
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
