import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';

abstract class AppDialogs {
  // Show a loading dialog
  static void showLoadingDialog(BuildContext context, {required String title}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isLightMode = Theme.of(context).brightness == Brightness.light;
        return PopScope(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: isLightMode ? null : AppColors.yellow,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.grey.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isError ? AppColors.red.withAlpha(200) : AppColors.primary,
          ),
        ),
      ),
    );
  }

  static void showbottomSheet(BuildContext context,
      {required Widget child}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return child;
      },
    );
  }
}
