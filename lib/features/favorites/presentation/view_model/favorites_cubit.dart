import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/favorites/domain/use_cases/get_all_audio_files_from_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetAllAudioFilesFromFavoriteUseCase getAllAudioFilesFromFavoriteUseCase;
  StreamSubscription<BoxEvent>? _boxSubscription;

  FavoritesCubit(
    this.getAllAudioFilesFromFavoriteUseCase,
  ) : super(FavoritesInitial()) {
    _initWatcher();
  }

  void _initWatcher() {
    try {
      if (Hive.isBoxOpen(AppConstants.favoriteAudioFilesBox)) {
        _boxSubscription = Hive.box<AudioFileModel>(AppConstants.favoriteAudioFilesBox)
            .watch()
            .listen((_) {
          if (!isClosed) {
            getAllAudioFilesFromFavorite();
          }
        });
      }
    } catch (_) {}
  }

  void getAllAudioFilesFromFavorite() {
    final audioFiles = getAllAudioFilesFromFavoriteUseCase.call();
    emit(GetAllAudioFilesFromFavoriteSuccess(audioFiles));
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
