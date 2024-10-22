import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocale {
  final Locale? locale;

  AppLocale({this.locale});

  Map<String, String>? localizedStrings;

  static AppLocale? of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale);
  }

  Future loadJsonLang() async {
    String langFile =
        await rootBundle.loadString('assets/lang/${locale!.languageCode}.json');
    Map<String, dynamic> loadedValues = jsonDecode(langFile);
    localizedStrings =
        loadedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return localizedStrings![key]!;
  }

  static const LocalizationsDelegate<AppLocale> delegate = _AppLocalDelegate();
}

class _AppLocalDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocalDelegate();
  @override
  bool isSupported(Locale locale) {
    return ["en", "ar", "fr"].contains(locale.languageCode);
  }

  @override
  Future<AppLocale> load(Locale locale) async {
    AppLocale appLocale = AppLocale(locale: locale);
    await appLocale.loadJsonLang();
    return appLocale;
  }

  @override
  bool shouldReload(_AppLocalDelegate old) => false;
}

extension TranslateX on String {
  String tr(BuildContext context) {
    return AppLocale.of(context)!.translate(this);
  }
}
