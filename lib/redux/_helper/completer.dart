import 'dart:async';

class CompleterAction {
  CompleterAction({
    this.completer,
  });

  final Completer<void> completer;
}