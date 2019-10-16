import 'package:firebase_auth/firebase_auth.dart';

class ClearCompletedAction {}

class ToggleAllAction {}

class LoadTodosAction {}

class UserNotLoadedAction {}

class UserLoadedAction {
  final FirebaseUser user;

  UserLoadedAction(this.user);

  @override
  String toString() {
    return 'TodosLoadedAction{user: $user}';
  }
}

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