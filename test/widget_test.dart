import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/languages/language_service.dart';
import 'package:uni/screens/onboarding_screen.dart';
import 'package:uni/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Language selector shows all supported languages', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageService(prefs)),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('fr'),
            Locale('de'),
            Locale('it'),
            Locale('es'),
            Locale('zh'),
            Locale('ja'),
          ],
          home: OnboardingScreen(),
        ),
      ),
    );

    // Dil seçici menüyü açmak için PopupMenuButton'ı bul
    final languageButton = find.byType(PopupMenuButton<String>);
    expect(languageButton, findsOneWidget);
    
    await tester.tap(languageButton);
    await tester.pumpAndSettle();

    // Dil seçeneklerini kontrol et
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('Italiano'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
  });
} 