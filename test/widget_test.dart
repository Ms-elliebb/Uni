import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/languages/language_service.dart';
import 'package:uni/screens/onboarding_screen.dart';
import 'package:uni/main.dart';
import 'dart:typed_data';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Language Tests', () {
    late SharedPreferences prefs;
    late LanguageService languageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      languageService = LanguageService(prefs);
    });

    testWidgets('Shows all supported languages', (WidgetTester tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.sublistView(Uint8List.fromList('{"appName":"Uni App","start":"Start"}'.codeUnits));
      });

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: languageService),
          ],
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
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
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message.toString().contains('fr.json')) {
          return ByteData.sublistView(Uint8List.fromList(
              '{"appName":"Uni App","start":"Commencer"}'.codeUnits));
        }
        return ByteData.sublistView(Uint8List.fromList(
            '{"appName":"Uni App","start":"Start"}'.codeUnits));
      });

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: languageService),
          ],
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('fr')],
            locale: languageService.currentLocale,
            home: const OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Start'), findsOneWidget);
      
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Français'));
      await tester.pumpAndSettle();
      
      // Dil değişikliği sonrası yeni widget ağacının oluşmasını bekle
      await Future.delayed(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      
      expect(find.text('Commencer'), findsOneWidget);
    });
  });
} 