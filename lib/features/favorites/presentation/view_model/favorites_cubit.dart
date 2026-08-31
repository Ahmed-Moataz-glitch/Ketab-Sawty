import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketab_sawty/features/favorites/domain/use_cases/get_all_audio_files_from_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetAllAudioFilesFromFavoriteUseCase getAllAudioFilesFromFavoriteUseCase;
  FavoritesCubit(
    this.getAllAudioFilesFromFavoriteUseCase,
  ) : super(FavoritesInitial());

  void getAllAudioFilesFromFavorite() {
    final audioFiles = getAllAudioFilesFromFavoriteUseCase.call();
    emit(GetAllAudioFilesFromFavoriteSuccess(audioFiles));
  }
}
