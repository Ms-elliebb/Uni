import 'package:flutter/material.dart';

class AppColors {
  // Ana renkler - daha modern ve profesyonel bir renk paleti
  static const Color primary = Color(0xFF3F51B5);   // Indigo
  static const Color secondary = Color(0xFF5C6BC0); // Daha açık indigo
  static const Color accent = Color(0xFF00BCD4);    // Cyan
  
  // Arka plan renkleri
  static const Color lightBackground = Color(0xFFF8F9FA); // Çok açık gri
  static const Color darkBackground = Color(0xFF263238);  // Koyu mavi-gri
  
  // Metin renkleri
  static const Color lightText = Color(0xFF546E7A);       // Mavi-gri
  static const Color darkText = Color(0xFFECEFF1);        // Çok açık mavi-gri
  
  // Gradient renkleri
  static const Color gradientStart = Color(0xFF3949AB);   // Koyu indigo
  static const Color gradientEnd = Color(0xFF5C6BC0);     // Açık indigo
  
  // Vurgu renkleri
  static const Color success = Color(0xFF4CAF50);         // Yeşil
  static const Color warning = Color(0xFFFFC107);         // Amber
  static const Color error = Color(0xFFF44336);           // Kırmızı
  static const Color danger = Color(0xFFF44336);          // Kırmızı (error ile aynı)
  static const Color info = Color(0xFF2196F3);            // Mavi
} 