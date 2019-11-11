import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/generated/i18n.dart';
import 'package:sps/redux/root_state.dart';
import 'package:sps/redux/settings/settings_actions.dart';
import 'package:sps/redux/settings/settings_state.dart';
import 'package:sps/screens/settings.dart';
import 'package:sps/utils/snackbar_helper.dart';

@immutable
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
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

  static _ViewModel fromStore(Store<RootState> store) {
    final SettingsState settings = store.state.settings;
    final bool darkMode = store.state.settings.darkMode;

    Future<void> _switchLocale(BuildContext context, String languageCode, String message) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          message: message,
        ),
        SnackBarContent(
          message: 'Something went wrong!',
        ),
      );
      store.dispatch(ChangeLanguageAction(languageCode: languageCode, completer: completer));
      return completer.future;
    }

    Future<void> _toggleTheme(BuildContext context) {
      if (store.state.view.isLoading) {
        return Future<void>(null);
      }
      final Completer<void> completer = snackBarCompleter(
        context,
        SnackBarContent(
          message: darkMode ? S.of(context).setting_darkMode_switched_off : S.of(context).setting_darkMode_switched_on,
        ),
        SnackBarContent(message: 'Something went wrong!'),
      );
      store.dispatch(ToggleThemeAction(completer: completer));
      return completer.future;
    }

    return _ViewModel(
      toggleTheme: _toggleTheme,
      switchLocale: _switchLocale,
      settings: settings,
    );
  }
}
