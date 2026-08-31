import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source_hive.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo_hive.dart';

class HomeRepoHiveImpl extends HomeRepoHive {
  final HomeDataSourceHive homeDataSourceHive;
  HomeRepoHiveImpl(this.homeDataSourceHive);
  
  @override
  Future<void> addAudioFileToFavorite(AudioFileModel audioFile) async {
    return await homeDataSourceHive.addAudioFileToFavorite(audioFile);
  }
  
  @override
  Future<void> deleteAudioFileFromFavorite(String id) async {
    return await homeDataSourceHive.deleteAudioFileFromFavorite(id);
  }
  
  @override
  Future<void> deleteAudioFileFromSaved(String id) async {
    return await homeDataSourceHive.deleteAudioFileFromSaved(id);
  }
  
  @override
  Future<void> saveAudioFile(AudioFileModel audioFile) async {
    return await homeDataSourceHive.saveAudioFile(audioFile);
  }

  
}