import 'dart:async';

import 'package:flushbar/flushbar.dart';
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

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }

    Flushbar<bool>(
      title: success.message ?? 'SUCCESS',
      message: success.message,
      isDismissible: true,
      duration: Duration(seconds: 4),
      forwardAnimationCurve: Curves.bounceOut,
      reverseAnimationCurve: Curves.decelerate,
      flushbarStyle: FlushbarStyle.GROUNDED,
      leftBarIndicatorColor: Colors.green[900],
    )..show(context);
  }).catchError((dynamic error) {
    Flushbar<bool>(
      title: failure.message ?? 'ERROR',
      message: error.message,
      isDismissible: true,
      duration: Duration(seconds: 4),
      forwardAnimationCurve: Curves.bounceOut,
      reverseAnimationCurve: Curves.decelerate,
      flushbarStyle: FlushbarStyle.GROUNDED,
      leftBarIndicatorColor: Colors.red[900],
    )..show(context);
  });

  return completer;
}
