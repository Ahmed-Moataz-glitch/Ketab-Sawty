import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
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
  
  // @override
  // Future<List<String>> processPdf() async {
  //   return await homeDataSource.processPdf();
  // }
  
  @override
  Future<void> speakArabic({required FlutterTts tts, required String text}) async {
    return await homeDataSource.speakArabic(tts: tts, text: text);
  }

  @override
  Future<File> createAudioFile({required FlutterTts tts, required String text, required String fileName}) async {
    return await homeDataSource.createAudioFile(tts: tts, text: text, fileName: fileName);
  }
}