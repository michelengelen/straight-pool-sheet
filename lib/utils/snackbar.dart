import 'dart:async';

import 'package:flutter/material.dart';

Completer<void> snackBarCompleter(
  BuildContext context,
  Object message,
  { bool shouldPop = false }
) {
  final Completer<void> completer = Completer<void>();

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }).catchError((Object error) {
    print('#### Error: $error');
  });

  return completer;
}
