part of 'favorites_cubit.dart';

sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class GetAllAudioFilesFromFavoriteSuccess extends FavoritesState {
  final List<AudioFileModel> audioFiles;
  GetAllAudioFilesFromFavoriteSuccess(this.audioFiles);
}
