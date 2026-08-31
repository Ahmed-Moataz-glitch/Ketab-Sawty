import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_assets.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_dialogs.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/book_information_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class UploadPdfPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const UploadPdfPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            S.of(context).upload_pdf_page_app_bar,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (previous, current) => current is PickPdfError,
        buildWhen: (previous, current) =>
            current is PickPdfSuccess ||
            current is PickPdfError ||
            current is HomeInitial,
        listener: (context, state) {
          if (state is PickPdfError) {
            AppDialogs.showSnackBar(
              context: context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is PickPdfSuccess) {
            final pdfDetails = state.pdfDetails;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: Radius.circular(12.r),
                        strokeWidth: 1.5.r,
                        color: AppColors.grey,
                        dashPattern: const [6, 3],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        width: size.width,
                        decoration: BoxDecoration(color: AppColors.transparent),
                        child: Column(
                          spacing: 24.h,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.memory(
                                pdfDetails.coverImageBytes,
                                width: size.width * 0.3,
                                height: size.height * 0.2,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  S.of(context).upload_pdf_page_title1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: S.of(context).upload_pdf_page_title2,
                                    onPressed: () async {
                                      await homeCubit.pickPdf();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        S.of(context).upload_pdf_page_title3,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(200),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isLightTheme ? AppColors.white : AppColors.dark.withAlpha(200),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: isLightTheme ? AppColors.border : AppColors.textSecondary, width: 1.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8.h,
                        children: [
                          BookInformationWidget(
                            title: S.of(context).upload_pdf_page_title4,
                            value: pdfDetails.title,
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: S.of(context).uplaod_pdf_page_title5,
                            value: pdfDetails.author ?? S.of(context).unknown,
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: S.of(context).uplaod_pdf_page_title6,
                            value: isArabic
                                ? '${pdfDetails.pageCount} ${(pdfDetails.pageCount! >= 10 || pdfDetails.pageCount == 1) ? S.of(context).page : S.of(context).pages}'
                                : '${pdfDetails.pageCount} ${pdfDetails.pageCount == 1 ? S.of(context).page : S.of(context).pages}',
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            title: S.of(context).upload_pdf_page_title7,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                AppRoutes.processing,
                                arguments: {
                                  'homeCubit': homeCubit,
                                  'pdfDetailsModel': pdfDetails,
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: Radius.circular(12.r),
                        strokeWidth: 1.5.r,
                        color: AppColors.grey,
                        dashPattern: const [6, 3],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        width: size.width,
                        decoration: BoxDecoration(color: AppColors.transparent),
                        child: Column(
                          spacing: 24.h,
                          children: [
                            Image.asset(
                              AppAssets.pdfFileImage,
                              height: size.height * 0.15,
                              color: isLightTheme ? AppColors.primary : AppColors.grey,
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  S.of(context).upload_pdf_page_title1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: S.of(context).upload_pdf_page_title2,
                                    onPressed: () async {
                                      await homeCubit.pickPdf();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    Align(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        S.of(context).upload_pdf_page_title3,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(200),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isLightTheme ? AppColors.white : AppColors.dark.withAlpha(200),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: isLightTheme ? AppColors.border : AppColors.textSecondary, width: 1.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8.h,
                        children: [
                          BookInformationWidget(
                            title: S.of(context).upload_pdf_page_title4,
                            value: isArabic ? 'أساور سيكتوريا' : 'Asawir Sectoria',
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: S.of(context).uplaod_pdf_page_title5,
                            value: isArabic ? 'حمادة الكاشف' : 'Hamada Al-Kashif',
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: S.of(context).uplaod_pdf_page_title6,
                            value: isArabic ? '223 صفحة' : '223 Pages',
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            title: S.of(context).upload_pdf_page_title7,
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
