import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_assets.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).about_app_page_app_bar,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Center(
            child: Column(
              spacing: 48.h,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12.r),
                  child: Image.asset(
                    AppAssets.logoImage,
                    colorBlendMode: isLightTheme ? BlendMode.colorBurn : BlendMode.multiply,
                    width: 200.w,
                    height: 200.h,
                  ),
                ),
                Text(
                  textAlign: isArabic ? TextAlign.start : TextAlign.start,
                  S.of(context).about_app_page_title1,
                  style: TextStyle(
                    color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}