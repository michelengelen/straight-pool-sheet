import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackBarContent {
  SnackBarContent({
    this.title,
    @required this.message,
  });

  final String title;
  final String message;
}

Completer<void> snackBarCompleter(
  BuildContext context,
  SnackBarContent success,
  SnackBarContent failure, {
  bool shouldPop = false,
  bool dismissable = true,
}) {
  final Completer<void> completer = Completer<void>();
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  completer.future.then((_) {
    if (shouldPop) {
      Navigator.of(context).pop();
    }

    Flushbar<bool>(
      titleText: success.title != null ? Text(
        success.title.toUpperCase(),
        style: Theme.of(context).textTheme.headline
      ) : null,
      messageText: Text(
        success.message,
        style: Theme.of(context).textTheme.body2
      ),
      icon: Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      ),
      isDismissible: true,
      duration: Duration(seconds: 6),
      forwardAnimationCurve: Curves.easeOutQuint,
      reverseAnimationCurve: Curves.decelerate,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
    )..show(context);
  }).catchError((dynamic error) {
    Flushbar<bool>(
      titleText: failure.title != null ? Text(
        failure.title.toUpperCase(),
        style: Theme.of(context).textTheme.headline
      ) : null,
      messageText: Text(
        failure.message,
        style: Theme.of(context).textTheme.body2
      ),
      icon: Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
      isDismissible: true,
      duration: Duration(seconds: 6),
      forwardAnimationCurve: Curves.easeOutQuint,
      reverseAnimationCurve: Curves.decelerate,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
    )..show(context);
  });

  return completer;
}
