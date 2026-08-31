import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

abstract class HomeDataSourceHive {
  Future<void> addAudioFileToFavorite(AudioFileModel audioFile);

  Future<void> deleteAudioFileFromFavorite(String id);
  
  Future<void> saveAudioFile(AudioFileModel audioFile);

  Future<void> deleteAudioFileFromSaved(String id);
}
