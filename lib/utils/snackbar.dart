import 'dart:async';

import 'package:flutter/material.dart';

Completer<void> snackBarCompleter(
  BuildContext context,
  Object message, {
  bool shouldPop = false,
  bool dismissable = true,
  Function snackbarAction,
  String snackbarActionContent,
}) {
  final Completer<void> completer = Completer<void>();
  dynamic action;

  if (dismissable) {
    action = SnackBarAction(
      label: 'X',
      onPressed: Scaffold.of(context).hideCurrentSnackBar,
    );
  } else if (snackbarAction is Function) {
    action = SnackBarAction(
      label: snackbarActionContent ?? 'X',
      onPressed: snackbarAction,
    );
  }

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
  }).catchError((Object error) {
    print('#### Error: $error');
  });

  return completer;
}
