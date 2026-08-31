import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class HiveServices {
  List<AudioFileModel> getAllAudioFilesFromFavorite() {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.favoriteAudioFilesBox,
    );
    return audioFileBox.values.toList();
  }
}