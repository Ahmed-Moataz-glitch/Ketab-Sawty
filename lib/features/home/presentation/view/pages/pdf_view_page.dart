import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_dialogs.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/app_toast.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class PdfViewPage extends StatefulWidget {
  final HomeCubit homeCubit;
  final PdfDetailsModel pdfDetailsModel;
  final List<String> extractedText;
  const PdfViewPage({
    super.key,
    required this.homeCubit,
    required this.pdfDetailsModel,
    required this.extractedText,
  });

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  late final PageController _pageController;
  File? audioFile;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeAudioFile();
  }

  Future<void> _initializeAudioFile() async {
    await widget.homeCubit.isAudioFileExists(widget.pdfDetailsModel.id)
        ? audioFile = File(
            '/storage/emulated/0/Music/${widget.pdfDetailsModel.id}.mp3',
          )
        : await widget.homeCubit.createAudioFile(
            text: widget.extractedText.join(' '),
            fileName: widget.pdfDetailsModel.title,
          );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).pdf_view_page_app_bar,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) =>
                current is SpeakArabicSuccess || current is SpeakArabicError,
            listener: (context, state) {
              if (state is SpeakArabicSuccess) {
                AppToast.showToast(
                  context: context,
                  title: S.of(context).pdf_view_page_app_toast_title1,
                  description: S.of(context).pdf_view_page_app_toast_description1,
                  type: ToastificationType.success,
                );
              }
              if (state is SpeakArabicError) {
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
                current is CreatingAudioFile ||
                current is CreateAudioFileSuccess ||
                current is CreateAudioFileError,
            listener: (context, state) {
              if (state is CreatingAudioFile) {
                AppDialogs.showLoadingDialog(
                  context,
                  title: S.of(context).pdf_view_page_loading,
                );
              }
              if (state is CreateAudioFileSuccess) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(); // Close the loading dialog
                audioFile = state.audioFile;
                AppToast.showToast(
                  context: context,
                  title: S.of(context).pdf_view_page_app_toast_title2,
                  description: S.of(context).pdf_view_page_app_toast_description2,
                  type: ToastificationType.success,
                );
              }
              if (state is CreateAudioFileError) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(); // Close the loading dialog
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
          buildWhen: (previous, current) => current is GetCurrentWordIndex,
          builder: (context, state) {
            return PageView.builder(
              itemCount: widget.extractedText.length,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              // onPageChanged: (value) {
              //   // setState(() {
              //   //   currentPageIndex = value;
              //   // });
              //   currentPageIndex = value;
              // },
              itemBuilder: (context, index) {
                int currentWordStartIndex = 0;
                int currentWordEndIndex = 0;
                if (state is GetCurrentWordIndex) {
                  currentWordStartIndex =
                      state.currentWordIndex['currentWordStartIndex'] ?? 0;
                  currentWordEndIndex =
                      state.currentWordIndex['currentWordEndIndex'] ?? 0;
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              text: widget.extractedText[index].substring(
                                0,
                                currentWordStartIndex,
                              ),
                              style: TextStyle(
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.extractedText[index].substring(
                                    currentWordStartIndex,
                                    currentWordEndIndex,
                                  ),
                                  style: TextStyle(
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                    backgroundColor: AppColors.primary,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.extractedText[index].substring(
                                    currentWordEndIndex,
                                  ),
                                  style: TextStyle(
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomButtonWidget(
                            onPressed: () async {
                              widget.homeCubit.getCurrentWordIndex();
                              await widget.homeCubit.speakArabic(
                                widget.extractedText[index],
                              );
                            },
                            title: S.of(context).pdf_view_page_title1,
                            icon: Icons.volume_up,
                          ),
                          SizedBox(height: 20.h),
                          CustomButtonWidget(
                            onPressed: () async {
                              Navigator.of(context).pushNamed(
                                AppRoutes.audioPlayer,
                                arguments: {
                                  'homeCubit': widget.homeCubit,
                                  'pdfDetailsModel': widget.pdfDetailsModel,
                                  'audioFile': audioFile,
                                  'isFavorite': false,
                                  'isSaved': false,
                                },
                              );
                            },
                            title: S.of(context).pdf_view_page_title2,
                            icon: Icons.volume_up,
                          ),
                          SizedBox(height: 36.h),
                          Row(
                            spacing: 150.w,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  title: S.of(context).upload_pdf_page_title7,
                                  onPressed:
                                      index < widget.extractedText.length - 1
                                      ? () {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                ),
                              ),
                              Expanded(
                                child: CustomButtonWidget(
                                  title: S.of(context).pdf_view_page_title3,
                                  onPressed: index > 0
                                      ? () {
                                          _pageController.previousPage(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
