import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class CreateAudioFileUseCase {
  final HomeRepo homeRepo;
  CreateAudioFileUseCase(this.homeRepo);

  Future<File> call({required FlutterTts tts, required String text, required String fileName}) {
    return homeRepo.createAudioFile(tts: tts, text: text, fileName: fileName);
  }
}