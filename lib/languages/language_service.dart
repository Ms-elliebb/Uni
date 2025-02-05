import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService with ChangeNotifier {
  static const String LANGUAGE_CODE = 'languageCode';
  
  Locale _currentLocale = Locale('en');
  final SharedPreferences _prefs;

  LanguageService(this._prefs) {
    _loadSavedLanguage();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> _loadSavedLanguage() async {
    String? languageCode = _prefs.getString(LANGUAGE_CODE);
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await _prefs.setString(LANGUAGE_CODE, languageCode);
    notifyListeners();
  }
} 