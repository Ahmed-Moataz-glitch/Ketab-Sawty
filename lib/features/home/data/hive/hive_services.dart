import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class HiveServices {
  Future<void> addAudioFile(AudioFileModel audioFile) async {
    final audioFileBox = Hive.box<AudioFileModel>(AppConstants.audioFileBox);
    await audioFileBox.put(audioFile.id, audioFile);
  }

  List<AudioFileModel> getAllAudioFiles() {
    final audioFileBox = Hive.box<AudioFileModel>(AppConstants.audioFileBox);
    return audioFileBox.values.toList();
  }

  Future<void> deleteAudioFile(String id) async {
    final audioFileBox = Hive.box<AudioFileModel>(AppConstants.audioFileBox);
    await audioFileBox.delete(id);
  }
}