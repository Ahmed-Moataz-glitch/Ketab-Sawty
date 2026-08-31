import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_assets.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class HomePage extends StatefulWidget {
  final HomeCubit homeCubit;
  const HomePage({super.key, required this.homeCubit});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    return Scaffold(
      appBar: AppBar(
        leading: isArabic
            ? Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  Icons.workspace_premium,
                  color: AppColors.yellow,
                  size: 42.sp,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: isLightTheme ? AppColors.grey.withAlpha(50) : AppColors.white.withAlpha(200),
                  child: Icon(Icons.person, size: 32.sp, color: isLightTheme ? AppColors.textSecondary : AppColors.textSecondary),
                ),
              ),
        actions: [
          isArabic
              ? Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: isLightTheme ? AppColors.grey.withAlpha(50) : AppColors.grey.withAlpha(200),
                    child: Icon(Icons.person, size: 32.sp, color: isLightTheme ? AppColors.textSecondary : AppColors.textPrimary),
                  ),
              )
              : Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                    Icons.workspace_premium,
                    color: AppColors.yellow,
                    size: 42.sp,
                  ),
              ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: size.width),
            Row(
              spacing: 6.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).home_page_title1,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Icon(Icons.waving_hand, color: AppColors.yellow, size: 24.sp),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).home_page_title2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: isLightTheme ? AppColors.primary : AppColors.grey,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).home_page_title3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 36.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.multitrack_audio,
                  color: isLightTheme ? AppColors.primary.withAlpha(80) : AppColors.white.withAlpha(80),
                  size: 64.sp,
                ),
                Image.asset(
                  AppAssets.audioBookImage,
                  height: size.height * 0.15,
                  color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                ),
                Icon(
                  Icons.multitrack_audio,
                  color: isLightTheme ? AppColors.primary.withAlpha(80) : AppColors.white.withAlpha(80),
                  size: 64.sp,
                ),
              ],
            ),
            SizedBox(height: 36.h),
            CustomButtonWidget(
              title: S.of(context).home_page_title4,
              icon: Icons.upload_file,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.uploadPdf, arguments: widget.homeCubit);
              },
            ),
            SizedBox(height: 16.h),
            CustomButtonWidget(
              backgroundColor: AppColors.white,
              title: S.of(context).home_page_title5,
              icon: Icons.camera_alt_rounded,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.captureBookPages, arguments: widget.homeCubit);
              },
            ),
          ],
        ),
      ),
    );
  }
}
