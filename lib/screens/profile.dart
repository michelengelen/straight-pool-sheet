import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/components/wrapper.dart';
import 'package:sps/constants/images.dart';
import 'package:sps/constants/keys.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/utils/utils.dart';

@immutable
class Profile extends StatefulWidget {
  const Profile({
    @required this.user,
  }) : super(key: Keys.profileScreen);

  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  String _name;
  bool _editName;
  bool _validName;

  String _password;
  String _passwordRepeat;
  bool _editPassword;
  bool _validPassword;
  bool _validPasswordRepeat;

  bool _formSaved;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _editName = false;
    _validName = true;
    _name = widget.user?.displayName ?? '';
    _password = null;
    _passwordRepeat = null;
    _editPassword = false;
    _validPassword = true;
    _validPasswordRepeat = false;
    _formSaved = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
      reverseDuration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(' ### ### ### widget.user: ${widget.user}');
    final String avatarPictureUrl = getProfilePictureUrl(widget.user);

    return StoreConnector<RootState, Store<RootState>>(
      converter: (Store<RootState> store) => store,
      builder: (BuildContext context, Store<RootState> store) {
        return Wrapper(
          title: S.of(context).screen_profile_title,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 96, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: <Widget>[
                                          CircleAvatar(
                                            maxRadius: 40,
                                            backgroundColor: Colors.blue,
                                            backgroundImage: CachedNetworkImageProvider(avatarPictureUrl),
                                          ),
                                          InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).buttonColor,
                                              ),
                                              child: Icon(
                                                Icons.photo_camera,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () => print('##### UPLOAD PHOTO'),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                                              child: TextFormField(
                                                autovalidate: true,
                                                maxLines: 1,
                                                enabled: _editName,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                  disabledBorder: InputBorder.none,
                                                ),
                                                style: Theme.of(context).textTheme.subhead,
                                                initialValue: _name,
                                                validator: (String value) => !_validName ? 'Namen eingeben' : null,
                                                onChanged: (String value) => setState(() {
                                                  _validName = value.trim().isNotEmpty;
                                                }),
                                                onSaved: (String value) => _name = value.trim(),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                              child: Text(
                                                'z3rb3rus@googlemail.com (dummy)',
                                                style: Theme.of(context).textTheme.caption,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _editName = !_editName;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Form(
                        key: _passwordFormKey,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: const Text('Password'),
                              trailing: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                                onTap: () {
                                  if (_editPassword)
                                    _controller.reverse();
                                  else
                                    _controller.forward();
                                  setState(() {
                                    _editPassword = !_editPassword;
                                  });
                                },
                              ),
                            ),
                            TextFormField(
                              autovalidate: true,
                              maxLines: 1,
                              obscureText: true,
                              autofocus: false,
                              enabled: _editPassword,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                suffixStyle: const TextStyle(
                                  inherit: true,
                                ),
                                labelText: S.of(context).login_input_password,
                                helperText: ' ',
                                isDense: true,
                                suffixIcon: _editPassword && _validPassword
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.lock),
                              ),
                              initialValue: 'Please enter a password',
                              // TODO(michel): add proper password rules check
                              validator: (String value) => _formSaved && value.trim().length <= 5
                                  ? S.of(context).login_input_password_error
                                  : null,
                              onChanged: (String value) => setState(() {
                                _password = value.trim();
                                _validPassword = value != null && value.trim().length > 5;
                                _validPasswordRepeat = !_editPassword && value.trim() == _passwordRepeat;
                              }),
                              onSaved: (String value) => _password = value.trim(),
                            ),
                            SizeTransition(
                              sizeFactor: CurvedAnimation(
                                curve: Curves.bounceOut,
                                reverseCurve: Curves.decelerate,
                                parent: _controller,
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    autovalidate: true,
                                    maxLines: 1,
                                    obscureText: true,
                                    autofocus: false,
                                    enabled: _editPassword,
                                    decoration: InputDecoration(
                                      disabledBorder: InputBorder.none,
                                      labelText: S.of(context).login_input_password_check,
                                      suffixIcon: _validPasswordRepeat
                                          ? Icon(Icons.check, color: Colors.green)
                                          : Icon(Icons.compare_arrows),
                                      helperText: ' ',
                                      isDense: true,
                                    ),
                                    validator: (String value) =>
                                        !_editPassword && _formSaved && (value.isEmpty || value.trim() != _password)
                                            ? S.of(context).login_input_password_check_error
                                            : null,
                                    onChanged: (String value) => setState(() {
                                      _validPasswordRepeat = value.trim() == _password;
                                    }),
                                    onSaved: (String value) => _passwordRepeat = value.trim(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
