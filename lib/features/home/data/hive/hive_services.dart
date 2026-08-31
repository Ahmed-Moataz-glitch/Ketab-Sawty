import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class HiveServices {
  Future<void> addAudioFileToFavorite(AudioFileModel audioFile) async {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.favoriteAudioFilesBox,
    );
    await audioFileBox.put(audioFile.id, audioFile);
  }

  Future<void> deleteAudioFileFromFavorite(String id) async {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.favoriteAudioFilesBox,
    );
    await audioFileBox.delete(id);
  }

  Future<void> saveAudioFile(AudioFileModel audioFile) async {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.savedAudioFilesBox,
    );
    await audioFileBox.put(audioFile.id, audioFile);
  }

  Future<void> deleteAudioFileFromSaved(String id) async {
    final audioFileBox = Hive.box<AudioFileModel>(
      AppConstants.savedAudioFilesBox,
    );
    await audioFileBox.delete(id);
  }
}
