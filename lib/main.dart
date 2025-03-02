import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'languages/language_service.dart';
import 'languages/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/theme_provider.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // AdMob'u başlat
  final adService = AdService();
  try {
    await adService.initialize();
  } catch (e) {
    debugPrint('AdMob başlatılırken hata: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageService(prefs)),
        Provider<AdService>.value(value: adService),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageService>(
      builder: (context, themeProvider, languageService, child) {
        return MaterialApp(
          title: 'Uni App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          locale: languageService.currentLocale,
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('de'),
            Locale('it'),
            Locale('es'),
            Locale('zh'),
            Locale('ja'),
            Locale('tr'),
          ],
          localizationsDelegates:const  [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(nextScreen: OnboardingScreen()),
        );
      },
    );
  }
}

