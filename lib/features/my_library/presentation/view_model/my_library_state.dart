part of 'my_library_cubit.dart';

sealed class MyLibraryState {}

final class MyLibraryInitial extends MyLibraryState {}

final class GetAllAudioFilesFromSavedSuccess extends MyLibraryState {
  final List<AudioFileModel> audioFiles;
  GetAllAudioFilesFromSavedSuccess(this.audioFiles);
}
