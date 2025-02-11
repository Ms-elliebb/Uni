import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';


class AppTheme {
  // Sabitler
  static const double _cardBorderRadius = 20.0;
  static const double _buttonBorderRadius = 16.0;
  static const double _defaultElevation = 2.0;

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary.withOpacity(0.9),
        secondary: AppColors.accent,
        secondaryContainer: AppColors.accent.withOpacity(0.9),
        surface: Colors.white,
        background: AppColors.lightBackground,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkBackground,
        onBackground: AppColors.darkBackground,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(_cardBorderRadius),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: _defaultElevation,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          elevation: _defaultElevation,
          shadowColor: AppColors.secondary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: _defaultElevation + 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_buttonBorderRadius),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: AppColors.lightText,
        ),
      ),
    );
  }

  // Uygulamalarda listelerde ikon alanının dekorasyonunu merkezi tanımlıyoruz.
  static BoxDecoration get listIconDecoration => BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      );

  // Arama alanı için özel dekorasyon
  static InputDecoration get searchInputDecoration => InputDecoration(
        hintText: 'Uygulama ara...',
        hintStyle: TextStyle(
          color: AppColors.lightText,
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.primary,
        ),
        suffixIcon: Icon(
          Icons.clear,
          color: AppColors.lightText,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      );

  // Arama Container'ı için dekorasyon
  static BoxDecoration get searchContainerDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
} 