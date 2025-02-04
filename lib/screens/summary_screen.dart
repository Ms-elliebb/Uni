import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final int uninstalledCount;
  final List<String> failedUninstalls;

  SummaryScreen({
    required this.uninstalledCount,
    required this.failedUninstalls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uni App - Özet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$uninstalledCount uygulama kaldırıldı.'),
            if (failedUninstalls.isNotEmpty)
              Text('Kaldırılamayan uygulamalar: ${failedUninstalls.join(', ')}'),
          ],
        ),
      ),
    );
  }
}