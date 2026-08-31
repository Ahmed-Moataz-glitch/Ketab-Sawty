import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Tajawal',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.dark,
    fontFamily: 'Tajawal',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}