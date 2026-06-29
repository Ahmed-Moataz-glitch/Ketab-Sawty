import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/app_toast.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:toastification/toastification.dart';

class ProcessingPage extends StatefulWidget {
  final HomeCubit homeCubit;
  final PdfDetailsModel pdfDetailsModel;
  const ProcessingPage({
    super.key,
    required this.homeCubit,
    required this.pdfDetailsModel,
  });

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.homeCubit.processPdf(widget.pdfDetailsModel.pdfBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'جاري المعالجة',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        bloc: widget.homeCubit,
        listenWhen: (previous, current) =>
            current is ProcessingPdfSuccess || current is ProcessingPdfError,
        buildWhen: (previous, current) => current is ProcessingPdf,
        listener: (context, state) {
          if (state is ProcessingPdfSuccess) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.pdfView,
              arguments: {
                'homeCubit': widget.homeCubit,
                'pdfDetailsModel': widget.pdfDetailsModel,
                'extractedText': state.processedText,
              },
            );
          }
          if (state is ProcessingPdfError) {
            return AppToast.showToast(
              context: context,
              title: 'خطأ',
              description: state.errorMessage,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is ProcessingPdf) {
            progress = (state.currrentPage / state.totalPages) * 100;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary,
                    size: 140.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري استخراج النص من الكتاب',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'قد تستغرق العملية بضع دقائق',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'يرجى عدم غلق التطبيق',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 48.w),
                  //   child: Center(
                  //     child: LinearProgressIndicator(color: AppColors.primary),
                  //   ),
                  // ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: CircularProgressIndicator(
                          value: progress / 100,
                          strokeWidth: 10.r,
                          color: AppColors.primary,
                          backgroundColor: AppColors.grey.withAlpha(50),
                        ),
                      ),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      // Container(
                      //   width: 300.w,
                      //   height: 100.h,
                      //   decoration: BoxDecoration(
                      //     color: AppColors.transparent,
                      //     shape: BoxShape.circle,
                      //     border: Border.all(
                      //       color: AppColors.grey,
                      //       width: 10.r,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   width: 300.w,
                      //   height: 100.h,
                      //   decoration: BoxDecoration(
                      //     color: AppColors.transparent,
                      //     shape: BoxShape.circle,
                      //     border: Border.all(
                      //       color: AppColors.primary,
                      //       width: 10.r,
                      //     ),
                      //   ),
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       '${progress.toStringAsFixed(0)}%',
                      //       style: TextStyle(
                      //         fontSize: 26.sp,
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.primary,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'الصفحة ${state.currrentPage + 1} من ${widget.pdfDetailsModel.pageCount}',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
