import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};
  bool _isLoaded = false;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isLoaded => _isLoaded;

  Future<bool> load() async {
    if (_isLoaded) return true;

    try {
      final String path = 'lib/languages/translations/assets/lang/${locale.languageCode}.json';
      final jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      _isLoaded = true;
      return true;
    } catch (e) {
      debugPrint('Dil dosyası yükleme hatası: $e');
      _localizedStrings = {
        'error': 'Dil dosyası yüklenemedi',
        'appName': 'Uni App',
      };
      return false;
    }
  }

  String translate(String key, [List<dynamic>? args]) {
    final translation = _localizedStrings[key] ?? key;
    if (args == null || args.isEmpty) return translation;

    return _formatTranslation(translation, args);
  }

  String _formatTranslation(String translation, List<dynamic> args) {
    var result = translation;
    for (var arg in args) {
      if (result.contains('%d')) {
        result = result.replaceFirst('%d', arg.toString());
      } else if (result.contains('%s')) {
        result = result.replaceFirst('%s', arg.toString());
      }
    }
    return result;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  static final Map<String, AppLocalizations> _cache = {};
  static final Set<String> _loadingLocales = {};

  @override
  bool isSupported(Locale locale) => [
    'en', 'fr', 'de', 'it', 'es', 'zh', 'ja', 'tr'
  ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final String cacheKey = locale.languageCode;
    
    debugPrint('🌍 Dil yükleme isteği: $cacheKey');
    
    // Eğer önbellekte varsa ve yüklenmişse, direkt dön
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.isLoaded) {
      debugPrint('✅ Dil önbellekten yüklendi: $cacheKey');
      return _cache[cacheKey]!;
    }

    // Eğer bu dil şu anda yükleniyorsa, yükleme işleminin bitmesini bekle
    if (_loadingLocales.contains(cacheKey)) {
      debugPrint('⏳ Dil yükleniyor, bekleniyor: $cacheKey');
      while (_loadingLocales.contains(cacheKey)) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (_cache.containsKey(cacheKey)) {
        debugPrint('✅ Bekleyen dil yüklendi: $cacheKey');
        return _cache[cacheKey]!;
      }
    }

    // Yükleme işlemini başlat
    debugPrint('📥 Yeni dil yükleniyor: $cacheKey');
    _loadingLocales.add(cacheKey);
    
    try {
      final localizations = AppLocalizations(locale);
      final success = await localizations.load();
      
      if (success) {
        _cache[cacheKey] = localizations;
        debugPrint('✅ Dil başarıyla yüklendi ve önbelleğe alındı: $cacheKey');
      } else {
        debugPrint('❌ Dil yükleme başarısız: $cacheKey');
      }
      
      return localizations;
    } catch (e) {
      debugPrint('❌ Dil yükleme hatası: $cacheKey - $e');
      rethrow;
    } finally {
      _loadingLocales.remove(cacheKey);
      debugPrint('🔄 Yükleme durumu güncellendi: $_loadingLocales');
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
} 
