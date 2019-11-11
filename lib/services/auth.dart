import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/utils/auth_helper.dart';

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

final TwitterLogin twitterInstance = TwitterLogin(
  consumerKey: TwitterKeys.apiKey,
  consumerSecret : TwitterKeys.apiSecret,
);

abstract class BaseAuth {
  Future<AuthResponse> signIn(BuildContext context, String email, String password);

  Future<AuthResponse> signUp(BuildContext context, String email, String password);

  Future<void> signOut();

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<AuthResponse> handleGoogleLogin(BuildContext context);

  Future<AuthResponse> handleFacebookLogin(BuildContext context);

  Future<AuthResponse> handleTwitterLogin(BuildContext context);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthResponse generateAuthResponse(BuildContext context, dynamic result) {
    AuthResponse authResponse;
    if (result is AuthResult) {
      authResponse = AuthResponse(user: result.user, error: false, cancelled: false, message: null);
    } else if (result is PlatformException) {
      authResponse =
          AuthResponse(user: null, error: true, cancelled: null, message: getAuthErrorMessage(context, result.code));
    } else {
      authResponse = AuthResponse(
          user: null, error: true, cancelled: false, message: getAuthErrorMessage(context, 'ERROR_UNDEFINED'));
    }
    return authResponse;
  }

  Future<String> checkAuthProvider(String email) async {
    String provider;
    final List<String> providers = await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
    if (providers.isNotEmpty) provider = providers[0];
    return provider;
  }

  @override
  Future<AuthResponse> signIn(BuildContext context, String email, String password) async {
    AuthResponse authResponse;
    try {
      final AuthResult response = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      authResponse = generateAuthResponse(context, response);
    } on PlatformException catch (error) {
      final String provider = await checkAuthProvider(email);
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE' && provider.isNotEmpty) {
        final String providerName = getProviderName(provider);
        authResponse = AuthResponse(
            user: null, error: true, cancelled: false, message: S.of(context).ERROR_WRONG_PROVIDER(providerName));
      } else {
        authResponse = generateAuthResponse(context, error);
      }
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> signUp(BuildContext context, String email, String password) async {
    AuthResponse authResponse;
    try {
      final AuthResult response = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      authResponse = generateAuthResponse(context, response);
    } on PlatformException catch (error) {
      final String provider = await checkAuthProvider(email);
      print('######### ${error.code}');
      print(error.code);
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE' && provider.isNotEmpty) {
        final String providerName = getProviderName(provider);
        authResponse = AuthResponse(
          user: null, error: true, cancelled: false, message: S.of(context).ERROR_WRONG_PROVIDER(providerName));
      } else {
        authResponse = generateAuthResponse(context, error);
      }
    }
    return authResponse;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) throw 'Could not load User!';
    return user;
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
  Future<AuthResponse> handleFacebookLogin(BuildContext context) async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult response = await facebookLogin.logIn(<String>['email']);
    AuthResponse authResponse;
    switch (response.status) {
      case FacebookLoginStatus.loggedIn:
        final String accessToken = response.accessToken.token;
        final AuthCredential facebookAuthCred = FacebookAuthProvider.getCredential(
          accessToken: accessToken,
        );
        try {
          final AuthResult response = await _firebaseAuth.signInWithCredential(facebookAuthCred);
          authResponse = generateAuthResponse(context, response);
        } on PlatformException catch (error) {
          authResponse = generateAuthResponse(context, error);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        authResponse = generateAuthResponse(context, PlatformException(code: 'ERROR_CANCELLED_BY_USER'));
        break;
      case FacebookLoginStatus.error:
      default:
        authResponse = generateAuthResponse(context, PlatformException(code: 'ERROR_UNDEFINED'));
        break;
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> handleGoogleLogin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

    final AuthCredential googleAuthCred = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    AuthResponse authResponse;
    try {
      final AuthResult response = await _firebaseAuth.signInWithCredential(googleAuthCred);
      authResponse = generateAuthResponse(context, response);
    } on PlatformException catch (error) {
      authResponse = generateAuthResponse(context, error);
    }

    return authResponse;
  }

  @override
  Future<AuthResponse> handleTwitterLogin(BuildContext context) async {
    final TwitterLoginResult _twitterLoginResult = await twitterInstance.authorize();
    final TwitterLoginStatus _twitterLoginStatus = _twitterLoginResult.status;

    AuthResponse authResponse;
    switch (_twitterLoginStatus) {
      case TwitterLoginStatus.loggedIn:
        final TwitterSession _currentUserTwitterSession = _twitterLoginResult.session;
        final AuthCredential _twitterAuthCredential = TwitterAuthProvider.getCredential(
          authToken: _currentUserTwitterSession?.token ?? '',
          authTokenSecret: _currentUserTwitterSession?.secret ?? ''
        );

        try {
          final AuthResult response = await _firebaseAuth.signInWithCredential(_twitterAuthCredential);
          authResponse = generateAuthResponse(context, response);
        } on PlatformException catch (error) {
          authResponse = generateAuthResponse(context, error);
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        authResponse = generateAuthResponse(context, PlatformException(code: 'ERROR_CANCELLED_BY_USER'));
        break;
      case TwitterLoginStatus.error:
      default:
        authResponse = generateAuthResponse(context, PlatformException(code: 'ERROR_UNDEFINED'));
        break;
    }

    return authResponse;
  }
}
