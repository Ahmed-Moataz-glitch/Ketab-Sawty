import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';

abstract class HomeRepo {
  Future<PdfDetailsModel?> pickPdf();

  // Future<List<String>> processPdf();

  Future<void> speakArabic({required FlutterTts tts, required String text});

  Future<File> createAudioFile({
    required FlutterTts tts,
    required String text,
    required String fileName,
  });
}
