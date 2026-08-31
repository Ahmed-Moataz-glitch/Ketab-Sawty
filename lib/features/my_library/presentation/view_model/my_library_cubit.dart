import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/my_library/domain/use_cases/get_all_audio_files_from_saved_use_case.dart';

part 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  final GetAllAudioFilesFromSavedUseCase getAllAudioFilesFromSavedUseCase;
  MyLibraryCubit(
    this.getAllAudioFilesFromSavedUseCase,
  ) : super(MyLibraryInitial());

  void getAllAudioFilesFromSaved() {
    final audioFiles = getAllAudioFilesFromSavedUseCase.call();
    emit(GetAllAudioFilesFromSavedSuccess(audioFiles));
  }
}
