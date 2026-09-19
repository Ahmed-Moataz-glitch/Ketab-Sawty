import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isLightTheme
                    ? AppColors.white
                    : AppColors.dark.withAlpha(240),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isLightTheme ? AppColors.border : Colors.white10,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isLightTheme ? 8 : 40),
                    spreadRadius: 0,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
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
                    color: isLightTheme
                        ? AppColors.border.withAlpha(180)
                        : Colors.white10,
                    thickness: 1,
                    height: 24.h,
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
                    color: isLightTheme
                        ? AppColors.border.withAlpha(180)
                        : Colors.white10,
                    thickness: 1,
                    height: 24.h,
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
                    color: isLightTheme
                        ? AppColors.border.withAlpha(180)
                        : Colors.white10,
                    thickness: 1,
                    height: 24.h,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.about);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: isLightTheme
                                  ? AppColors.primary.withAlpha(20)
                                  : AppColors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 22.sp,
                              color: isLightTheme
                                  ? AppColors.primary
                                  : AppColors.primaryLight,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Text(
                            S.of(context).settings_page_title4,
                            style: TextStyle(
                              color: isLightTheme
                                  ? AppColors.textPrimary
                                  : AppColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
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
