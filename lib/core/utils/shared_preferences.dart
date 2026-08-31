
import 'package:ketab_sawty/core/view_model/language_cubit/language_cubit.dart';
import 'package:ketab_sawty/core/view_model/theme_cubit/theme_cubit.dart';
import 'package:ketab_sawty/core/view_model/voice_cubit/voice_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlutterSharedPreferences {
  FlutterSharedPreferences._();
  static final FlutterSharedPreferences instance = FlutterSharedPreferences._();
  static final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();
  final voiceKey = 'voice';
  final themeModeKey = 'themeMode';
  final languageKey = 'language';

  Future<SharedPreferences> get() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveThemeMode(ThemeModeState themeMode) async {
    final prefs = await _sharedPreferences;
    prefs.setString(themeModeKey, themeMode.toString());
  }

  Future<ThemeModeState> getThemeMode() async {
    final prefs = await _sharedPreferences;
    final themeMode = prefs.getString(themeModeKey);
    if (themeMode != null) {
      return ThemeModeState.values.firstWhere(
        (e) => e.toString() == themeMode,
        orElse: () => ThemeModeState.system,
      );
    }
    return ThemeModeState.system;
  }

  Future<void> removeThemeMode() async {
    final prefs = await _sharedPreferences;
    await prefs.remove(themeModeKey);
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await _sharedPreferences;
    prefs.setString(languageKey, language);
  }

  Future<LanguageModeState> getLanguage() async {
    final prefs = await _sharedPreferences;
    final language = prefs.getString(languageKey);
    if (language != null) {
      return LanguageModeState.values.firstWhere(
        (e) => e.toString() == language,
        orElse: () => LanguageModeState.english,
      );
    }
    return LanguageModeState.english;
  }

  Future<void> removeLanguage() async {
    final prefs = await _sharedPreferences;
    await prefs.remove(languageKey);
  }

  Future<void> saveVoice(String voice) async {
    final prefs = await _sharedPreferences;
    prefs.setString(voiceKey, voice);
  }

  Future<VoiceModeState> getVoice() async {
    final prefs = await _sharedPreferences;
    final voice = prefs.getString(voiceKey);
    if (voice != null) {
      return VoiceModeState.values.firstWhere(
        (e) => e.toString() == voice,
        orElse: () => VoiceModeState.voice1,
      );
    }
    return VoiceModeState.voice1;
  }

  Future<void> removeVoice() async {
    final prefs = await _sharedPreferences;
    await prefs.remove(voiceKey);
  }
}