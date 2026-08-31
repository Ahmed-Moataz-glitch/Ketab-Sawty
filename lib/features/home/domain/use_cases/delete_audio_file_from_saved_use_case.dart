import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo_hive.dart';

class DeleteAudioFileFromSavedUseCase {
  final HomeRepoHive homeRepoHive;
  DeleteAudioFileFromSavedUseCase(this.homeRepoHive);

  Future<void> call(String id) {
    return homeRepoHive.deleteAudioFileFromSaved(id);
  }
}