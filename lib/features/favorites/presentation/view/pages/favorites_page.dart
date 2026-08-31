import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_routes.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class FavoritesPage extends StatefulWidget {
  final HomeCubit homeCubit;
  const FavoritesPage({super.key, required this.homeCubit});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final FavoritesCubit favoritesCubit;

  @override
  void initState() {
    super.initState();
    favoritesCubit = getIt<FavoritesCubit>();
    favoritesCubit.getAllAudioFilesFromFavorite();
  }

  @override
  void dispose() {
    favoritesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).favorites_page_app_bar,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isLightTheme
                ? AppColors.textPrimary
                : AppColors.white.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: favoritesCubit,
        buildWhen: (previous, current) =>
            current is GetAllAudioFilesFromFavoriteSuccess,
        builder: (context, state) {
          if (state is GetAllAudioFilesFromFavoriteSuccess) {
            return state.audioFiles.isEmpty
                ? Center(
                    child: Text(
                      S.of(context).favorites_page_title1,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isLightTheme
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16.r),
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
                                    'isFavorite': true,
                                    'isSaved': false,
                                  },
                                )
                                .then((_) {
                                  favoritesCubit.getAllAudioFilesFromFavorite();
                                });
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.memory(
                                  audioFile.coverImageBytes,
                                  width: size.width * 0.25,
                                  height: size.height * 0.12,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    audioFile.title,
                                    style: TextStyle(
                                      color: isLightTheme
                                          ? AppColors.textPrimary
                                          : AppColors.white.withAlpha(220),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
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
                                ],
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
