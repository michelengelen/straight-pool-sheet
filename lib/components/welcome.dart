import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class WelcomeComponent extends StatelessWidget {
  const WelcomeComponent({
    @required this.user
  });

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(user.displayName ?? 'NULL - USER'),
    );
  }
}