import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class IsAudioFileExistsUseCase {
  final HomeRepo homeRepo;
  IsAudioFileExistsUseCase(this.homeRepo);

  Future<bool> call(String fileName) {
    return homeRepo.isAudioFileExists(fileName);
  }
}