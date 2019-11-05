import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
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
  String _errorMessage;

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
    final FormState form = _formKey.currentState;
    setState(() {
      _errorMessage = '';
    });
    if (validateAndSave()) {
      try {
        if (_isLoginForm) {
          await widget.onSignIn(context, _email, _password);
        } else {
          await widget.onSignUp(context, _email, _password);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          form.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    final FormState form = _formKey.currentState;
    form.reset();
    _errorMessage = '';
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, AuthState>(
        converter: (Store<RootState> store) => store.state.auth,
        builder: (BuildContext context, AuthState auth) {
          return Container(
              child: Stack(
                children: <Widget>[
                  _showForm(),
            ],
          ));
    });
  }

  Widget showSeperator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const <Widget>[
          Expanded(
            child: Divider(
              thickness: 3,
              indent: 24,
              endIndent: 12,
            ),
          ),
          Text('OR'),
          Expanded(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textColor: const Color.fromRGBO(122, 122, 122, 1),
      child: Text(
        'Connect with Google',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textColor: Colors.white,
        child: Text(
          'Connect with Facebook',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  }

  Widget _showForm() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showSeperator(),
              showFacebookLoginButton(),
              showGoogleLoginButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.isNotEmpty && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (String value) =>
            value.isEmpty ? 'Email can\'t be empty' : null,
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
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (String value) =>
            value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (String value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
        child: Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(_isLoginForm ? 'Login' : 'Create account',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
