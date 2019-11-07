import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/colors.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/auth/auth_state.dart';
import 'package:sps/redux/root_state.dart';

@immutable
class LoginSignup extends StatefulWidget {
  const LoginSignup({
    this.onSignIn,
    this.onSignUp,
    this.onSignInSocial,
  });

  final Function onSignIn;
  final Function onSignUp;
  final Function onSignInSocial;

  @override
  State<StatefulWidget> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  String _email;
  bool _isEmailValid;
  String _password;

  bool _isLoginForm;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      if (_isLoginForm) {
        await widget.onSignIn(context, _email, _password);
      } else {
        await widget.onSignUp(context, _email, _password);
      }
    }
  }

  @override
  void initState() {
    _isLoginForm = true;
    _isEmailValid = false;
    super.initState();
  }

  void toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  bool isEmailValid(String email) => RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);

  @override
  Widget build(BuildContext context) {
    Widget showSeperator() {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Divider(
                thickness: 2,
                indent: 24,
                endIndent: 12,
              ),
            ),
            Text(S
              .of(context)
              .login_separator),
            const Expanded(
              child: Divider(
                thickness: 2,
                indent: 12,
                endIndent: 24,
              ),
            ),
          ],
        ),
      );
    }

    Widget showGoogleLoginButton() {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: FloatingActionButton(
          mini: true,
          elevation: 0,
          child: Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
          ),
          onPressed: () {
            widget.onSignInSocial(context, 'G');
          },
          backgroundColor: CustomColors.google,
        ),
      );
    }

    Widget showFacebookLoginButton() {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: FloatingActionButton(
          mini: true,
          elevation: 0,
          child: Icon(
            FontAwesomeIcons.facebookF,
            color: Colors.white,
          ),
          onPressed: () {
            widget.onSignInSocial(context, 'FB');
          },
          backgroundColor: CustomColors.facebook,
        ),
      );
    }

    Widget showCreateAccount() {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_isLoginForm
              ? S
              .of(context)
              .login_text_create
              : S
              .of(context)
              .login_text_has_account
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(_isLoginForm
                  ? S
                  .of(context)
                  .login_button_create
                  : S
                  .of(context)
                  .login_button_has_account,
                  style: TextStyle(
                    color: Theme
                      .of(context)
                      .primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: toggleFormMode,
              ),
            ),
          ],
        ),
      );
    }

    Widget showEmailInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            suffixStyle: const TextStyle(
              inherit: true,
            ),
            labelText: S
              .of(context)
              .login_input_email,
            isDense: true,
            suffixIcon: _isEmailValid
              ? Icon(
              Icons.check,
              color: Colors.green)
              : Icon(Icons.email),
          ),
          validator: (String value) =>
          value.isEmpty ? S
            .of(context)
            .login_input_email_error : null,
          onChanged: (String value) {
            bool validEmail;
            if (value != null && isEmailValid(value.trim()))
              validEmail = true;
            else
              validEmail = false;
            setState(() {
              _isEmailValid = validEmail;
            });
          },
          onSaved: (String value) => _email = value.trim(),
        ),
      );
    }

    Widget showPasswordInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: S
              .of(context)
              .login_input_password,
            suffixIcon: Icon(Icons.lock),
            isDense: true,
          ),
          validator: (String value) =>
          value.isEmpty ? S
            .of(context)
            .login_input_password_error : null,
          onSaved: (String value) => _password = value.trim(),
        ),
      );
    }

    Widget showForgotPassword() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
            textColor: Theme
              .of(context)
              .primaryColor,
            child: Text(S
              .of(context)
              .login_forgot_password),
            // TODO(michel): add forgot password screen
            onPressed: () => print('Forgot password pressed!'),
          ),
        ),
      );
    }

    Widget showPrimaryButton() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: RaisedButton(
          elevation: 5,
          color: Theme
            .of(context)
            .primaryColor,
          child: Text(
            _isLoginForm
              ? S
              .of(context)
              .login_button_login
              : S
              .of(context)
              .login_button_create,
            style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      );
    }

    Widget showSocialLogins() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          showFacebookLoginButton(),
          showGoogleLoginButton(),
        ],
      );
    }

    return StoreConnector<RootState, AuthState>(
      converter: (Store<RootState> store) => store.state.auth,
      builder: (BuildContext context, AuthState auth) {
        return Wrapper(
          title: S
            .of(context)
            .screen_login_title,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.table,
                        size: 120.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        showEmailInput(),
                        showPasswordInput(),
                        showForgotPassword(),
                        showPrimaryButton(),
                        showSeperator(),
                        showSocialLogins(),
                        showCreateAccount(),
                      ],
                    )
                  ),
                ],
              ),),
          ),
        );
      });
  }
}
