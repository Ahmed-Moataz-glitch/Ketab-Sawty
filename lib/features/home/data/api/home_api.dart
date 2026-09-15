// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view/widgets/custom_button_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pdf_combiner/models/merge_input.dart';
import 'package:pdf_combiner/models/pdf_from_multiple_image_config.dart';
import 'package:pdf_combiner/pdf_combiner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:pdfx/pdfx.dart' as pdfx;

class HomeApi {
  File pdfFile = File('');
  int pagesCount = 0;
  List<String> extractedText = [];
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final ImagePicker imagePicker = ImagePicker();

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

  //   final compressedPdf = await compressPdf(
  //   pdfFile,
  //   thresholdSize: 500 * 1024, // Optional: 500 KB
  //   quality: 60,               // Optional: 0 (most compression) to 100 (lowest compression)
  // );

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
        id: title
            .replaceAll('.pdf', '')
            .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_'),
        pdfBytes: bytes,
        coverImageBytes: pageImage?.bytes ?? Uint8List(0),
        title: title.isNotEmpty ? title : pdf.name.replaceAll('.pdf', ''), // fallback to filename
        author: author.isNotEmpty ? author : null,
        pageCount: doc.pages.count,
      );
    } finally {
      doc?.dispose();
    }
  }

  Future<List<XFile>> captureBookPages(BuildContext context) async {
    final List<XFile> pages = [];

    while (true) {
      final XFile? photo = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) break; // user cancelled camera
      pages.add(photo);

      // Ask if they want another page (simple dialog)
      final bool addMore =
          await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'إضافة صفحة أخرى ؟',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              actions: [
                Row(
                  children: [
                    CustomButtonWidget(
                      title: 'لا',
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    const Spacer(),
                    CustomButtonWidget(
                      title: 'نعم',
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ],
            ),
          ) ??
          false;

      if (!addMore) break;
    }
    return pages;
  }

  // Future<PdfDetailsModel> createPdfFromCapturedImages(List<XFile> images) async {
  //   String response = await PdfCombiner.createPDFFromMultipleImages(
  //     inputs: images.map((image) => MergeInput.path(image.path)).toList(),
  //     outputPath: '/storage/emulated/0/Documents/${DateTime.now().millisecondsSinceEpoch}.pdf',
  //     config: const PdfFromMultipleImageConfig(
  //       keepAspectRatio: true,
  //     ),
  //   );
  //   final pdf = PlatformFile(path: response, name: '${DateTime.now().millisecondsSinceEpoch}.pdf', size: await File(response).length());
  //   Uint8List bytes;
  //   if (pdf.bytes != null) {
  //     bytes = pdf.bytes!;
  //   } else if (pdf.readStream != null) {
  //     bytes = await _readAllFromStream(pdf.readStream!);
  //   } else if (pdf.path != null) {
  //     bytes = await File(response).readAsBytes();
  //   } else {
  //     throw Exception("Picked PDF can't be accessed (no bytes/stream/path).");
  //   }

  //   final document = await pdfx.PdfDocument.openData(bytes);
  //   final page = await document.getPage(1);

  //   final pageImage = await page.render(
  //     width: page.width * 4,
  //     height: page.height * 4,
  //     format: pdfx.PdfPageImageFormat.png,
  //   );

  //   sf.PdfDocument? doc;
  //   try {
  //     doc = sf.PdfDocument(inputBytes: bytes);
  //     pagesCount = doc.pages.count;

  //     final info = doc.documentInformation;
  //     final title = (info.title).trim();
  //     final author = (info.author).trim();

  //     return PdfDetailsModel(
  //       id: title
  //           .replaceAll('.pdf', '')
  //           .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_'),
  //       pdfBytes: bytes,
  //       coverImageBytes: pageImage?.bytes ?? Uint8List(0),
  //       title: title.isNotEmpty ? title : pdf.name, // fallback to filename
  //       author: author.isNotEmpty ? author : null,
  //       pageCount: doc.pages.count,
  //     );
  //   } finally {
  //     doc?.dispose();
  //   }
  // }

  Future<PdfDetailsModel> createPdfFromCapturedImages(
    List<XFile> images,
  ) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final dir = await getApplicationDocumentsDirectory();
    final outputPath = '${dir.path}/$ts.pdf';

    final responsePath = await PdfCombiner.createPDFFromMultipleImages(
      inputs: images.map((e) => MergeInput.path(e.path)).toList(),
      outputPath: outputPath,
      config: const PdfFromMultipleImageConfig(keepAspectRatio: true),
    );

    final bytes = await File(responsePath).readAsBytes();

    // Render cover image (pdfx) + ensure closing
    final pdfxDoc = await pdfx.PdfDocument.openData(bytes);
    final pdfxPage = await pdfxDoc.getPage(1);
    final pageImage = await pdfxPage.render(
      width: pdfxPage.width * 4,
      height: pdfxPage.height * 4,
      format: pdfx.PdfPageImageFormat.png,
    );
    await pdfxPage.close();
    await pdfxDoc.close();

    // Read metadata/page count (Syncfusion)
    final sfDoc = sf.PdfDocument(inputBytes: bytes);
    try {
      final info = sfDoc.documentInformation;
      final title = info.title.trim();
      final author = info.author.trim();

      final fileName = '$ts';
      final effectiveTitle = title.isNotEmpty ? title : fileName;

      return PdfDetailsModel(
        id: effectiveTitle
            .replaceAll('.pdf', '')
            .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_'),
        pdfBytes: bytes,
        coverImageBytes: pageImage?.bytes ?? Uint8List(0),
        title: effectiveTitle,
        author: author.isNotEmpty ? author : null,
        pageCount: pdfxDoc.pagesCount,
      );
    } finally {
      sfDoc.dispose();
    }
  }

  Future<void> speakArabic({
    required FlutterTts tts,
    required String currentVoice,
    required String text,
  }) async {
    await tts.setLanguage('ar'); // always guarantee Arabic locale
    if (currentVoice.isNotEmpty) {
      try {
        await tts.setVoice({
          'name': currentVoice,
          'locale': 'ar',
        });
      } catch (e) {
        debugPrint('Failed to set specific voice $currentVoice: $e');
      }
    }
    await tts.setSpeechRate(0.45); // 0.0 - 1.0 (varies by platform)
    await tts.setPitch(1.0);
    debugPrint('Using voice: $currentVoice');
    await tts.speak(text);
  }

  Future<File> createAudioFile({
    required FlutterTts tts,
    required String text,
    required String fileName,
    String? currentVoice,
  }) async {
    await tts.setLanguage('ar');
    if (currentVoice != null && currentVoice.isNotEmpty) {
      try {
        await tts.setVoice({'name': currentVoice, 'locale': 'ar'});
      } catch (e) {
        debugPrint('Failed to set voice in createAudioFile: $e');
      }
    }
    await tts.awaitSynthCompletion(true);

    final dir = await getApplicationDocumentsDirectory();
    final safe = fileName
        .replaceAll('.pdf', '')
        .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_');

    final wavPath = '${dir.path}/$safe.wav';
    final wavFile = File(wavPath);
    await tts.synthesizeToFile(text, wavPath, true);

    if (await wavFile.exists()) {
      return wavFile;
    }

    // Check if synthesized with relative name or .mp3
    final altWav = File('${dir.path}/$safe.wav');
    if (await altWav.exists()) return altWav;
    final altMp3 = File('${dir.path}/$safe.mp3');
    if (await altMp3.exists()) return altMp3;

    await Future.delayed(const Duration(milliseconds: 300));
    return wavFile;
  }

  Future<bool> isAudioFileExists(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final safe = fileName
        .replaceAll('.pdf', '')
        .replaceAll(RegExp(r'[^\w\u0600-\u06FF\-]+'), '_');

    final wavFile = File('${dir.path}/$safe.wav');
    if (await wavFile.exists()) return true;

    final mp3File = File('${dir.path}/$safe.mp3');
    if (await mp3File.exists()) return true;

    // Check legacy storage path if previously generated
    final legacyFile = File('/storage/emulated/0/Music/$safe.mp3');
    if (await legacyFile.exists()) return true;

    return false;
  }
}
