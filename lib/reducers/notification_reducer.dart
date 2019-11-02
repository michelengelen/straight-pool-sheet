import 'package:redux/redux.dart';

import 'package:sps/actions/actions.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/models/models.dart';

final notificationReducer = combineReducers<NotificationState>([
  TypedReducer<NotificationState, NotificationAction>(_setNotification),
  TypedReducer<NotificationState, NotificationHandledAction>(_unsetNotification),
]);

NotificationState _setNotification(NotificationState state, action) {
  return state.copyWith(message: action.message, type: action.type, duration: action.duration);
}

NotificationState _unsetNotification(NotificationState state, action) {
  return state.copyWith(message: '', type: NotificationType.INFO);
}