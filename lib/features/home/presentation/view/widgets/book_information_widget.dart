import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';

class BookInformationWidget extends StatelessWidget {
  final String title;
  final String value;
  const BookInformationWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      spacing: 4.h,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.grey, width: 1.w),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
