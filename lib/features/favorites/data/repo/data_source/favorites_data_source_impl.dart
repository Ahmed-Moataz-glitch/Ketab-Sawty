import 'package:ketab_sawty/features/favorites/domain/repo/data_source/favorites_data_source.dart';
import 'package:ketab_sawty/features/favorites/data/hive/hive_services.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class FavoritesDataSourceImpl extends FavoritesDataSource {
  final HiveServices hiveServices;
  FavoritesDataSourceImpl(this.hiveServices);

  @override
  List<AudioFileModel> getAllAudioFilesFromFavorite() {
    return hiveServices.getAllAudioFilesFromFavorite();
  }
}