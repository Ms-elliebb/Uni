import 'package:flutter/material.dart';
import '../languages/app_localizations.dart';

class SummaryScreen extends StatelessWidget {
  final int uninstalledCount;
  final List<String> failedUninstalls;

  const SummaryScreen({
    required this.uninstalledCount,
    required this.failedUninstalls,
  });

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
              localizations.translate('uninstallCount', [uninstalledCount]),
            ),
            if (failedUninstalls.isNotEmpty)
              Text(
                localizations.translate('failedUninstalls', [failedUninstalls.join(', ')]),
              ),
          ],
        ),
      ),
    );
  }
}