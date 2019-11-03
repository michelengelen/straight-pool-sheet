import 'package:flutter/widgets.dart';

class Keys {
  // Wrapper
  static const Key wrapper = Key('__wrapper__');
  static const Key tabbedWrapper = Key('__tabbedWrapper__');

  // Home Screens
  static const Key homeScreen = Key('__homeScreen__');
  static const Key profileScreen = Key('__profileScreen__');
  static const Key settingsScreen = Key('__settingsScreen__');
  static const Key snackbar = Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Tabs
  static const Key tabs = Key('__tabs__');
  static const Key todoTab = Key('__todoTab__');
  static const Key statsTab = Key('__statsTab__');

  // Extra Actions
  static const Key extraActionsButton = Key('__extraActionsButton__');
  static const Key toggleAll = Key('__markAllDone__');
  static const Key clearCompleted = Key('__clearCompleted__');

  // Filters
  static const Key filterButton = Key('__filterButton__');
  static const Key allFilter = Key('__allFilter__');
  static const Key activeFilter = Key('__activeFilter__');
  static const Key completedFilter = Key('__completedFilter__');

  // Stats
  static const Key statsCounter = Key('__statsCounter__');
  static const Key statsLoading = Key('__statsLoading__');
  static const Key statsNumActive = Key('__statsActiveItems__');
  static const Key statsNumCompleted = Key('__statsCompletedItems__');

  // Details Screen
  static const Key editTodoFab = Key('__editTodoFab__');
  static const Key deleteTodoButton = Key('__deleteTodoFab__');
  static const Key todoDetailsScreen = Key('__todoDetailsScreen__');
  static const Key detailsTodoItemCheckbox = Key('DetailsTodo__Checkbox');
  static const Key detailsTodoItemTask = Key('DetailsTodo__Task');
  static const Key detailsTodoItemNote = Key('DetailsTodo__Note');

  // Add Screen
  static const Key addTodoScreen = Key('__addTodoScreen__');
  static const Key saveNewTodo = Key('__saveNewTodo__');
  static const Key taskField = Key('__taskField__');
  static const Key noteField = Key('__noteField__');

  // Edit Screen
  static const Key editTodoScreen = Key('__editTodoScreen__');
  static const Key saveTodoFab = Key('__saveTodoFab__');
}