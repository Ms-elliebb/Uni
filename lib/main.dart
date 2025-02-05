import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'languages/language_service.dart';
import 'languages/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageService(prefs)),
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
          ],
          localizationsDelegates:const  [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: OnboardingScreen(),
        );
      },
    );
  }
}

