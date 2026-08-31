import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';

abstract class HomeDataSource {
  Future<PdfDetailsModel?> pickPdf();

  Future<List<XFile>> captureBookPages(BuildContext context);

  Future<PdfDetailsModel> createPdfFromCapturedImages(List<XFile> images);

  Future<void> speakArabic({required FlutterTts tts, required String currentVoice, required String text});

  Future<File> createAudioFile({
    required FlutterTts tts,
    required String text,
    required String fileName,
  });

  Future<bool> isAudioFileExists(String fileName);
}
