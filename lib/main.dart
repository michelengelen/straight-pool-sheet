import 'package:flutter/material.dart';
import 'package:sps/services/auth.dart';
import 'package:sps/pages/root.dart';

void main() => runApp(SPS());

class SPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new RootPage(auth: new Auth())
    );
  }
}