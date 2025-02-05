import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:uni/languages/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations Tests', () {
    late AppLocalizations localizations;

    setUp(() async {
      // Test için sahte JSON dosyası içeriği oluştur
      const String testJson = '''
      {
        "welcome": "Welcome",
        "settings": "Settings",
        "uninstallCount": "%d apps uninstalled",
        "failedUninstalls": "Failed to uninstall: %s"
      }
      ''';

      // Sahte asset yükleme mekanizması
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.sublistView(Uint8List.fromList(testJson.codeUnits));
      });

      localizations = AppLocalizations(const Locale('en'));
      await localizations.load();
    });

    test('loads basic translations correctly', () {
      expect(localizations.translate('welcome'), 'Welcome');
      expect(localizations.translate('settings'), 'Settings');
    });

    test('handles numeric placeholders correctly', () {
      final result = localizations.translate('uninstallCount', [5]);
      expect(result, '5 apps uninstalled');
    });

    test('handles string placeholders correctly', () {
      final result = localizations.translate('failedUninstalls', ['App1, App2']);
      expect(result, 'Failed to uninstall: App1, App2');
    });

    test('handles missing translations gracefully', () {
      expect(localizations.translate('nonexistent_key'), 'nonexistent_key');
    });
  });
} 