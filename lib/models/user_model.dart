import 'package:meta/meta.dart';
// import 'package:sps/models/models.dart';

@immutable
class AppUser {
  final String displayName;
  final String uid;

  AppUser({
    this.displayName = "",
    this.uid = "",
  });

  AppUser copyWith({
    String displayName,
    String uid,
  }) {
    return AppUser(
      displayName: displayName ?? this.displayName,
      uid: uid ?? this.uid,
    );
  }

  @override
  int get hashCode => displayName.hashCode ^ uid.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppUser &&
              runtimeType == other.runtimeType &&
              displayName == other.displayName &&
              uid == other.uid;

  @override
  String toString() {
    return 'AppUser: {displayName: $displayName, uid: $uid}';
  }
}
