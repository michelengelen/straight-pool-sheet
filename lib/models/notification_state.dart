import 'package:meta/meta.dart';
import 'package:sps/constants/constants.dart';

@immutable
class NotificationState {
  final String message;
  final NotificationType type;
  final int duration;

  NotificationState({
    this.message,
    this.type,
    this.duration,
  });

  factory NotificationState.initial() {
    return new NotificationState(
      message: '',
      type: NotificationType.INFO,
      duration: 5,
    );
  }

  NotificationState copyWith({
    String message,
    NotificationType type,
    int duration,
  }) {
    return new NotificationState(
      message: message ?? this.message,
      type: type ?? this.type,
      duration: duration ?? this.duration,
    );
  }

  @override
  int get hashCode => message.hashCode ^ type.hashCode ^ duration.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NotificationState &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              type == other.type &&
              duration == other.duration;

  @override
  String toString() {
    return 'NotificationState: {message: $message, type: $type, duration: $duration}';
  }
}
