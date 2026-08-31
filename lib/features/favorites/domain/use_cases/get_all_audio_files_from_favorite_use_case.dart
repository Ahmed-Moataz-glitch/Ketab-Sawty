import 'package:ketab_sawty/features/favorites/domain/repo/repo/favorites_repo.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

class GetAllAudioFilesFromFavoriteUseCase {
  final FavoritesRepo favoritesRepo;
  GetAllAudioFilesFromFavoriteUseCase(this.favoritesRepo);

  List<AudioFileModel> call() {
    return favoritesRepo.getAllAudioFilesFromFavorite();
  }
}