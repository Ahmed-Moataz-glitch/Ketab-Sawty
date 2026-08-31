import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketab_sawty/core/utils/shared_preferences.dart';

part 'language_state.dart';

enum LanguageModeState{
  arabic,
  english,
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial()){
    loadLanguage();
  }

  LanguageModeState currentLanguage = LanguageModeState.arabic;

  static LanguageCubit get(BuildContext context) => BlocProvider.of<LanguageCubit>(context);

  Future<void> selectLanguage(LanguageModeState language) async {
    currentLanguage = language;
    await FlutterSharedPreferences.instance.saveLanguage(language.toString());
    emit(LanguageChanged());
  }

  String getLanguage(){
    switch (currentLanguage) {
      case LanguageModeState.arabic:
        return 'ar';
      case LanguageModeState.english:
        return 'en';
    }
  }

  Future<void> loadLanguage() async {
    final language = await FlutterSharedPreferences.instance.getLanguage();
    currentLanguage = language;
    emit(LanguageChanged());
  }
}
