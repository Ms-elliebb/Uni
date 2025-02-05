import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
        'lib/languages/translations/${locale.languageCode}.json');
    _localizedStrings = json.decode(jsonString);
    return true;
  }

  String translate(String key, [List<dynamic>? args]) {
    String translation = _localizedStrings[key] ?? key;
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        if (translation.contains('%d')) {
          translation = translation.replaceFirst('%d', args[i].toString());
        } else if (translation.contains('%s')) {
          translation = translation.replaceFirst('%s', args[i].toString());
        }
      }
    }
    return translation;
  }
} 