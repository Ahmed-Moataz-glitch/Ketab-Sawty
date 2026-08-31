import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/my_library/data/hive/hive_services.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/data_source/my_library_data_source.dart';

class MyLibraryDataSourceImpl extends MyLibraryDataSource {
  final HiveServices hiveServices;
  MyLibraryDataSourceImpl(this.hiveServices);

  @override
  List<AudioFileModel> getAllAudioFilesFromSaved() {
    return hiveServices.getAllAudioFilesFromSaved();
  }

  
}