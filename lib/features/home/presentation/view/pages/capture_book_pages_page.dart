import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_dialogs.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/app_toast.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class CaptureBookPagesPage extends StatefulWidget {
  final HomeCubit homeCubit;
  const CaptureBookPagesPage({super.key, required this.homeCubit});

  @override
  State<CaptureBookPagesPage> createState() => _CaptureBookPagesPageState();
}

class _CaptureBookPagesPageState extends State<CaptureBookPagesPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).capture_book_pages_page_app_bar,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) => current is CaptureBookPagesError,
            listener: (context, state) {
              if (state is CaptureBookPagesError) {
                AppToast.showToast(
                  context: context,
                  title: S.of(context).error,
                  description: state.errorMessage,
                  type: ToastificationType.error,
                );
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) =>
                current is CreatePdfFromCapturedImagesLoading ||
                current is CreatePdfFromCapturedImagesSuccess ||
                current is CreatePdfFromCapturedImagesError,
            listener: (context, state) {
              if (state is CreatePdfFromCapturedImagesLoading) {
                AppDialogs.showLoadingDialog(
                  context, 
                  title: S.of(context).capture_book_pages_page_loading,
                );
              }
              if (state is CreatePdfFromCapturedImagesSuccess) {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.processing,
                  arguments: {
                    'homeCubit': widget.homeCubit,
                    'pdfDetailsModel': state.pdfDetails,
                  },
                );
              }
              if (state is CreatePdfFromCapturedImagesError) {
                AppToast.showToast(
                  context: context,
                  title: S.of(context).error,
                  description: state.errorMessage,
                  type: ToastificationType.error,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: widget.homeCubit,
          buildWhen: (previous, current) => current is CaptureBookPagesSuccess,
          builder: (context, state) {
            if (state is CaptureBookPagesSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.r),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(40),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.2.r,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          spacing: 24.h,
                          children: [
                            SizedBox(
                              height: size.height * 0.3,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.capturedPages.length,
                                itemBuilder: (context, index) {
                                  final page = state.capturedPages[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          child: Image.file(
                                            File(page.path),
                                            width:
                                                state.capturedPages.length == 1
                                                ? size.width * 0.835
                                                : size.width * 0.4,
                                            height: size.height * 0.3,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          right: 8.w,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withAlpha(200),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Text(
                                              '${S.of(context).page} ${index + 1}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -4.h,
                                          left: -2.w,
                                          child: IconButton.filled(
                                            style: ButtonStyle(
                                              minimumSize:
                                                  WidgetStateProperty.all(
                                                    Size.zero,
                                                  ),
                                              fixedSize:
                                                  WidgetStateProperty.all(
                                                    Size(32.w, 32.h),
                                                  ),
                                              padding: WidgetStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                    AppColors.red.withAlpha(
                                                      200,
                                                    ),
                                                  ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        48.r,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: AppColors.white,
                                            ),
                                            onPressed: () {
                                              state.capturedPages.removeAt(
                                                index,
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 16.w),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: S.of(context).capture_book_pages_page_app_bar,
                                    icon: Icons.camera_alt_rounded,
                                    onPressed: () async {
                                      await widget.homeCubit.captureBookPages(
                                        context,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.37),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtonWidget(
                              title: S.of(context).upload_pdf_page_title7,
                              onPressed: () async {
                                await widget.homeCubit
                                    .creataPdfFromCapturedImages(
                                      state.capturedPages,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
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
                      Container(
                        padding: EdgeInsets.all(16.r),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(40),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.2.r,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          spacing: 48.h,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.primary,
                              size: 64.sp,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    title: S.of(context).capture_book_pages_page_app_bar,
                                    onPressed: () async {
                                      await widget.homeCubit.captureBookPages(
                                        context,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.56),
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
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
