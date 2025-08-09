import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrpace/widgets/custom_typography/typography.dart';

class MrPaceColors {
  // Brand Colors from Logo
  static const Color primaryRed = Color(0xFFE53E3E);        // Dominant red from logo
  static const Color logoGreen = Color(0xFF38A169);         // Green from logo stripes
  static const Color logoYellow = Color(0xFFD69E2E);        // Yellow/gold from logo stripes
  static const Color logoBlack = Color(0xFF1A202C);         // Black from logo
  static const Color logoWhite = Color(0xFFFFFFFF);         // White from logo
  
  // Additional Brand Variations
  static const Color darkRed = Color(0xFFC53030);           // Darker red variant
  static const Color lightRed = Color(0xFFFED7D7);          // Light red for backgrounds
  static const Color darkGreen = Color(0xFF2F855A);         // Darker green variant
  static const Color lightGreen = Color(0xFFC6F6D5);        // Light green for backgrounds
  static const Color darkYellow = Color(0xFFB7791F);        // Darker yellow variant
  static const Color lightYellow = Color(0xFFFAF089);       // Light yellow for backgrounds
  
  // Neutral Colors
  static const Color grey100 = Color(0xFFF7FAFC);
  static const Color grey200 = Color(0xFFEDF2F7);
  static const Color grey300 = Color(0xFFE2E8F0);
  static const Color grey400 = Color(0xFFCBD5E0);
  static const Color grey500 = Color(0xFFA0AEC0);
  static const Color grey600 = Color(0xFF718096);
  static const Color grey700 = Color(0xFF4A5568);
  static const Color grey800 = Color(0xFF2D3748);
  static const Color grey900 = Color(0xFF1A202C);
}

class AppColors {
  static const Color backgroundColor = MrPaceColors.logoWhite;
  static const Color primaryColor = MrPaceColors.primaryRed;
  static const Color secondaryColor = MrPaceColors.logoGreen;
  static const Color accentColor = MrPaceColors.logoYellow;
  static const Color cardColor = MrPaceColors.grey100;
  static const Color textColor = MrPaceColors.logoBlack;
  static const Color subtextColor = MrPaceColors.grey600;
  static const Color borderColor = MrPaceColors.grey300;
  static const Color errorColor = MrPaceColors.darkRed;
  static const Color successColor = MrPaceColors.logoGreen;
  static const Color warningColor = MrPaceColors.logoYellow;
  static const Color surfaceColor = MrPaceColors.logoWhite;
}

class Pallete {
  static ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.accentColor,
      surface: AppColors.surfaceColor,
      background: AppColors.backgroundColor,
      error: AppColors.errorColor,
      onPrimary: MrPaceColors.logoWhite,
      onSecondary: MrPaceColors.logoWhite,
      onSurface: AppColors.textColor,
      onBackground: AppColors.textColor,
      onError: MrPaceColors.logoWhite,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: MrPaceColors.logoWhite,
      iconTheme: const IconThemeData(color: MrPaceColors.logoWhite),
      titleTextStyle: CustomTypography.nunitoTextTheme.titleMedium?.copyWith(
        color: MrPaceColors.logoWhite, 
        fontWeight: FontWeight.bold
      ),
      elevation: 2,
      shadowColor: MrPaceColors.grey300,
    ),
    cardColor: AppColors.cardColor,
   
    textTheme: CustomTypography.nunitoTextTheme.apply(
      bodyColor: AppColors.textColor,
      displayColor: AppColors.textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: MrPaceColors.logoWhite,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
    ),
    dividerColor: AppColors.borderColor,
    iconTheme: IconThemeData(color: AppColors.textColor),
  );
}