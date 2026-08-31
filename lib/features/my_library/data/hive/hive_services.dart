import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class HiveServices {
  List<AudioFileModel> getAllAudioFilesFromSaved() {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.savedAudioFilesBox,
    );
    return audioFileBox.values.toList();
  }
}