import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarContent {
  SnackBarContent({
    @required this.message,
    this.action,
    this.actionLabel,
  });

  final String message;
  final Function action;
  final String actionLabel;
}

Completer<void> snackBarCompleter(
  BuildContext context,
  SnackBarContent success,
  SnackBarContent failure,
  {
    bool shouldPop = false,
    bool dismissable = true,
  }
) {
  final Completer<void> completer = Completer<void>();
  dynamic action;

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }

    if (dismissable) {
      action = SnackBarAction(
        label: 'X',
        onPressed: Scaffold.of(context).hideCurrentSnackBar,
      );
    } else if (success.action is Function) {
      action = SnackBarAction(
        label: success.actionLabel ?? 'X',
        onPressed: success.action,
      );
    }

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(success.message),
      action: action,
    ));
  }).catchError((Object error) {
    print('###### Error: $error');
    if (dismissable) {
      action = SnackBarAction(
        label: 'X',
        onPressed: Scaffold.of(context).hideCurrentSnackBar,
      );
    } else if (failure.action is Function) {
      action = SnackBarAction(
        label: failure.actionLabel ?? 'X',
        onPressed: failure.action,
      );
    }

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(failure.message),
      action: action,
      backgroundColor: Colors.red,
    ));
  });

  return completer;
}
