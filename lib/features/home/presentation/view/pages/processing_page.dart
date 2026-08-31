import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/app_toast.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';
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
      await widget.homeCubit.processPdf(widget.pdfDetailsModel.pdfBytes!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            S.of(context).processing_page_app_bar,
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
              title: S.of(context).error,
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
                    color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                    size: 140.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    S.of(context).processing_page_title1,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(200),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).processing_page_title2,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: isLightTheme ? AppColors.textSecondary : AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).processing_page_title3,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(200),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: CircularProgressIndicator(
                          value: progress / 100,
                          strokeWidth: 10.r,
                          color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                          backgroundColor: AppColors.grey.withAlpha(50),
                        ),
                      ),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '${S.of(context).the_page} ${ state.currrentPage + 1} ${S.of(context).from} ${widget.pdfDetailsModel.pageCount}',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(200),
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
