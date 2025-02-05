import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings = {};  // Boş map ile başlat

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    try {
      final String path = 'lib/languages/translations/assets/lang/${locale.languageCode}.json';
      debugPrint('Dil dosyası yükleniyor: $path');
      
      final jsonString = await rootBundle.loadString(path);
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      
      debugPrint('Dil dosyası başarıyla yüklendi: ${locale.languageCode}');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Dil dosyası yüklenirken hata: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Varsayılan değerler
      _localizedStrings = {
        'start': 'Start',
        'welcome': 'Welcome',
        'settings': 'Settings',
        'language': 'Language',
        'theme': 'Theme',
        'uninstallCount': '%d apps uninstalled',
        'failedUninstalls': 'Failed to uninstall: %s'
      };
      return false;
    }
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

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
    'en', 'fr', 'de', 'it', 'es', 'zh', 'ja'
  ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    try {
      await localizations.load();
      debugPrint('Localization loaded successfully for: ${locale.languageCode}');
    } catch (e) {
      debugPrint('Failed to load localization: $e');
    }
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 