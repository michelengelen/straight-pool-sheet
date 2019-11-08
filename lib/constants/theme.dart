import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    buttonColor: Colors.teal,
  );

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.lightBlue,
    buttonColor: Colors.lightBlue,
  );
}