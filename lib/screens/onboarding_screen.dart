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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.translate('welcome'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Text(localizations.translate('viewApps')),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.translate('selectLanguage')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption(context, 'English', 'en'),
                        _buildLanguageOption(context, 'Français', 'fr'),
                        _buildLanguageOption(context, 'Deutsch', 'de'),
                        _buildLanguageOption(context, 'Italiano', 'it'),
                        _buildLanguageOption(context, 'Español', 'es'),
                        _buildLanguageOption(context, '中文', 'zh'),
                        _buildLanguageOption(context, '日本語', 'ja'),
                      ],
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              icon: const Icon(Icons.language),
              label: Text(
                'Dil Seçiniz',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String label, String code) {
    return ListTile(
      title: Text(label),
      onTap: () {
        context.read<LanguageService>().changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}