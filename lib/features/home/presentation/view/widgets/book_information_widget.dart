import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';

class BookInformationWidget extends StatelessWidget {
  final String title;
  final String value;
  const BookInformationWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    return Column(
      spacing: 4.h,
      crossAxisAlignment: isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp, 
            color: isLightTheme ? AppColors.textSecondary : AppColors.grey,
          ),
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isLightTheme ? AppColors.background : AppColors.white.withAlpha(210),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: isLightTheme ? AppColors.border : AppColors.textSecondary, width: 1.r),
          ),
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              value,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
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
