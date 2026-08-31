import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

abstract class FavoritesRepo {
  List<AudioFileModel> getAllAudioFilesFromFavorite();
}