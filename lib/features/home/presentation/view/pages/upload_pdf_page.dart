import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_assets.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_dialogs.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/book_information_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';

class UploadPdfPage extends StatelessWidget {
  final HomeCubit homeCubit;
  const UploadPdfPage({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'رفع ملف PDF',
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
                                  'اسحب ملف PDF هنا\n او اضغط للاختيار',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: 'اختيار ملف',
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
                      alignment: Alignment.centerRight,
                      child: Text(
                        'معلومات الكتاب',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.border, width: 1.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8.h,
                        children: [
                          BookInformationWidget(
                            title: 'اسم الكتاب',
                            value: pdfDetails.title,
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: 'المؤلف',
                            value: pdfDetails.author ?? 'غير معروف',
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: 'عدد الصفحات',
                            value: '${pdfDetails.pageCount} صفحة',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            title: 'التالي', 
                            onPressed: () {
                              Navigator.of(context).pushNamed(
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
                              color: AppColors.primary,
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'اسحب ملف PDF هنا\n او اضغط للاختيار',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: 'اختيار ملف',
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
                      alignment: Alignment.centerRight,
                      child: Text(
                        'معلومات الكتاب',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.border, width: 1.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 8.h,
                        children: [
                          BookInformationWidget(
                            title: 'اسم الكتاب',
                            value: 'أساور سيكتوريا',
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: 'المؤلف',
                            value: 'حمادة الكاشف',
                          ),
                          SizedBox(height: 4.h),
                          BookInformationWidget(
                            title: 'عدد الصفحات',
                            value: '223 صفحة',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            title: 'التالي',
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
