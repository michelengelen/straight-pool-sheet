import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/redux/actions/actions.dart';
import 'package:sps/redux/states/models.dart';
import 'package:sps/redux/states/settings_state.dart';
import 'package:sps/screens/settings.dart';
import 'package:sps/utils/snackbar.dart';

@immutable
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return Settings(
          toggleTheme: vm.toggleTheme,
          currentSettings: vm.settings,
          switchLocale: vm.switchLocale,
        );
      },
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.settings,
    @required this.toggleTheme,
    @required this.switchLocale,
  });

  final SettingsState settings;
  final Function toggleTheme;
  final Function switchLocale;

  static _ViewModel fromStore(Store<AppState> store) {
    final SettingsState settings = store.state.settings;
    final bool darkMode = settings.darkMode;

    Future<void> _switchLocale(
        BuildContext context, String languageCode, String message) {
      if (store.state.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(context, message);
      store.dispatch(ChangeLanguageAction(
          languageCode: languageCode, completer: completer));
      return completer.future;
    }

    return _ViewModel(
      toggleTheme: () {
        store.dispatch(toggleThemeAction(darkMode));
      },
      switchLocale: _switchLocale,
      settings: settings,
    );
  }
}
