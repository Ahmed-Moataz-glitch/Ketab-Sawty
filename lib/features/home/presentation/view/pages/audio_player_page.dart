// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_dialogs.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/audio_player_helper_widgets.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class AudioPlayerPage extends StatefulWidget {
  final HomeCubit homeCubit;
  final PdfDetailsModel pdfDetailsModel;
  final File audioFile;
  final int? audioPosition;
  final bool isFavorite;
  final bool isSaved;
  const AudioPlayerPage({
    super.key,
    required this.homeCubit,
    required this.pdfDetailsModel,
    required this.audioFile,
    this.audioPosition,
    required this.isFavorite,
    required this.isSaved,
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final audioPlayer = AudioPlayer();
  late bool isFavorite;
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    isSaved = widget.isSaved;
    audioPlayer.playbackEventStream.listen(
      (event) {
        // setState(() {});
      },
      onError: (Object e, StackTrace stackTrace) {
        debugPrint('Error: $e');
      },
    );
    try {
      audioPlayer.setAudioSource(
        // AudioSource.uri(
        //   Uri.parse("https://serv2.albumaty.com/2025/Albumaty.Com_mhi_ftwny_afwk_lkramty_-_mn_mslsl_alst_mwnalyza.mp3"),
        // ),
        AudioSource.file(widget.audioFile.path),
        initialPosition: Duration(seconds: widget.audioPosition ?? 0),
      );
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLightTheme ? AppColors.primary.withAlpha(100) : AppColors.dark,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 30.sp),
          onPressed: () async {
            isSaved
                ? await widget.homeCubit.saveAudioFile(
                              AudioFileModel(
                                id: widget.pdfDetailsModel.id,
                                coverImageBytes:
                                    widget.pdfDetailsModel.coverImageBytes,
                                audioFilePath: widget.audioFile.path,
                                audioPosition: audioPlayer.position.inSeconds,
                                audioDuration: audioPlayer.duration?.inSeconds ?? 0,
                                title: widget.pdfDetailsModel.title,
                                author:
                                    widget.pdfDetailsModel.author ??
                                    S.of(context).error,
                              ),
                            )
                            : null;
            if(mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Column(
          children: [
            Text(
              widget.pdfDetailsModel.title,
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.pdfDetailsModel.author ?? S.of(context).unknown,
              style: TextStyle(
                fontSize: 18.sp,
                color: isLightTheme ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) => current is AddAudioFileToFavoriteError,
            listener: (context, state) {
              if (state is AddAudioFileToFavoriteError) {
                AppDialogs.showSnackBar(
                  context: context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) => current is DeleteAudioFileFromFavoriteError,
            listener: (context, state) {
              if (state is DeleteAudioFileFromFavoriteError) {
                AppDialogs.showSnackBar(
                  context: context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) => current is SaveAudioFileError,
            listener: (context, state) {
              if (state is SaveAudioFileError) {
                AppDialogs.showSnackBar(
                  context: context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            bloc: widget.homeCubit,
            listenWhen: (previous, current) => current is DeleteAudioFileFromSavedError,
            listener: (context, state) {
              if (state is DeleteAudioFileFromSavedError) {
                AppDialogs.showSnackBar(
                  context: context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            },
          ),
        ],
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:  [
                isLightTheme ? AppColors.primaryDark.withAlpha(220) : AppColors.dark.withAlpha(100),
                isLightTheme ? AppColors.primary.withAlpha(100) : AppColors.dark.withAlpha(220),
              ],
              stops: const [0.5, 2.0],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.memory(
                  widget.pdfDetailsModel.coverImageBytes,
                  width: size.width * 0.6,
                  height: size.height * 0.4,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 64.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      size: 40.sp,
                      color: AppColors.white,
                    ),
                    onPressed: () async {
                      isFavorite
                          ? await widget.homeCubit.deleteAudioFileFromFavorite(
                              widget.pdfDetailsModel.id,
                            )
                          : await widget.homeCubit.addAudioFileToFavorite(
                              AudioFileModel(
                                id: widget.pdfDetailsModel.id,
                                coverImageBytes:
                                    widget.pdfDetailsModel.coverImageBytes,
                                audioFilePath: widget.audioFile.path,
                                audioPosition: audioPlayer.position.inSeconds,
                                audioDuration: audioPlayer.duration?.inSeconds ?? 0,
                                title: widget.pdfDetailsModel.title,
                                author:
                                    widget.pdfDetailsModel.author ??
                                    S.of(context).error,
                              ),
                            );
                      isFavorite = !isFavorite;
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      size: 40.sp,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      size: 42.sp,
                      color: AppColors.white,
                    ),
                    onPressed: () async {
                      isSaved
                          ? await widget.homeCubit.deleteAudioFileFromSaved(
                              widget.pdfDetailsModel.id,
                            )
                          : await widget.homeCubit.saveAudioFile(
                              AudioFileModel(
                                id: widget.pdfDetailsModel.id,
                                coverImageBytes:
                                    widget.pdfDetailsModel.coverImageBytes,
                                audioFilePath: widget.audioFile.path,
                                audioPosition: audioPlayer.position.inSeconds,
                                audioDuration: audioPlayer.duration?.inSeconds ?? 0,
                                title: widget.pdfDetailsModel.title,
                                author:
                                    widget.pdfDetailsModel.author ??
                                    S.of(context).error,
                              ),
                            );
                      isSaved = !isSaved;
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              setUpProgressBar(
                audioPlayer: audioPlayer,
                audioPosition: widget.audioPosition != null
                    ? Duration(seconds: widget.audioPosition!)
                    : Duration.zero,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  setUpSpeedControl(audioPlayer),
                  IconButton(
                    icon: Icon(
                      Icons.replay_10_outlined,
                      size: 45.sp,
                      color: AppColors.white,
                    ),
                    iconSize: 40.sp,
                    onPressed: () {
                      final currentPosition = audioPlayer.position;
                      final newPosition =
                          currentPosition - Duration(seconds: 10);
                      audioPlayer.seek(
                        newPosition >= Duration.zero
                            ? newPosition
                            : Duration.zero,
                      );
                    },
                  ),
                  setUpPlayer(
                    audioPlayer: audioPlayer,
                    audioPosition: Duration(seconds: widget.audioPosition ?? 0),
                    isLightTheme: isLightTheme,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.forward_10_outlined,
                      size: 45.sp,
                      color: AppColors.white,
                    ),
                    iconSize: 40.sp,
                    onPressed: () {
                      final currentPosition = audioPlayer.position;
                      final newPosition =
                          currentPosition + Duration(seconds: 10);
                      audioPlayer.seek(
                        newPosition <= audioPlayer.duration!
                            ? newPosition
                            : audioPlayer.duration ?? Duration.zero,
                      );
                    },
                  ),
                  setUpVolumeControl(audioPlayer),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
