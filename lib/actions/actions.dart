import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sps/services/auth.dart';

final Auth auth = new Auth();

class AppIsLoading {}
class AppIsLoaded {}

class AppErrorAction {
  final String errorMessage;

  AppErrorAction(this.errorMessage);

  @override
  String toString() {
    return 'AppErrorAction{errorMessage: $errorMessage}';
  }
}

class ToggleAllAction {}

class LoadTodosAction {}

ThunkAction socialLogin(String type) {
  return (Store store) async {
    store.dispatch(AppIsLoading());
    new Future(() async {
      AuthResponse authResponse;
      switch (type) {
        case "FB":
          authResponse = await auth.handleFacebookLogin();
          break;
        case "G":
          authResponse = await auth.handleGoogleLogin();
          break;
        default:
          authResponse = new AuthResponse(
            user: null,
            error: true,
            cancelled: false,
            message: "Something went terribly wrong!",
          );
          break;
      }
      if (authResponse != null && (!authResponse.error || !authResponse.cancelled)) {
        store.dispatch(UserLoadedAction(authResponse.user));
        store.dispatch(AppIsLoaded());
      } else {
        store.dispatch(AppIsLoaded());
        store.dispatch(AppErrorAction(authResponse.message));
      }
    });
  };
}

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
          store.dispatch(UserNotLoadedAction());
          store.dispatch(AppIsLoaded());
          print('### ERROR: $error');
        });
    });
  };
}

ThunkAction logoutUserAction() {
  return (Store store) async {
    store.dispatch(AppIsLoading());
    new Future(() async {
      await auth.logOut();
      store.dispatch(UserNotLoadedAction());
      store.dispatch(AppIsLoaded());
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