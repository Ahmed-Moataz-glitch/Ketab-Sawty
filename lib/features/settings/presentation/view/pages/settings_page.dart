import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/settings/presentation/view/widgets/row_item_widget.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings_page_app_bar,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isLightTheme ? AppColors.white : AppColors.dark.withAlpha(240),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withAlpha(50),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  RowItemWidget(
                    icon: Icons.volume_up_outlined,
                    title: S.of(context).settings_page_title1,
                    items: [
                      S.of(context).settings_page_title1_value1, 
                      S.of(context).settings_page_title1_value2, 
                      S.of(context).settings_page_title1_value3,
                    ],
                  ),
                  Divider(
                    color: AppColors.grey.withAlpha(100),
                    thickness: 1,
                    height: 32.h,
                  ),
                  RowItemWidget(
                    icon: Icons.brightness_6_outlined,
                    title: S.of(context).settings_page_title2,
                    items: [
                      S.of(context).settings_page_title2_value1, 
                      S.of(context).settings_page_title2_value2,
                      S.of(context).settings_page_title2_value3,
                    ],
                  ),
                  Divider(
                    color: AppColors.grey.withAlpha(100),
                    thickness: 1,
                    height: 32.h,
                  ),
                  RowItemWidget(
                    icon: Icons.language_outlined,
                    title: S.of(context).settings_page_title3,
                    items: [
                      S.of(context).settings_page_title3_value1, 
                      S.of(context).settings_page_title3_value2,
                    ],
                  ),
                  Divider(
                    color: AppColors.grey.withAlpha(100),
                    thickness: 1,
                    height: 32.h,
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.about,
                      );
                    },
                    child: isArabic
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 16.w,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 28.sp,
                        ),
                        Text(
                          S.of(context).settings_page_title4,
                          style: TextStyle(
                            color: isLightTheme ? AppColors.textPrimary : AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 16.w,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 28.sp,
                        ),
                        Text(
                          S.of(context).settings_page_title4,
                          style: TextStyle(
                            color: isLightTheme ? AppColors.textPrimary : AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
