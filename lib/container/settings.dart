import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sps/actions/actions.dart';
import 'package:sps/models/settings_state.dart';
import 'package:sps/pages/settings.dart';
import 'package:sps/models/models.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
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
  final SettingsState settings;
  final Function toggleTheme;
  final Function switchLocale;

  _ViewModel({
    @required this.settings,
    @required this.toggleTheme,
    @required this.switchLocale,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final settings = store.state.settings;
    final darkMode = settings.darkMode;
    return _ViewModel(
      toggleTheme: () {
        store.dispatch(toggleThemeAction(darkMode));
      },
      switchLocale: (locale) {
        store.dispatch(ChangeLanguageAction(locale));
      },
      settings: settings,
    );
  }
}