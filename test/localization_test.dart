import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/languages/app_localizations.dart';

void main() {
  group('AppLocalizations Tests', () {
    testWidgets('loads and translates strings correctly', (WidgetTester tester) async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(localizations.translate('welcome'), 'Welcome');
      expect(localizations.translate('settings'), 'Settings');
      expect(
        localizations.translate('uninstallCount', [5]),
        '5 apps uninstalled',
      );
    });

    testWidgets('handles missing translations gracefully', (WidgetTester tester) async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(localizations.translate('nonexistent_key'), 'nonexistent_key');
    });
  });
} 