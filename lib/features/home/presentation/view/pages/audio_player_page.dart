import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/audio_player_helper_widgets.dart';

class AudioPlayerPage extends StatefulWidget {
  final PdfDetailsModel pdfDetailsModel;
  final File audioFile;
  const AudioPlayerPage({super.key, required this.pdfDetailsModel, required this.audioFile});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.playbackEventStream.listen(
      (event) {
        setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withAlpha(100),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 30.sp),
          onPressed: () {
            Navigator.of(context).pop();
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
              widget.pdfDetailsModel.author ?? 'غير معروف',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimary.withAlpha(120),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark.withAlpha(220),
              AppColors.primary.withAlpha(100),
            ],
            stops: const [0.5, 2.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.memory(
                widget.pdfDetailsModel.coverImageBytes,
                width: size.width * 0.6,
                height: size.height * 0.4,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    size: 40.sp,
                    color: AppColors.white,
                  ),
                  onPressed: (){}, 
                ),
                IconButton(
                  icon: Icon(
                    Icons.download_rounded,
                    size: 40.sp,
                    color: AppColors.white,
                  ),
                  onPressed: (){}, 
                ),
                IconButton(
                  icon: Icon(
                    Icons.book_outlined,
                    size: 40.sp,
                    color: AppColors.white,
                  ),
                  onPressed: (){}, 
                ),
              ],
            ),
            SizedBox(height: 16.h),
            setUpProgressBar(audioPlayer),
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
                    final newPosition = currentPosition - Duration(seconds: 10);
                    audioPlayer.seek(newPosition >= Duration.zero ? newPosition : Duration.zero);
                  },
                ),
                setUpPlayer(audioPlayer),
                IconButton(
                  icon: Icon(
                    Icons.forward_10_outlined,
                    size: 45.sp,
                    color: AppColors.white,
                  ),
                  iconSize: 40.sp,
                  onPressed: () {
                    final currentPosition = audioPlayer.position;
                    final newPosition = currentPosition + Duration(seconds: 10);
                    audioPlayer.seek(newPosition <= audioPlayer.duration! ? newPosition : audioPlayer.duration ?? Duration.zero);
                  },
                ),
                setUpVolumeControl(audioPlayer),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
