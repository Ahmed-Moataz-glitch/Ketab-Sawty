import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_assets.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/features/home/data/api/home_api.dart';
import 'package:ketab_sawty/features/home/data/repo/data_source/home_data_source_impl.dart';
import 'package:ketab_sawty/features/home/data/repo/repo/home_repo_impl.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/create_audio_file_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/pick_pdf_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/speak_arabic_use_case.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    HomeApi homeApi = HomeApi();
    HomeDataSource homeDataSource = HomeDataSourceImpl(homeApi);
    HomeRepo homeRepo = HomeRepoImpl(homeDataSource);
    PickPdfUseCase pickPdfUseCase = PickPdfUseCase(homeRepo);
    // ProcessPdfUseCase processPdfUseCase = ProcessPdfUseCase(homeRepo);
    SpeakArabicUseCase speakArabicUseCase = SpeakArabicUseCase(homeRepo);
    CreateAudioFileUseCase createAudioFileUseCase = CreateAudioFileUseCase(homeRepo);
    homeCubit = HomeCubit(
      pickPdfUseCase: pickPdfUseCase,
      // processPdfUseCase: processPdfUseCase,
      speakArabicUseCase: speakArabicUseCase,
      createAudioFileUseCase: createAudioFileUseCase,
    );
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.workspace_premium,
          color: AppColors.yellow,
          size: 42.sp,
        ),
        actions: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.grey.withAlpha(50),
            child: Icon(Icons.person, size: 32.sp),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 16.w),
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
                Icon(Icons.waving_hand, color: AppColors.yellow, size: 24.sp),
                Text(
                  'مرحبا بك',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'حوّل كتبك إلى\n كتب صوتية',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'ارفع كتاباً او صوّر صفحاته\n واستمع إليه في أي وقت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 36.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.multitrack_audio,
                  color: AppColors.primary.withAlpha(80),
                  size: 64.sp,
                ),
                Image.asset(
                  AppAssets.audioBookImage,
                  height: size.height * 0.15,
                  color: AppColors.primary,
                ),
                Icon(
                  Icons.multitrack_audio,
                  color: AppColors.primary.withAlpha(80),
                  size: 64.sp,
                ),
              ],
            ),
            SizedBox(height: 36.h),
            CustomButtonWidget(
              title: 'رفع ملف PDF',
              icon: Icons.upload_file,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.uploadPdf, arguments: homeCubit);
              },
            ),
            SizedBox(height: 16.h),
            CustomButtonWidget(
              backgroundColor: AppColors.white,
              title: 'تصوير صفحات كتاب',
              icon: Icons.camera_alt_rounded,
              onPressed: () {
                // Handle button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
