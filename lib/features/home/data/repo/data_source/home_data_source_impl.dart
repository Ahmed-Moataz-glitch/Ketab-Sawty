import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:ketab_sawty/features/home/data/api/home_api.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/data_source/home_data_source.dart';

class HomeDataSourceImpl extends HomeDataSource {
  final HomeApi homeApi;
  HomeDataSourceImpl(this.homeApi);
  @override
  Future<PdfDetailsModel?> pickPdf() async {
    return await homeApi.pickPdf();
  }
  
  // @override
  // Future<List<String>> processPdf() async {
  //   return await homeApi.processPdf();
  // }
  
  @override
  Future<void> speakArabic({required FlutterTts tts, required String text}) async {
    return await homeApi.speakArabic(tts: tts, text: text);
  }

  @override
  Future<File> createAudioFile({required FlutterTts tts, required String text, required String fileName}) async {
    return await homeApi.createAudioFile(tts: tts, text: text, fileName: fileName);
  }
}