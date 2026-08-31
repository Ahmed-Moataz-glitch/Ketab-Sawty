import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/repo/my_library_repo.dart';

class GetAllAudioFilesFromSavedUseCase {
  final MyLibraryRepo myLibraryRepo;
  GetAllAudioFilesFromSavedUseCase(this.myLibraryRepo);
  List<AudioFileModel> call() {
    return myLibraryRepo.getAllAudioFilesFromSaved();
  }
}