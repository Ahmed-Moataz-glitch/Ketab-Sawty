import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo_hive.dart';

class DeleteAudioFileFromFavoriteUseCase {
  final HomeRepoHive homeRepoHive;
  DeleteAudioFileFromFavoriteUseCase(this.homeRepoHive);

  Future<void> call(String id) {
    return homeRepoHive.deleteAudioFileFromFavorite(id);
  }
}