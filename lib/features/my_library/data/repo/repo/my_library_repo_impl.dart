import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/data_source/my_library_data_source.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/repo/my_library_repo.dart';

class MyLibraryRepoImpl extends MyLibraryRepo {
  final MyLibraryDataSource myLibraryDataSource;
  MyLibraryRepoImpl(this.myLibraryDataSource);

  @override
  List<AudioFileModel> getAllAudioFilesFromSaved() {
    return myLibraryDataSource.getAllAudioFilesFromSaved();
  }

  
}