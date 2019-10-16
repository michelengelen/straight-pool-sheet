import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/services/auth.dart';
import 'package:sps/pages/root.dart';
import 'package:sps/models/models.dart';
import 'package:sps/reducers/app_state_reducer.dart';

void main() => runApp(SPS());

class SPS extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          home: new RootPage(auth: new Auth())
      ),
    );
  }
}