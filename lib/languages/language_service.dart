import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService with ChangeNotifier {
  final SharedPreferences prefs;
  Locale _currentLocale;

  LanguageService(this.prefs) : _currentLocale = const Locale('en') {
    final savedLanguage = prefs.getString('language');
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
    }
  }

  Locale get currentLocale => _currentLocale;

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      await prefs.setString('language', languageCode);
      notifyListeners();
    }
  }
} 