import 'package:redux/redux.dart';

import 'package:sps/redux/actions/actions.dart';
import 'package:sps/constants/constants.dart';
import 'package:sps/redux/states/models.dart';

final Reducer<NotificationState> notificationReducer = combineReducers<NotificationState>(<Reducer<NotificationState>>[
  TypedReducer<NotificationState, NotificationAction>(_setNotification),
  TypedReducer<NotificationState, NotificationHandledAction>(_unsetNotification),
]);

NotificationState _setNotification(NotificationState state, NotificationAction action) {
  return state.copyWith(message: action.message, type: action.type, duration: action.duration);
}

NotificationState _unsetNotification(NotificationState state, NotificationHandledAction action) {
  return state.copyWith(message: '', type: NotificationType.INFO);
}