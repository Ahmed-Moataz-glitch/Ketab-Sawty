import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/app_theme.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/core/view/widgets/bottom_nav_bar_widget.dart';
import 'package:ketab_sawty/core/view_model/language_cubit/language_cubit.dart';
import 'package:ketab_sawty/core/view_model/theme_cubit/theme_cubit.dart';
import 'package:ketab_sawty/core/view_model/voice_cubit/voice_cubit.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/audio_player_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/capture_book_pages_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/pdf_view_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/processing_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/upload_pdf_page.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/settings/presentation/view/pages/about_app_page.dart';
import 'package:ketab_sawty/features/settings/presentation/view/pages/settings_page.dart';
import 'package:ketab_sawty/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await setupGetIt();
  Hive.registerAdapter<AudioFileModel>(AudioFileModelAdapter());
  await Hive.openBox<AudioFileModel>(AppConstants.favoriteAudioFilesBox);
  await Hive.openBox<AudioFileModel>(AppConstants.savedAudioFilesBox);
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<VoiceCubit>(create: (context) => VoiceCubit()),
            BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
            BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final themeCubit = ThemeCubit.get(context);
              return BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  final languageCubit = LanguageCubit.get(context);
                  return MaterialApp(
                    title: 'كتاب صوتي',
                    theme: AppTheme.light,
                    darkTheme: AppTheme.dark,
                    themeMode: themeCubit.getTheme(),
                    debugShowCheckedModeBanner: false,
                    locale: Locale(languageCubit.getLanguage()),
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,

                    onGenerateInitialRoutes: (initialRoute) {
                      switch (initialRoute) {
                        default:
                          return [
                            MaterialPageRoute(
                              builder: (_) => const BottomNavBarWidget(),
                            ),
                          ];
                      }
                    },
                    onUnknownRoute: (settings) {
                      switch (settings.name) {
                        case AppRoutes.appSection:
                          return MaterialPageRoute(
                            builder: (_) => const BottomNavBarWidget(),
                          );
                        // case AppRoutes.home:
                        //   return MaterialPageRoute(builder: (_) => HomePage());
                        // case AppRoutes.myLibrary:
                        //   return MaterialPageRoute(
                        //     builder: (_) => MyLibraryPage(),
                        //   );
                        // case AppRoutes.favorites:
                        //   return MaterialPageRoute(
                        //     builder: (_) => FavoritesPage(),
                        //   );
                        case AppRoutes.settings:
                          return MaterialPageRoute(
                            builder: (_) => SettingsPage(),
                          );
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
                        case AppRoutes.captureBookPages:
                          final homeCubit = settings.arguments as HomeCubit;
                          return MaterialPageRoute(
                            builder: (_) =>
                                CaptureBookPagesPage(homeCubit: homeCubit),
                          );
                        case AppRoutes.pdfView:
                          final args =
                              settings.arguments as Map<String, dynamic>;
                          final homeCubit = args['homeCubit'] as HomeCubit;
                          final pdfDetailsModel =
                              args['pdfDetailsModel'] as PdfDetailsModel;
                          final extractedText =
                              args['extractedText'] as List<String>;
                          return MaterialPageRoute(
                            builder: (_) => PdfViewPage(
                              homeCubit: homeCubit,
                              pdfDetailsModel: pdfDetailsModel,
                              extractedText: extractedText,
                            ),
                          );
                        case AppRoutes.audioPlayer:
                          final args =
                              settings.arguments as Map<String, dynamic>;
                          final homeCubit = args['homeCubit'] as HomeCubit;
                          final pdfDetailsModel =
                              args['pdfDetailsModel'] as PdfDetailsModel;
                          final audioFile = args['audioFile'] as File;
                          final audioPosition = args['audioPosition'] as int?;
                          final isFavorite = args['isFavorite'] as bool;
                          final isSaved = args['isSaved'] as bool;
                          return MaterialPageRoute(
                            builder: (_) => AudioPlayerPage(
                              homeCubit: homeCubit,
                              pdfDetailsModel: pdfDetailsModel,
                              audioFile: audioFile,
                              audioPosition: audioPosition,
                              isFavorite: isFavorite,
                              isSaved: isSaved,
                            ),
                          );
                        case AppRoutes.processing:
                          final args =
                              settings.arguments as Map<String, dynamic>;
                          final homeCubit = args['homeCubit'] as HomeCubit;
                          final pdfDetailsModel =
                              args['pdfDetailsModel'] as PdfDetailsModel;
                          return MaterialPageRoute(
                            builder: (_) => ProcessingPage(
                              homeCubit: homeCubit,
                              pdfDetailsModel: pdfDetailsModel,
                            ),
                          );
                        case AppRoutes.about:
                          return MaterialPageRoute(
                            builder: (_) => const AboutAppPage(),
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
            },
          ),
        );
      },
    );
  }
}
