import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../languages/app_localizations.dart';
import '../languages/language_service.dart';

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
            icon: const Icon(Icons.language),
            onSelected: (String languageCode) {
              context.read<LanguageService>().changeLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'fr', child: Text('Français')),
              const PopupMenuItem(value: 'de', child: Text('Deutsch')),
              const PopupMenuItem(value: 'it', child: Text('Italiano')),
              const PopupMenuItem(value: 'es', child: Text('Español')),
              const PopupMenuItem(value: 'zh', child: Text('中文')),
              const PopupMenuItem(value: 'ja', child: Text('日本語')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(localizations.translate('start')),
      ),
    );
  }
}