import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        buttonColor: Colors.teal,
        textTheme: TextTheme(
          body2: TextStyle(
            color: Colors.grey[500]
          ),
        ),
      );

  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightBlue,
        buttonColor: Colors.lightBlue,
        textTheme: TextTheme(
          body2: TextStyle(
            color: Colors.grey[500]
          ),
        ),
      );
}
