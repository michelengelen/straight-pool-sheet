import 'package:flutter/material.dart';
import 'package:sps/models/auth_state.dart';
import 'package:sps/models/models.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/services/auth.dart';

final Auth auth = new Auth();

class LoginSignup extends StatefulWidget {
  LoginSignup({
    this.onLogin,
    this.onRegister,
    this.onSocialLogin,
  });

  final Function onLogin;
  final Function onRegister;
  final Function onSocialLogin;

  @override
  State<StatefulWidget> createState() => new _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = (await auth.signIn(_email, _password)).uid;
          print('Signed in: $userId');
        } else {
          userId = (await auth.register(_email, _password)).uid;
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });
        storeCurrentUser(userId);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void storeCurrentUser(String userId) {
    if (userId != null && userId.length > 0) {
      auth.getCurrentUser().then((user) {
        widget.onLogin(user);
      });
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AuthState>(
      converter: (Store<AppState> store) {
        return store.state.auth;
      },
      builder: (context, auth) {
        return new Container(
            child: Stack(
              children: <Widget>[
                _showForm(),
                _showCircularProgress(),
              ],
            )
        );
      });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showSeperator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 3,
            indent: 24,
            endIndent: 12,
          ),
        ),
        Text("OR"),
        Expanded(
          child: Divider(
            thickness: 3,
            indent: 12,
            endIndent: 24,
          ),
        ),
      ])
    );
  }

  Widget showGoogleLoginButton() {
    return RaisedButton(
      onPressed: () { widget.onSocialLogin("G"); },
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textColor: Color.fromRGBO(122, 122, 122, 1),
      child: Text(
        "Connect with Google",
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
        onPressed: () { widget.onSocialLogin("FB"); },
        color: Color.fromRGBO(27, 76, 213, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textColor: Colors.white,
        child: Text(
          "Connect with Facebook",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  }

  Widget _showForm() {
    if (_isLoading) return Container(
      width: 0.0,
      height: 0.0,
    );
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
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
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
