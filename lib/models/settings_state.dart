import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsState {
  final bool darkMode;
  final String language;

  SettingsState({
    this.darkMode,
    this.language,
  });

  factory SettingsState.initial(SharedPreferences settings) {
    return new SettingsState(
      darkMode: settings.getBool('darkMode') ?? false,
      language: settings.getString('language') ?? 'en',
    );
  }

  SettingsState copyWith({
    bool darkMode,
    String language
  }) {
    return new SettingsState(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }

  @override
  int get hashCode => darkMode.hashCode ^ language.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SettingsState &&
              runtimeType == other.runtimeType &&
              darkMode == other.darkMode &&
              language == other.language;

  @override
  String toString() {
    return 'SettingsState: {darkMode: $darkMode, language: $language}';
  }
}
