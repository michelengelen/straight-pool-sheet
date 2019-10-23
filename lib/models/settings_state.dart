import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsState {
  final bool darkMode;
  final String locale;

  SettingsState({
    this.darkMode,
    this.locale,
  });

  factory SettingsState.initial(SharedPreferences settings) {
    return new SettingsState(
      darkMode: settings.getBool('darkMode') ?? false,
      locale: settings.getString('languageCode') ?? 'de',
    );
  }

  SettingsState copyWith({
    bool darkMode,
    String locale
  }) {
    return new SettingsState(
      darkMode: darkMode ?? this.darkMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  int get hashCode => darkMode.hashCode ^ locale.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SettingsState &&
              runtimeType == other.runtimeType &&
              darkMode == other.darkMode &&
              locale == other.locale;

  @override
  String toString() {
    return 'SettingsState: {darkMode: $darkMode, locale: $locale}';
  }
}
