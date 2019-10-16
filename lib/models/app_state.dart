import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final FirebaseUser activeUser;

  AppState({
    this.isLoading = false,
    this.activeUser,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    FirebaseUser activeUser,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      activeUser: activeUser ?? this.activeUser,
    );
  }

  @override
  int get hashCode => isLoading.hashCode ^ activeUser.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          activeUser == other.activeUser;

  @override
  String toString() {
    return 'AppState: {isLoading: $isLoading, activeUser: $activeUser}';
  }
}
