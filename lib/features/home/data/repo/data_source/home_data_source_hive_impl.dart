import 'package:ketab_sawty/features/home/data/hive/hive_services.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source_hive.dart';

class HomeDataSourceHiveImpl extends HomeDataSourceHive {
  final HiveServices hiveServices;
  HomeDataSourceHiveImpl(this.hiveServices);

  @override
  Future<void> addAudioFileToFavorite(AudioFileModel audioFile) async {
    return await hiveServices.addAudioFileToFavorite(audioFile);
  }
  
  @override
  Future<void> deleteAudioFileFromFavorite(String id) async {
    return await hiveServices.deleteAudioFileFromFavorite(id);
  }
  
  @override
  Future<void> deleteAudioFileFromSaved(String id) async {
    return await hiveServices.deleteAudioFileFromSaved(id);
  }
  
  @override
  Future<void> saveAudioFile(AudioFileModel audioFile) async {
    return await hiveServices.saveAudioFile(audioFile);
  }
}
