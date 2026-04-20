import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight,
    primaryColor: AppColors.primary,
    primaryColorLight: Colors.grey.shade100,
    secondaryHeaderColor: AppColors.secandrydark,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      background: AppColors.bgLight,
      secondary: AppColors.secandrylight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    primaryColor: AppColors.primaryDark,
    primaryColorLight: Color(0xffacd6ff),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      background: AppColors.bgDark,
      secondary: AppColors.secandrydark,
    ),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.textDark)),
  );
}
