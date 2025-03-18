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
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // Onboarding ekranının gösterilip gösterilmeyeceğini kontrol et
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;
  
  // AdMob'u başlat
  final adService = AdService();
  try {
    await adService.initialize();
    // Reklamları görünür hale getir
    adService.setAdsVisibility(true);
  } catch (e) {
    debugPrint('AdMob başlatılırken hata: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageService(prefs)),
        Provider<AdService>.value(value: adService),
        Provider<SharedPreferences>.value(value: prefs),
      ],
      child: MyApp(showOnboarding: showOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  
  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageService>(
      builder: (context, themeProvider, languageService, child) {
        // İlk başlatmada onboarding gösterilecek, sonrakilerde ana sayfa
        final Widget initialScreen = showOnboarding ? OnboardingScreen() : HomeScreen();
        
        return MaterialApp(
          title: 'Uni App',
          debugShowCheckedModeBanner: false,
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
          home: SplashScreen(nextScreen: initialScreen),
        );
      },
    );
  }
}

