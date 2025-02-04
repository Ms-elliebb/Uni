import 'package:flutter/material.dart';

class PremiumService with ChangeNotifier {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  void purchasePremium() {
    _isPremium = true;
    notifyListeners(); // Durum değişikliğini bildir
  }
}