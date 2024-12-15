import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white),
        bodySmall: TextStyle(color: AppColors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        background: AppColors.background,
        onBackground: AppColors.white,
      ),
    );
  }
}
