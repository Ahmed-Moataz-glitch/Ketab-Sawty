import 'package:ketab_sawty/features/favorites/domain/repo/data_source/favorites_data_source.dart';
import 'package:ketab_sawty/features/favorites/domain/repo/repo/favorites_repo.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class FavoritesRepoImpl extends FavoritesRepo {
  final FavoritesDataSource favoritesDataSource;
  FavoritesRepoImpl(this.favoritesDataSource);

  @override
  List<AudioFileModel> getAllAudioFilesFromFavorite() {
    return favoritesDataSource.getAllAudioFilesFromFavorite();
  }
}