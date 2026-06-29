// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:pdfx/pdfx.dart' as pdfx;

class HomeApi {
  File pdfFile = File('');
  int pagesCount = 0;
  List<String> extractedText = [];
  // Future<PdfDetailsModel?> pickPdf() async {
  //   try {
  //     final result = await FilePicker.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //       withData: true,
  //     );
  //     if (result == null || result.files.isEmpty) return null;
  //     final file = result.files.single;

  //     // Get bytes (prefer bytes; else read from path)
  //     Uint8List bytes;
  //     if (file.bytes != null) {
  //       bytes = file.bytes!;
  //     } else if (file.path != null) {
  //       bytes = await File(file.path!).readAsBytes();
  //     } else {
  //       throw Exception("Couldn't access picked PDF (no bytes and no path).");
  //     }

  //     PdfDocument? document;
  //     try {
  //       document = PdfDocument(inputBytes: bytes);

  //       final info = document.documentInformation;
  //       final title = (info.title).trim();
  //       final author = (info.author).trim();

  //       return PdfDetailsModel(
  //         title: title.isNotEmpty ? title : file.name, // fallback to filename
  //         author: author.isNotEmpty ? author : null,
  //         pageCount: document.pages.count,
  //       );
  //     } finally {
  //       document?.dispose();
  //     }
  //   } catch (e) {
  //     throw Exception('Error picking PDF file: $e');
  //   }
  // }
  Future<Uint8List> _readAllFromStream(Stream<List<int>> stream) async {
    final chunks = <int>[];
    await for (final c in stream) {
      chunks.addAll(c);
    }
    return Uint8List.fromList(chunks);
  }

  Future<PdfDetailsModel?> pickPdf() async {
    // Use stream to avoid "unknown_path" issues
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withReadStream: true,
      // (optional) withData: true, // don’t use both for very large files
    );

    if (result == null || result.files.isEmpty) return null;

    final pdf = result.files.single;
    pdfFile = File(pdf.path ?? '');

    Uint8List bytes;
    if (pdf.bytes != null) {
      bytes = pdf.bytes!;
    } else if (pdf.readStream != null) {
      bytes = await _readAllFromStream(pdf.readStream!);
    } else if (pdf.path != null) {
      bytes = await File(pdf.path!).readAsBytes();
    } else {
      throw Exception("Picked PDF can't be accessed (no bytes/stream/path).");
    }

    final document = await pdfx.PdfDocument.openData(bytes);
    final page = await document.getPage(1);

    final pageImage = await page.render(
      width: page.width * 4,
      height: page.height * 4,
      format: pdfx.PdfPageImageFormat.png,
    );

    sf.PdfDocument? doc;
    try {
      doc = sf.PdfDocument(inputBytes: bytes);
      pagesCount = doc.pages.count;

      final info = doc.documentInformation;
      final title = (info.title).trim();
      final author = (info.author).trim();

      return PdfDetailsModel(
        pdfBytes: bytes,
        coverImageBytes: pageImage?.bytes ?? Uint8List(0),
        title: title.isNotEmpty ? title : pdf.name, // fallback to filename
        author: author.isNotEmpty ? author : null,
        pageCount: doc.pages.count,
      );
    } finally {
      doc?.dispose();
    }
  }

  // Future<List<String>> processPdf() async {
  //   if (!await pdfFile.exists()) {
  //     throw Exception('Failed to process PDF: file not found.');
  //   }

  //   final bytes = await pdfFile.readAsBytes();
  //   if (bytes.isEmpty) {
  //     throw Exception('Failed to process PDF: file is empty.');
  //   }

  //   // return ocrFirstPageFromPdfBytes(bytes);
  //   for (var page = 1; page <= pagesCount; page++) {
  //     final bytes = await pdfFile.readAsBytes();
  //     final text = ocrFirstPageFromPdfBytes(currentPage: page, pdfBytes: bytes);
  //     extractedText.add(await text);
  //   }
  //   return extractedText;
  // }

  Future<void> speakArabic({
    required FlutterTts tts,
    required String text,
  }) async {
    await tts.setLanguage('ar'); // or 'ar-SA', 'ar-EG', etc.
    await tts.setSpeechRate(0.45); // 0.0 - 1.0 (varies by platform)
    await tts.setPitch(1.0);
    await tts.getVoices.then((data) {
      List<Map> voices = List<Map>.from(data);
      voices = voices.where((voice) => voice['name'].contains('ar')).toList();
      debugPrint('Available Arabic voices: $voices');
    });
    await tts.setVoice({
      'name': 'ar-xa-x-ard-local',
      'locale': 'ar',
    }); // or any available Arabic voice
    await tts.speak(text);
  }

  Future<File> createAudioFile({
    required FlutterTts tts,
    required String text,
    required String fileName,
  }) async {
    await tts.setLanguage('ar');
    await tts.setVoice({
      'name': 'ar-xa-x-ard-local',
      'locale': 'ar',
    });
    await tts.awaitSynthCompletion(true);

    final safe = fileName
        .replaceAll('.pdf', '')
        .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_');

    final outName = '$safe.mp3'; // ONLY name, no path
    final result = await tts.synthesizeToFile(
      text,
      outName,
    );

    final fullPath = '/storage/emulated/0/Music/$outName';
    final file = File(fullPath);

    if (!await file.exists()) {
      throw Exception('synthesizeToFile failed. result=$result path=$fullPath');
    }
    return file;
    // await tts.awaitSynthCompletion(true);

    // final safe = fileName
    //     .replaceAll('.pdf', '')
    //     .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_');

    // // Many Android TTS engines output WAV/PCM; use .wav to avoid surprises.
    // final outName = '$safe.mp3';

    // final baseDir = await getExternalStorageDirectory();
    // final outDir = Directory(p.join(baseDir!.path, 'tts'));
    // await outDir.create(recursive: true);

    // final fullPath = p.join(outDir.path, outName);

    // final result = await tts.synthesizeToFile(text, fullPath, true);

    // final file = File(fullPath);
    // if (!await file.exists()) {
    //   throw Exception('synthesizeToFile failed. result=$result path=$fullPath');
    // }
    // return file;
    // مهم: بعض الأجهزة لا تُطلق completion بشكل موثوق، لذلك نستخدم polling أيضًا
    // final completer = Completer<void>();
    // tts.setCompletionHandler(() {
    //   if (!completer.isCompleted) completer.complete();
    // });
    // tts.setErrorHandler((msg) {
    //   if (!completer.isCompleted) completer.completeError(Exception(msg));
    // });

    // // جرّب اسم ملف ASCII لتفادي مشاكل بعض محركات TTS مع العربية
    // final outName = '${DateTime.now().millisecondsSinceEpoch}.wav';

    // final baseDir = await getApplicationDocumentsDirectory();
    // final outDir = Directory(p.join(baseDir.path));
    // await outDir.create(recursive: true);

    // final fullPath = p.join(outDir.path, outName);

    // final result = await tts.synthesizeToFile(text, fullPath, true);

    // // في Android: 0 = SUCCESS, -1 = ERROR
    // if (result != 0) {
    //   throw Exception('synthesizeToFile returned $result path=$fullPath');
    // }

    // // انتظر completion (لو اشتغل) لكن لا تعتمد عليه وحده
    // try {
    //   await completer.future.timeout(const Duration(seconds: 20));
    // } catch (_) {}

    // final file = File(fullPath);

    // // Polling حتى يظهر الملف ويصبح حجمه > 0
    // for (int i = 0; i < 60; i++) {
    //   if (await file.exists()) {
    //     final len = await file.length();
    //     if (len > 0) return file;
    //   }
    //   await Future.delayed(const Duration(milliseconds: 250));
    // }

    // throw Exception(
    //   'File not created (or empty). result=$result path=$fullPath',
    // );
    // await tts.awaitSynthCompletion(true);

    // final base = await getExternalStorageDirectory();
    // // This is: /storage/emulated/0/Android/data/<package>/files
    // final ttsDir = Directory(p.join(base!.path, 'tts'));
    // await ttsDir.create(recursive: true);

    // // Use a safe ASCII name (some engines fail with Arabic filenames)
    // final safe = fileName
    //     .replaceAll('.pdf', '')
    //     .replaceAll(RegExp(r'[^\w\-]+'), '_');

    // final fullPath = p.join(
    //   ttsDir.path,
    //   '$safe.wav',
    // ); // use .wav for Android TTS
    // final result = await tts.synthesizeToFile(text, fullPath, true);

    // final file = File(fullPath);

    // // synthesizeToFile may return before the file is fully written, so wait a bit
    // for (int i = 0; i < 60; i++) {
    //   if (await file.exists() && await file.length() > 0) return file;
    //   await Future.delayed(const Duration(milliseconds: 250));
    // }

    // throw Exception(
    //   'Failed to create audio file. result=$result path=$fullPath',
    // );
  }
}
