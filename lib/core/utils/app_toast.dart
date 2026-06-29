import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:toastification/toastification.dart';

abstract class AppToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    required ToastificationType type,
  }) {
    toastification.show(
      context: context,
      type: type,
      title: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      description: Text(
        description,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
      ),
      primaryColor: AppColors.white,
      autoCloseDuration: type == ToastificationType.success
          ? const Duration(seconds: 2)
          : const Duration(seconds: 3),
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? AppColors.primaryLight
            : type == ToastificationType.info
            ? Colors.blue
            : type == ToastificationType.warning
            ? AppColors.yellow
            : AppColors.red,
      ),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? AppColors.primaryLight
          : type == ToastificationType.info
          ? Colors.blue
          : type == ToastificationType.warning
          ? AppColors.yellow
          : AppColors.red,
      foregroundColor: AppColors.primary,
    );
  }
}
