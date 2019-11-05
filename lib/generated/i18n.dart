import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static S current;

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL => "There is already another account associated with this email address. Please use the service you used before to log in.";
  String get ERROR_CANCELLED_BY_USER => "The user cancelled the authentication process.";
  String get ERROR_CRITICAL => "A critical error occured. Please try again later";
  String get ERROR_INVALID_CREDENTIAL => "Invalid login credentials provided.";
  String get ERROR_INVALID_EMAIL => "The email address is invalid.";
  String get ERROR_OPERATION_NOT_ALLOWED => "This log in method is not supported. Please use another one.";
  String get ERROR_TOO_MANY_REQUESTS => "There were too many requests. Please wait a bit and try again later.";
  String get ERROR_UNDEFINED => "Something went wrong. Please try again later.";
  String get ERROR_USER_DISABLED => "User is disabled.";
  String get ERROR_USER_NOT_FOUND => "User not found.";
  String get ERROR_WRONG_PASSWORD => "The password is invalid.";
  String get app_title => "Straight Pool Sheet";
  String get icon_home_semantic => "go to Home Screen";
  String get icon_logout_semantic => "Log out the current user";
  String get icon_profile_semantic => "go to User Profile Screen";
  String get icon_settings_semantic => "go to Settings Screen";
  String get locales_de => "German";
  String get locales_en => "English";
  String get logout => "Logout";
  String get screen_home_title => "Home";
  String get screen_profile_title => "Profile";
  String get screen_settings_title => "Settings";
  String get setting_darkMode_subtitle => "Enable dark mode";
  String get setting_darkMode_switched_off => "Dark mode disabled";
  String get setting_darkMode_switched_on => "Dark mode enabled";
  String get setting_darkMode_title => "Dark mode";
  String get setting_language_switched => "Language switched to english";
  String get setting_language_title => "Language";
  String get snackbar_retry => "Retry";
  String get snackbar_user_loaded_failure => "Could not load user";
  String get snackbar_user_loaded_success => "User loaded successfully";
  String setting_language_subtitle(String languageCode) => "Currently selected language: $languageCode";
}

class $de extends S {
  const $de();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get setting_darkMode_switched_off => "Dark mode deaktiviert";
  @override
  String get icon_home_semantic => "Zur Startseite wechseln";
  @override
  String get icon_logout_semantic => "Den aktuellen Nutzer abmelden";
  @override
  String get locales_en => "Englisch";
  @override
  String get ERROR_USER_DISABLED => "Dieser Account wurde deaktiviert. Wenden Sie sich an den Support.";
  @override
  String get snackbar_user_loaded_success => "Nutzer erfolgreich geladen";
  @override
  String get screen_profile_title => "Profil";
  @override
  String get ERROR_WRONG_PASSWORD => "Das Passwort ist ungültig.";
  @override
  String get snackbar_retry => "Wiederholen";
  @override
  String get screen_home_title => "Startseite";
  @override
  String get icon_settings_semantic => "Zur Profilseite wechseln";
  @override
  String get setting_language_title => "Sprache";
  @override
  String get logout => "Abmelden";
  @override
  String get ERROR_CANCELLED_BY_USER => "Abbruch des Anmeldevorgangs durch den Nutzer.";
  @override
  String get setting_darkMode_subtitle => "Dark mode aktivieren";
  @override
  String get snackbar_user_loaded_failure => "Nutzer konnte nicht geladen werden";
  @override
  String get ERROR_INVALID_CREDENTIAL => "Ungültiger Login-Token. Bitte erneut anmelden.";
  @override
  String get ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL => "Es ist bereits ein Account mit dieser E-Mail Adresse verknüpft. Nutzen Sie bitte die korrekte Anmeldemethode.";
  @override
  String get setting_language_switched => "Aktuelle Sprache zu deutsch geändert";
  @override
  String get ERROR_OPERATION_NOT_ALLOWED => "Diese Anmeldemethode wird nicht unterstützt. Nutzen Sie bitte eine der anderen Methoden.";
  @override
  String get app_title => "14/1 Helper";
  @override
  String get ERROR_INVALID_EMAIL => "Die E-Mail Adresse ist ungültig.";
  @override
  String get screen_settings_title => "Einstellungen";
  @override
  String get ERROR_USER_NOT_FOUND => "Account nicht gefunden.";
  @override
  String get setting_darkMode_switched_on => "Dark mode aktiviert";
  @override
  String get ERROR_UNDEFINED => "Operation fehlgeschlagen. Bitte versuchen Sie es erneut.";
  @override
  String get icon_profile_semantic => "Zur Profilseite wechseln";
  @override
  String get locales_de => "Deutsch";
  @override
  String get ERROR_CRITICAL => "Ein kritischer Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.";
  @override
  String get ERROR_TOO_MANY_REQUESTS => "Es wurde zu oft versucht sich mit diesem Account anzumelden. Versuche es später noch einmal.";
  @override
  String get setting_darkMode_title => "Dark mode";
  @override
  String setting_language_subtitle(String languageCode) => "Aktuell ausgewählte Sprache: $languageCode";
}

class $en extends S {
  const $en();
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("de", ""),
      Locale("en", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "de":
          S.current = const $de();
          return SynchronousFuture<S>(S.current);
        case "en":
          S.current = const $en();
          return SynchronousFuture<S>(S.current);
        default:
          // NO-OP.
      }
    }
    S.current = const S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
