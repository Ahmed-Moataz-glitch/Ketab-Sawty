import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/my_library/domain/use_cases/get_all_audio_files_from_saved_use_case.dart';

part 'my_library_state.dart';

class MyLibraryCubit extends Cubit<MyLibraryState> {
  final GetAllAudioFilesFromSavedUseCase getAllAudioFilesFromSavedUseCase;
  StreamSubscription<BoxEvent>? _boxSubscription;

  MyLibraryCubit(
    this.getAllAudioFilesFromSavedUseCase,
  ) : super(MyLibraryInitial()) {
    _initWatcher();
  }

  void _initWatcher() {
    try {
      if (Hive.isBoxOpen(AppConstants.savedAudioFilesBox)) {
        _boxSubscription = Hive.box<AudioFileModel>(AppConstants.savedAudioFilesBox)
            .watch()
            .listen((_) {
          if (!isClosed) {
            getAllAudioFilesFromSaved();
          }
        });
      }
    } catch (_) {}
  }

  void getAllAudioFilesFromSaved() {
    final audioFiles = getAllAudioFilesFromSavedUseCase.call();
    emit(GetAllAudioFilesFromSavedSuccess(audioFiles));
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
