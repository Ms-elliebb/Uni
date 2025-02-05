import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/languages/language_service.dart';
import 'package:uni/screens/onboarding_screen.dart';
import 'dart:typed_data';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:uni/languages/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Language Tests', () {
    late SharedPreferences prefs;
    late LanguageService languageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      languageService = LanguageService(prefs);

      // Tek bir mock handler tanımla
      Future<ByteData?> mockHandler(ByteData? message) async {
        if (message != null) {
          final mockData = {
            'appName': 'Uni App',
            'start': 'Start',
            'welcome': 'Welcome',
            'settings': 'Settings',
            'language': 'Language',
            'theme': 'Theme',
            'uninstallCount': '%d apps uninstalled',
            'failedUninstalls': 'Failed to uninstall: %s'
          };
          return ByteData.sublistView(Uint8List.fromList(utf8.encode(json.encode(mockData))));
        }
        return null;
      }

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', mockHandler);
    });

    testWidgets('Shows all supported languages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: languageService),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), Locale('fr'), Locale('de'),
              Locale('it'), Locale('es'), Locale('zh'), Locale('ja'),
            ],
            home: const OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tüm dil seçeneklerini kontrol et
      final languages = ['English', 'Français', 'Deutsch', 'Italiano', 'Español', '中文', '日本語'];
      for (var language in languages) {
        expect(find.text(language), findsOneWidget);
      }
    });

    testWidgets('Changes language when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: languageService),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            locale: const Locale('en'),
            home: Builder(
              builder: (context) {
                // Yükleme durumunu kontrol et
                final localizations = AppLocalizations.of(context);
                if (!localizations.isLoaded) {
                  return const CircularProgressIndicator();
                }
                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(localizations.translate('start')),
                      Text(localizations.translate('welcome')),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Test assertions
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
} 