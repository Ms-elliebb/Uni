import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../languages/app_localizations.dart';
import '../languages/language_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('appName')),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: (String languageCode) {
              context.read<LanguageService>().changeLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'fr', child: Text('Français')),
              PopupMenuItem(value: 'de', child: Text('Deutsch')),
              PopupMenuItem(value: 'it', child: Text('Italiano')),
              PopupMenuItem(value: 'es', child: Text('Español')),
              PopupMenuItem(value: 'zh', child: Text('中文')),
              PopupMenuItem(value: 'ja', child: Text('日本語')),
            ],
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: Text(localizations.translate('start')),
        ),
      ),
    );
  }
}