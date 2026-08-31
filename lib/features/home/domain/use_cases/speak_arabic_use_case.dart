import 'package:flutter_tts/flutter_tts.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class SpeakArabicUseCase {
  final HomeRepo homeRepo;
  SpeakArabicUseCase(this.homeRepo);

  Future<void> call({required FlutterTts tts, required String currentVoice, required String text}) async {
    return homeRepo.speakArabic(tts: tts, currentVoice: currentVoice, text: text);
  }
}