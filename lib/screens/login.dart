import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
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
    super.initState();
  }

  void resetForm() {
    final FormState form = _formKey.currentState;
    form.reset();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget showSeperator() {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Divider(
                thickness: 3,
                indent: 24,
                endIndent: 12,
              ),
            ),
            Text(S.of(context).login_separator),
            const Expanded(
              child: Divider(
                thickness: 3,
                indent: 12,
                endIndent: 24,
              ),
            ),
          ],
        ),
      );
    }

    Widget showGoogleLoginButton() {
      return RaisedButton(
        onPressed: () {
          widget.onSignInSocial(context, 'G');
        },
        color: Colors.white,
        textColor: const Color.fromRGBO(122, 122, 122, 1),
        child: Text(
          S.of(context).login_button_google,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    }

    Widget showFacebookLoginButton() {
      return RaisedButton(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onPressed: () {
          widget.onSignInSocial(context, 'FB');
        },
        color: const Color.fromRGBO(27, 76, 213, 1),
        textColor: Colors.white,
        child: Text(
          S.of(context).login_button_facebook,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
    }

    Widget showEmailInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: S.of(context).login_input_email,
            prefixIcon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
          validator: (String value) =>
          value.isEmpty ? S.of(context).login_input_email_error : null,
          onSaved: (String value) => _email = value.trim(),
        ),
      );
    }

    Widget showPasswordInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: S.of(context).login_input_password,
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
          validator: (String value) =>
          value.isEmpty ? S.of(context).login_input_password_error : null,
          onSaved: (String value) => _password = value.trim(),
        ),
      );
    }

    Widget showSecondaryButton() {
      return FlatButton(
        child: Text(
          _isLoginForm
            ? S
            .of(context)
            .login_button_create_account
            : S
            .of(context)
            .login_button_has_account,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
    }

    Widget showPrimaryButton() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          child: RaisedButton(
            color: Theme.of(context).buttonColor,
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
        ));
    }

    return StoreConnector<RootState, AuthState>(
      converter: (Store<RootState> store) => store.state.auth,
      builder: (BuildContext context, AuthState auth) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: <Widget>[
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showSeperator(),
              showFacebookLoginButton(),
              showGoogleLoginButton(),
            ],
          ),
        );
      });
  }
}
