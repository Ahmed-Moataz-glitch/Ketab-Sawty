import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketab_sawty/core/utils/shared_preferences.dart';

part 'theme_state.dart';

enum ThemeModeState{
  light,
  dark,
  system,
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()){
    loadTheme();
  }

  ThemeModeState currentThemeMode = ThemeModeState.system;

  static ThemeCubit get(BuildContext context) => BlocProvider.of<ThemeCubit>(context);

  Future<void> selectTheme(ThemeModeState themeMode) async {
    currentThemeMode = themeMode;
    await FlutterSharedPreferences.instance.saveThemeMode(themeMode);
    emit(ThemeModeChanged());
  }

  ThemeMode getTheme(){
    switch (currentThemeMode) {
      case ThemeModeState.light:
        return ThemeMode.light;
      case ThemeModeState.dark:
        return ThemeMode.dark;
      case ThemeModeState.system:
        return ThemeMode.system;
    }
  }

  Future<void> loadTheme() async {
    final themeMode = await FlutterSharedPreferences.instance.getThemeMode();
    currentThemeMode = themeMode;
    emit(ThemeModeChanged());
  }
}
