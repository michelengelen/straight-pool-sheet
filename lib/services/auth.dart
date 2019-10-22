import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthResponse {
  final FirebaseUser user;
  final bool error;
  final bool cancelled;
  final String message;

  AuthResponse({
    @required this.user,
    @required this.error,
    @required this.cancelled,
    @required this.message,
  });

  @override
  String toString() {
    return "AuthResponse{FirebaseUser user: $user, error: $error, cancelled: $cancelled, message: $message}";
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

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> register(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) throw('Could not load User!');
    return user;
  }

  Future<void> logOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<AuthResponse> handleFacebookLogin() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult response = await facebookLogin.logIn(['email']);
    switch (response.status) {
      case FacebookLoginStatus.loggedIn:
        final accessToken = response.accessToken.token;
        final facebookAuthCred = FacebookAuthProvider.getCredential(
          accessToken: accessToken,
        );
        final user = (await _firebaseAuth.signInWithCredential(facebookAuthCred)).user;
        final AuthResponse authResponse = new AuthResponse(
            user: user,
            error: false,
            cancelled: false,
            message: null,
        );
        return authResponse;
        break;
      case FacebookLoginStatus.cancelledByUser:
        final AuthResponse authResponse = new AuthResponse(
          user: null,
          error: false,
          cancelled: true,
          message: "Cancelled by User",
        );
        return authResponse;
        break;
      case FacebookLoginStatus.error:
        final AuthResponse authResponse = new AuthResponse(
          user: null,
          error: true,
          cancelled: false,
          message: "Something went wrong. Try again!",
        );
        return authResponse;
        break;
      default:
        return null;
    }
  }

  Future<AuthResponse> handleGoogleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]
    );
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    print(googleSignInAccount.toString());
    final googleAuth = await googleSignInAccount.authentication;
    final AuthCredential googleAuthCred = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
    );
    final response = await _firebaseAuth.signInWithCredential(googleAuthCred);
    print('response!!!!!!!');
    print(response.toString());
    final AuthResponse authResponse = new AuthResponse(
      user: response.user,
      error: false,
      cancelled: false,
      message: null,
    );
    return authResponse;
  }
}