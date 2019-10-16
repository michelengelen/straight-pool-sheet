import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sps/actions/actions.dart';

import 'package:sps/constants/routes.dart';
import 'package:sps/pages/home.dart';
import 'package:sps/models/models.dart';
import 'package:sps/reducers/app_state_reducer.dart';

void main() => runApp(SPS());

class SPS extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware: [thunkMiddleware],
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'APP TITLE',
          theme: ThemeData.dark(),
          routes: {
            Routes.home: (context) {
              return HomeScreen(
                onInit: () {
                  print('######## ON INIT ##########');
                  StoreProvider.of<AppState>(context).dispatch(loadUserAction());
                },
              );
            },
            Routes.profile: (context) {
              return Container(
                child: Center(
                  child: new Text('Profile'),
                ),
              );
            },
          },
        ),
    );
  }
}