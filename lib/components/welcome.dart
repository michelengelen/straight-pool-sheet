import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeComponent extends StatelessWidget {
  final FirebaseUser user;

  WelcomeComponent({
    @required this.user
  });

  @override
  build(BuildContext context) {
    return Center(
      child: new Text(user.displayName),
    );
  }
}