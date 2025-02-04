import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/theme/app_theme.dart';
import 'package:uni/utils/premium_service.dart';
import 'screens/onboarding_screen.dart';
import 'utils/theme_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PremiumService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Uni App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: OnboardingScreen(),
    );
  }
}