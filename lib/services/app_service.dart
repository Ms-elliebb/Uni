import 'package:flutter/services.dart';
import 'package:uni/models/app_model.dart';

import 'dart:io' show Platform;


class AppService {
  static const platform = MethodChannel('uni_app/channel');

  Future<List<AppModel>> getInstalledApps() async {
    if (Platform.isAndroid) {
      try {
        final List<dynamic> apps = await platform.invokeMethod('getInstalledApps');
        return apps.map((app) {
          return AppModel(
            name: app['name'],
            iconPath: app['iconPath'],
            size: app['size'],
            lastUsed: DateTime.parse(app['lastUsed']),
            packageName: app['packageName'],
          );
        }).toList();
      } on PlatformException catch (e) {
        print("Failed to get installed apps: ${e.message}");
        return [];
      }
    }
    return []; // iOS veya diğer platformlar için boş liste dön
  }

  Future<void> uninstallApp(String packageName) async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('uninstallApp', {'packageName': packageName});
      } on PlatformException catch (e) {
        print("Failed to uninstall app: ${e.message}");
        throw e;
      }
    }
  }
}