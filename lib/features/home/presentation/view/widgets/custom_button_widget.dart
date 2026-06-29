import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final IconData? icon;
  final VoidCallback? onPressed;
  const CustomButtonWidget({
    super.key,
    this.backgroundColor = AppColors.primary,
    required this.title,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null
            ? backgroundColor
            : AppColors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: backgroundColor == AppColors.primary
                ? AppColors.transparent
                : AppColors.primary,
            width: 2.w,
          ),
        ),
      ),
      child: icon == null
          ? Text(
              title,
              style: TextStyle(
                color: backgroundColor == AppColors.primary
                    ? AppColors.white
                    : AppColors.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: backgroundColor == AppColors.primary
                          ? AppColors.white
                          : AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                icon == null
                    ? SizedBox.shrink()
                    : Icon(
                        icon,
                        size: 28.sp,
                        color: backgroundColor == AppColors.primary
                            ? AppColors.white
                            : AppColors.primary,
                      ),
              ],
            ),
    );
  }
}
