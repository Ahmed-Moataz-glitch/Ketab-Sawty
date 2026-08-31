import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';

Widget setUpPlayer({required AudioPlayer audioPlayer, required Duration audioPosition, required bool isLightTheme}) {
  return StreamBuilder<PlayerState>(
    stream: audioPlayer.playerStateStream,
    builder: (context, snapshot) {
      final playerState = snapshot.data;
      final processingState = playerState?.processingState;
      final playing = playerState?.playing;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        return Container(
          margin: EdgeInsets.all(8.r),
          width: 64.w,
          height: 64.h,
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (playing != true) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8.r),
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.play_arrow, size: 45.sp, color: isLightTheme ? AppColors.primary : AppColors.textPrimary),
            iconSize: 64.sp,
            onPressed: audioPlayer.play,
          ),
        );
      } else if (processingState != ProcessingState.completed) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8.r),
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.pause, size: 40.sp, color: isLightTheme ? AppColors.primary : AppColors.textPrimary),
            onPressed: audioPlayer.pause,
          ),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8.r),
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.replay, size: 45.sp, color: isLightTheme ? AppColors.primary : AppColors.textPrimary),
            iconSize: 64.sp,
            onPressed: () => audioPlayer.seek(Duration.zero),
          ),
        );
      }
    },
  );
}

Widget setUpSpeedControl(AudioPlayer audioPlayer) {
  return StreamBuilder(
    stream: audioPlayer.speedStream,
    builder: (context, snapshot) {
      final speed = snapshot.data ?? 1.0;
      return IconButton(
        icon: Icon(Icons.speed, size: 40.sp, color: AppColors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('اختر سرعة التشغيل'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var s in [0.5, 1.0, 1.5, 2.0])
                      RadioGroup(
                        groupValue: speed,
                        onChanged: (value) {
                          audioPlayer.setSpeed(value!);
                          Navigator.of(context).pop();
                        },
                        child: RadioListTile(value: s, title: Text('${s}x')),
                      ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget setUpVolumeControl(AudioPlayer audioPlayer) {
  return StreamBuilder(
    stream: audioPlayer.volumeStream,
    builder: (context, snapshot) {
      final volume = snapshot.data ?? 1.0;
      return IconButton(
        icon: Icon(
          volume > 0 ? Icons.volume_up : Icons.volume_off,
          size: 40.sp,
          color: AppColors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('اختر مستوى الصوت'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var s in [0.0, 0.25, 0.5, 0.75, 1.0])
                      RadioGroup(
                        groupValue: volume,
                        onChanged: (value) {
                          audioPlayer.setVolume(value!);
                          Navigator.of(context).pop();
                        },
                        child: RadioListTile(
                          value: s,
                          title: Text('${(s * 100).round()}%'),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget setUpProgressBar({
  required AudioPlayer audioPlayer,
  required Duration audioPosition,
}) {
  return StreamBuilder<Duration>(
    stream: audioPlayer.positionStream,
    builder: (context, snapshot) {
      final position = snapshot.data ?? audioPosition;
      final duration = audioPlayer.duration ?? Duration.zero;
      return Slider(
        min: 0.0,
        max: duration.inSeconds.toDouble(),
        value: position.inSeconds.toDouble().clamp(
          0.0,
          duration.inSeconds.toDouble(),
        ),
        activeColor: AppColors.white,
        inactiveColor: AppColors.grey.withAlpha(80),
        padding: EdgeInsets.symmetric(horizontal: 28.r),
        onChanged: (value) {
          audioPlayer.seek(Duration(seconds: value.toInt()));
        },
      );
    },
  );
}
