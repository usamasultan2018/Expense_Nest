// utils/app_theme.dart
import 'package:expense_tracker/utils/appColors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    cardColor: Colors.white, // Set tile color for light theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      iconTheme: IconThemeData(color: AppColors.onSurface),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: Colors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.onSurface,
      onError: AppColors.white,
      error: AppColors.red,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.onSurface),
      bodyMedium: TextStyle(color: AppColors.grey),
      bodySmall: TextStyle(color: AppColors.grey),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xff0c0c0c),
    cardColor: Color(0xff222224), // Set tile color for dark theme
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff0c0c0c),
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.darkGrey,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onError: AppColors.white,
      error: AppColors.red,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.grey),
      bodySmall: TextStyle(color: AppColors.grey),
      // Add more text styles as needed
    ),
  );
}
