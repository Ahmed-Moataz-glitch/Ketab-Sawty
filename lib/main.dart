import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/view/widgets/bottom_nav_bar_widget.dart';
import 'package:ketab_sawty/features/favorites/presentation/view/pages/favorites_page.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/audio_player_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/home_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/pdf_view_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/processing_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/upload_pdf_page.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/pages/my_library_page.dart';
import 'package:ketab_sawty/features/settings/presentation/view/pages/settings_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<AudioFileModel>(AppConstants.audioFileBox);
  Hive.registerAdapter<AudioFileModel>(AudioFileModelAdapter());
  runApp(const KetabSawty());
}

class KetabSawty extends StatelessWidget {
  const KetabSawty({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 869),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'كتاب صوتي',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Tajawal',
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          onGenerateInitialRoutes: (initialRoute) {
            switch (initialRoute) {
              default:
                return [
                  MaterialPageRoute(builder: (_) => const BottomNavBarWidget()),
                ];
            }
          },
          onUnknownRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.appSection:
                return MaterialPageRoute(
                  builder: (_) => const BottomNavBarWidget(),
                );
              case AppRoutes.home:
                return MaterialPageRoute(builder: (_) => HomePage());
              case AppRoutes.myLibrary:
                return MaterialPageRoute(builder: (_) => MyLibraryPage());
              case AppRoutes.favorites:
                return MaterialPageRoute(builder: (_) => FavoritesPage());
              case AppRoutes.settings:
                return MaterialPageRoute(builder: (_) => SettingsPage());
              default:
                return MaterialPageRoute(
                  builder: (_) => const BottomNavBarWidget(),
                );
            }
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.uploadPdf:
                final homeCubit = settings.arguments as HomeCubit;
                return MaterialPageRoute(
                  builder: (_) => UploadPdfPage(homeCubit: homeCubit),
                );
              case AppRoutes.pdfView:
                final args = settings.arguments as Map<String, dynamic>;
                final homeCubit = args['homeCubit'] as HomeCubit;
                final pdfDetailsModel =
                    args['pdfDetailsModel'] as PdfDetailsModel;
                final extractedText = args['extractedText'] as List<String>;
                return MaterialPageRoute(
                  builder: (_) => PdfViewPage(
                    homeCubit: homeCubit,
                    pdfDetailsModel: pdfDetailsModel,
                    extractedText: extractedText,
                  ),
                );
              case AppRoutes.audioPlayer:
                final args = settings.arguments as Map<String, dynamic>;
                final pdfDetailsModel =
                    args['pdfDetailsModel'] as PdfDetailsModel;
                final audioFile = args['audioFile'] as File;
                return MaterialPageRoute(
                  builder: (_) => AudioPlayerPage(
                    pdfDetailsModel: pdfDetailsModel,
                    audioFile: audioFile,
                  ),
                );
              case AppRoutes.processing:
                final args = settings.arguments as Map<String, dynamic>;
                final homeCubit = args['homeCubit'] as HomeCubit;
                final pdfDetailsModel =
                    args['pdfDetailsModel'] as PdfDetailsModel;
                return MaterialPageRoute(
                  builder: (_) => ProcessingPage(
                    homeCubit: homeCubit,
                    pdfDetailsModel: pdfDetailsModel,
                  ),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const BottomNavBarWidget(),
                );
            }
          },
        );
      },
    );
  }
}
