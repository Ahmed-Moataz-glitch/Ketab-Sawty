import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo_hive.dart';

class SaveAudioFileUseCase {
  final HomeRepoHive homeRepoHive;
  SaveAudioFileUseCase(this.homeRepoHive);

  Future<void> call(AudioFileModel audioFile) {
    return homeRepoHive.saveAudioFile(audioFile);
  }
}