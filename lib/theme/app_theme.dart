import 'package:flutter/material.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF90CAF9);   // Açık Mavi
  static const Color secondaryColor = Color(0xFFF48FB1); // Pembe
  static const Color accentColor = Color(0xFF80CBC4);    // Deniz Yeşili
  static const Color lightTextColor = Color(0xFF616161); // Açık Gri
  static const Color darkTextColor = Color(0xFF212121);  // Koyu Gri

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.grey[50], // Açık Gri Arka Plan
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Daha Yuvarlak Butonlar
        ),
        elevation: 4,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Daha Yuvarlak Kartlar
      ),
      color: Colors.white,
      shadowColor: primaryColor.withOpacity(0.2),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return Colors.grey;
      }),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: darkTextColor, // Koyu Gri Başlıklar
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: lightTextColor, // Açık Gri Metinler
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primaryColor.withOpacity(0.8),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF2C2C2C),
      shadowColor: primaryColor.withOpacity(0.3),
    ),
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentColor;
        }
        return Colors.grey;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
} 