import 'dart:async';

import 'package:flutter/material.dart';

Completer<void> snackBarCompleter(
  BuildContext context,
  String message,
  { bool shouldPop = false }
) {
  final Completer<void> completer = Completer<void>();

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }).catchError((Object error) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return Text(error);
        });
  });

  return completer;
}
