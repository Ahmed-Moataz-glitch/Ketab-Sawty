import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeDataSource homeDataSource;
  HomeRepoImpl(this.homeDataSource);
  @override
  Future<PdfDetailsModel?> pickPdf() async {
    return await homeDataSource.pickPdf();
  }
  
  @override
  Future<void> speakArabic({required FlutterTts tts, required String currentVoice, required String text}) async {
    return await homeDataSource.speakArabic(tts: tts, currentVoice: currentVoice, text: text);
  }

  @override
  Future<File> createAudioFile({required FlutterTts tts, required String text, required String fileName}) async {
    return await homeDataSource.createAudioFile(tts: tts, text: text, fileName: fileName);
  }
  
  @override
  Future<bool> isAudioFileExists(String fileName) async {
    return await homeDataSource.isAudioFileExists(fileName);
  }

  @override
  Future<List<XFile>> captureBookPages(BuildContext context) async {
    return await homeDataSource.captureBookPages(context);
  }
  
  @override
  Future<PdfDetailsModel> createPdfFromCapturedImages(List<XFile> images) async {
    return await homeDataSource.createPdfFromCapturedImages(images);
  }
}