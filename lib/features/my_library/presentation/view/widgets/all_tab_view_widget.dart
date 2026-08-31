import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/my_library/presentation/view_model/my_library_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class AllTabViewWidget extends StatefulWidget {
  final MyLibraryCubit myLibraryCubit;
  final HomeCubit homeCubit;
  const AllTabViewWidget({
    super.key,
    required this.myLibraryCubit,
    required this.homeCubit,
  });

  @override
  State<AllTabViewWidget> createState() => _AllTabViewWidgetState();
}

class _AllTabViewWidgetState extends State<AllTabViewWidget> {
  @override
  void initState() {
    super.initState();
    widget.myLibraryCubit.getAllAudioFilesFromSaved();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;  
    final isArabic = AppLocalization.isArabic();
    return Scaffold(
      body: BlocBuilder<MyLibraryCubit, MyLibraryState>(
        bloc: widget.myLibraryCubit,
        buildWhen: (previous, current) =>
            current is GetAllAudioFilesFromSavedSuccess,
        builder: (context, state) {
          if (state is GetAllAudioFilesFromSavedSuccess) {
            return state.audioFiles.isEmpty
                ? Center(
                    child: Text(
                      S.of(context).my_library_page_title2,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 36.r,
                    ),
                    child: ListView.separated(
                      itemCount: state.audioFiles.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final audioFile = state.audioFiles[index];
                        return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(
                                  AppRoutes.audioPlayer,
                                  arguments: {
                                    'homeCubit': widget.homeCubit,
                                    'pdfDetailsModel': PdfDetailsModel(
                                      id: audioFile.id,
                                      title: audioFile.title,
                                      author: audioFile.author,
                                      coverImageBytes:
                                          audioFile.coverImageBytes,
                                    ),
                                    'audioFile': File(audioFile.audioFilePath),
                                    'audioPosition': audioFile.audioPosition,
                                    'isFavorite': false,
                                    'isSaved': true,
                                  },
                                )
                                .then((_) {
                                  widget.myLibraryCubit
                                      .getAllAudioFilesFromSaved();
                                });
                          },
                          child: isArabic
                              ? Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.memory(
                                        audioFile.coverImageBytes,
                                        width: size.width * 0.25,
                                        height: size.height * 0.11,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      spacing: 8.h,
                                      children: [
                                        Text(
                                          audioFile.title,
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isLightTheme ? AppColors.textPrimary : AppColors.white.withAlpha(220),
                                          ),
                                        ),
                                        Text(
                                          audioFile.author,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${(audioFile.audioPosition / audioFile.audioDuration * 100).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            SizedBox(
                                              width: size.width * 0.4,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: LinearProgressIndicator(
                                                  value:
                                                      audioFile.audioPosition /
                                                      audioFile.audioDuration,
                                                  color: isLightTheme ? AppColors.primary : AppColors.primaryLight,
                                                  minHeight: 6.h,
                                                  backgroundColor: AppColors.grey.withAlpha(50),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          audioFile.title,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          audioFile.author,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.4,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: LinearProgressIndicator(
                                                  value:
                                                      audioFile.audioPosition /
                                                      audioFile.audioDuration,
                                                  color: AppColors.primary,
                                                  minHeight: 6.h,
                                                  backgroundColor: AppColors
                                                      .grey
                                                      .withAlpha(50),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              '${(audioFile.audioPosition / audioFile.audioDuration * 100).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.memory(
                                        audioFile.coverImageBytes,
                                        width: size.width * 0.2,
                                        height: size.height * 0.1,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
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
