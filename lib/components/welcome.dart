import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sps/constants/images.dart';

@immutable
class WelcomeComponent extends StatelessWidget {
  const WelcomeComponent({@required this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: const AssetImage(ImageLinks.drawer_bg_dark),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Center(
        child: Text(user == null ? 'NULL - USER' : user.displayName ?? 'NULL'),
      )
    ]);
  }
}
