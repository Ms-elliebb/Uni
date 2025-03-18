import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTheme sınıfı, uygulamada kullanılan ortak tema öğelerini içerir.
/// Not: Bu sınıfın büyük kısmı kullanılmıyor, sadece listIconDecoration kullanılıyor.
class AppTheme {
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
} 