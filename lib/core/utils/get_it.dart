import 'package:get_it/get_it.dart';
import 'package:ketab_sawty/features/favorites/data/hive/hive_services.dart'
    as favorites_hive_services;
import 'package:ketab_sawty/features/favorites/data/repo/data_source/favorites_data_source_impl.dart';
import 'package:ketab_sawty/features/favorites/data/repo/repo/favorites_repo_impl.dart';
import 'package:ketab_sawty/features/favorites/domain/repo/data_source/favorites_data_source.dart';
import 'package:ketab_sawty/features/favorites/domain/repo/repo/favorites_repo.dart';
import 'package:ketab_sawty/features/favorites/domain/use_cases/get_all_audio_files_from_favorite_use_case.dart';
import 'package:ketab_sawty/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:ketab_sawty/features/home/data/api/home_api.dart';
import 'package:ketab_sawty/features/home/data/hive/hive_services.dart'
    as home_hive_services;
import 'package:ketab_sawty/features/home/data/repo/data_source/home_data_source_hive_impl.dart';
import 'package:ketab_sawty/features/home/data/repo/data_source/home_data_source_impl.dart';
import 'package:ketab_sawty/features/home/data/repo/repo/home_repo_hive_impl.dart';
import 'package:ketab_sawty/features/home/data/repo/repo/home_repo_impl.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source_hive.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo_hive.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/add_audio_file_to_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/capture_book_pages_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/create_audio_file_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/create_pdf_from_captured_images_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/delete_audio_file_from_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/delete_audio_file_from_saved_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/is_audio_file_exists_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/pick_pdf_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/save_audio_file_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/speak_arabic_use_case.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/my_library/data/hive/hive_services.dart'
    as my_library_hive_services;
import 'package:ketab_sawty/features/my_library/data/repo/data_source/my_library_data_source_impl.dart';
import 'package:ketab_sawty/features/my_library/data/repo/repo/my_library_repo_impl.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/data_source/my_library_data_source.dart';
import 'package:ketab_sawty/features/my_library/domain/repo/repo/my_library_repo.dart';
import 'package:ketab_sawty/features/my_library/domain/use_cases/get_all_audio_files_from_saved_use_case.dart';
import 'package:ketab_sawty/features/my_library/presentation/view_model/my_library_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton<home_hive_services.HiveServices>(
    home_hive_services.HiveServices(),
  );
  getIt.registerSingleton<HomeDataSourceHive>(
    HomeDataSourceHiveImpl(getIt<home_hive_services.HiveServices>()),
  );
  getIt.registerSingleton<HomeRepoHive>(
    HomeRepoHiveImpl(getIt<HomeDataSourceHive>()),
  );
  getIt.registerSingleton<AddAudioFileToFavoriteUseCase>(
    AddAudioFileToFavoriteUseCase(getIt<HomeRepoHive>()),
  );
  getIt.registerSingleton<DeleteAudioFileFromFavoriteUseCase>(
    DeleteAudioFileFromFavoriteUseCase(getIt<HomeRepoHive>()),
  );
  getIt.registerSingleton<SaveAudioFileUseCase>(
    SaveAudioFileUseCase(getIt<HomeRepoHive>()),
  );
  getIt.registerSingleton<DeleteAudioFileFromSavedUseCase>(
    DeleteAudioFileFromSavedUseCase(getIt<HomeRepoHive>()),
  );
  getIt.registerSingleton<HomeApi>(HomeApi());
  getIt.registerSingleton<HomeDataSource>(HomeDataSourceImpl(getIt<HomeApi>()));
  getIt.registerSingleton<HomeRepo>(HomeRepoImpl(getIt<HomeDataSource>()));
  getIt.registerSingleton<PickPdfUseCase>(PickPdfUseCase(getIt<HomeRepo>()));
  getIt.registerSingleton<CaptureBookPagesUseCase>(
    CaptureBookPagesUseCase(getIt<HomeRepo>()),
  );
  getIt.registerSingleton<CreateAudioFileUseCase>(
    CreateAudioFileUseCase(getIt<HomeRepo>()),
  );
  getIt.registerSingleton<CreatePdfFromCapturedImagesUseCase>(
    CreatePdfFromCapturedImagesUseCase(getIt<HomeRepo>()),
  );
  getIt.registerSingleton<IsAudioFileExistsUseCase>(
    IsAudioFileExistsUseCase(getIt<HomeRepo>()),
  );
  getIt.registerSingleton<SpeakArabicUseCase>(
    SpeakArabicUseCase(getIt<HomeRepo>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      pickPdfUseCase: getIt<PickPdfUseCase>(),
      captureBookPagesUseCase: getIt<CaptureBookPagesUseCase>(),
      createAudioFileUseCase: getIt<CreateAudioFileUseCase>(),
      createPdfFromCapturedImagesUseCase:
          getIt<CreatePdfFromCapturedImagesUseCase>(),
      addAudioFileToFavoriteUseCase: getIt<AddAudioFileToFavoriteUseCase>(),
      deleteAudioFileFromFavoriteUseCase:
          getIt<DeleteAudioFileFromFavoriteUseCase>(),
      saveAudioFileUseCase: getIt<SaveAudioFileUseCase>(),
      deleteAudioFileFromSavedUseCase: getIt<DeleteAudioFileFromSavedUseCase>(),
      isAudioFileExistsUseCase: getIt<IsAudioFileExistsUseCase>(),
      speakArabicUseCase: getIt<SpeakArabicUseCase>(),
    ),
  );

  getIt.registerSingleton<favorites_hive_services.HiveServices>(
    favorites_hive_services.HiveServices(),
  );
  getIt.registerSingleton<FavoritesDataSource>(
    FavoritesDataSourceImpl(getIt<favorites_hive_services.HiveServices>()),
  );
  getIt.registerSingleton<FavoritesRepo>(
    FavoritesRepoImpl(getIt<FavoritesDataSource>()),
  );
  getIt.registerSingleton<GetAllAudioFilesFromFavoriteUseCase>(
    GetAllAudioFilesFromFavoriteUseCase(getIt<FavoritesRepo>()),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(getIt<GetAllAudioFilesFromFavoriteUseCase>()),
  );

  getIt.registerSingleton<my_library_hive_services.HiveServices>(
    my_library_hive_services.HiveServices(),
  );
  getIt.registerSingleton<MyLibraryDataSource>(
    MyLibraryDataSourceImpl(getIt<my_library_hive_services.HiveServices>()),
  );
  getIt.registerSingleton<MyLibraryRepo>(
    MyLibraryRepoImpl(getIt<MyLibraryDataSource>()),
  );
  getIt.registerSingleton<GetAllAudioFilesFromSavedUseCase>(
    GetAllAudioFilesFromSavedUseCase(getIt<MyLibraryRepo>()),
  );
  getIt.registerFactory<MyLibraryCubit>(
    () => MyLibraryCubit(getIt<GetAllAudioFilesFromSavedUseCase>()),
  );
}
