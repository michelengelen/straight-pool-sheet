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
  SnackBarContent failure, {
  bool shouldPop = false,
  bool dismissable = true,
}) {
  final Completer<void> completer = Completer<void>();
  dynamic action;

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }

    if (success.action is Function) {
      action = SnackBarAction(
        label: success.actionLabel ?? 'X',
        onPressed: success.action,
      );
    } else if (dismissable) {
      action = SnackBarAction(
        label: 'X',
        onPressed: Scaffold.of(context).hideCurrentSnackBar,
      );
    }

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(success.message),
      action: action,
    ));
  }).catchError((dynamic error) {
    if (failure.action is Function) {
      action = SnackBarAction(
        label: failure.actionLabel ?? 'X',
        textColor: Colors.white70,
        onPressed: failure.action,
      );
    } else if (dismissable) {
      action = SnackBarAction(
        label: 'X',
        textColor: Colors.white70,
        onPressed: Scaffold.of(context).hideCurrentSnackBar,
      );
    }

    final String errorMessage = '${failure.message}${error.message.isNotEmpty ? ' - ${error.message}' : ''}';

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
      action: action,
      backgroundColor: Colors.red,
    ));
  });

  return completer;
}
