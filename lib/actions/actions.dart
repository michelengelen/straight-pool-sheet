import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sps/services/auth.dart';

final Auth auth = new Auth();

class AppIsLoading {}
class AppIsLoaded {}
class AppErrorAction {}

class ToggleAllAction {}

class LoadTodosAction {}

ThunkAction loadUserAction() {
  return (Store store) async {
    store.dispatch(AppIsLoading());
    new Future(() async {
      auth.getCurrentUser()
        .then((user) {
          print('######### USER: $user');
          store.dispatch(UserLoadedAction(user));
          store.dispatch(AppIsLoaded());
        })
        .catchError((error) {
          print('### ERROR: $error');
        });
    });
  };
}

class UserLoadedAction {
  final FirebaseUser user;

  UserLoadedAction(this.user);

  @override
  String toString() {
    return 'UserLoadedAction{user: $user}';
  }
}

class UserNotLoadedAction {}

/*
class UpdateTodoAction {
  final String id;
  final Todo updatedTodo;

  UpdateTodoAction(this.id, this.updatedTodo);

  @override
  String toString() {
    return 'UpdateTodoAction{id: $id, updatedTodo: $updatedTodo}';
  }
}

class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);

  @override
  String toString() {
    return 'DeleteTodoAction{id: $id}';
  }
}

class AddTodoAction {
  final Todo todo;

  AddTodoAction(this.todo);

  @override
  String toString() {
    return 'AddTodoAction{todo: $todo}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}

*/