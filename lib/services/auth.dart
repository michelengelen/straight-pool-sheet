import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

@immutable
class AuthResponse {
  const AuthResponse({
    @required this.user,
    @required this.error,
    @required this.cancelled,
    @required this.message,
  });

  final FirebaseUser user;
  final bool error;
  final bool cancelled;
  final String message;

  @override
  String toString() {
    return 'AuthResponse{FirebaseUser user: $user, error: $error, cancelled: $cancelled, message: $message}';
  }
}

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> register(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> logOut();

  Future<bool> isEmailVerified();

  Future<AuthResponse> handleGoogleLogin();

  Future<AuthResponse> handleFacebookLogin();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    return user;
  }

  @override
  Future<FirebaseUser> register(String email, String password) async {
    final AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    return user;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    print('auth');
    final FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null)
      throw 'Could not load User!';
    return user;
  }

  @override
  Future<void> logOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<AuthResponse> handleFacebookLogin() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult response = await facebookLogin.logIn(<String>['email']);
    switch (response.status) {
      case FacebookLoginStatus.loggedIn:
        final String accessToken = response.accessToken.token;
        final AuthCredential facebookAuthCred = FacebookAuthProvider.getCredential(
          accessToken: accessToken,
        );
        final FirebaseUser user = (await _firebaseAuth.signInWithCredential(facebookAuthCred)).user;
        final AuthResponse authResponse = AuthResponse(
            user: user,
            error: false,
            cancelled: false,
            message: null,
        );
        return authResponse;
        break;
      case FacebookLoginStatus.cancelledByUser:
        const AuthResponse authResponse = AuthResponse(
          user: null,
          error: false,
          cancelled: true,
          message: 'Cancelled by User',
        );
        return authResponse;
        break;
      case FacebookLoginStatus.error:
        const AuthResponse authResponse = AuthResponse(
          user: null,
          error: true,
          cancelled: false,
          message: 'Something went wrong. Try again!',
        );
        return authResponse;
        break;
      default:
        return null;
    }
  }

  @override
  Future<AuthResponse> handleGoogleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]
    );
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
    final AuthCredential googleAuthCred = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
    );
    final AuthResult response = await _firebaseAuth.signInWithCredential(googleAuthCred);
    final AuthResponse authResponse = AuthResponse(
      user: response.user,
      error: false,
      cancelled: false,
      message: null,
    );
    return authResponse;
  }
}