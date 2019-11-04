import 'dart:async';

import 'package:sps/redux/_helper/completer.dart';

class ChangeLanguageAction extends CompleterAction {
  ChangeLanguageAction({
    this.languageCode,
    Completer<void> completer,
  }) : super(completer: completer);

  final String languageCode;

  @override
  String toString() {
    return 'ChangeLanguageAction{languageCode: $languageCode}';
  }
}

class ChangeLanguageActionSuccess {
  ChangeLanguageActionSuccess(this.locale);

  final String locale;

  @override
  String toString() {
    return 'ChangeLanguageAction{locale: $locale}';
  }
}

class ToggleThemeAction extends CompleterAction {
  ToggleThemeAction({
    Completer<void> completer,
  }) : super(completer: completer);
}

class ToggleThemeActionSuccess {}
