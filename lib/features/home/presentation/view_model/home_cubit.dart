import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/add_audio_file_to_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/capture_book_pages_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/create_audio_file_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/create_pdf_from_captured_images_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/delete_audio_file_from_favorite_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/delete_audio_file_from_saved_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/is_audio_file_exists_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/pick_pdf_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/save_audio_file_use_case.dart';
import 'package:ketab_sawty/features/home/domain/use_cases/speak_arabic_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FlutterTts tts = FlutterTts();
  String currentVoice = '';
  int currentWordStartIndex = 0;
  int currentWordEndIndex = 0;
  bool _progressBound = false;
  final PickPdfUseCase pickPdfUseCase;
  final CaptureBookPagesUseCase captureBookPagesUseCase;
  final CreatePdfFromCapturedImagesUseCase createPdfFromCapturedImagesUseCase;
  final SpeakArabicUseCase speakArabicUseCase;
  final CreateAudioFileUseCase createAudioFileUseCase;
  final AddAudioFileToFavoriteUseCase addAudioFileToFavoriteUseCase;
  final DeleteAudioFileFromFavoriteUseCase deleteAudioFileFromFavoriteUseCase;
  final SaveAudioFileUseCase saveAudioFileUseCase;
  final DeleteAudioFileFromSavedUseCase deleteAudioFileFromSavedUseCase;
  final IsAudioFileExistsUseCase isAudioFileExistsUseCase;
  HomeCubit({
    required this.pickPdfUseCase,
    required this.captureBookPagesUseCase,
    required this.createPdfFromCapturedImagesUseCase,
    required this.speakArabicUseCase,
    required this.createAudioFileUseCase,
    required this.addAudioFileToFavoriteUseCase,
    required this.deleteAudioFileFromFavoriteUseCase,
    required this.saveAudioFileUseCase,
    required this.deleteAudioFileFromSavedUseCase,
    required this.isAudioFileExistsUseCase,
  }) : super(HomeInitial());

  Future<void> pickPdf() async {
    try {
      final pdfPath = await pickPdfUseCase.call();
      if (pdfPath != null) {
        emit(PickPdfSuccess(pdfPath));
      } else {
        emit(PickPdfError('No PDF selected.'));
      }
    } catch (e) {
      emit(PickPdfError('Failed to pick PDF: $e'));
    }
  }

  Future<void> captureBookPages(BuildContext context) async {
    try {
      final capturedPages = await captureBookPagesUseCase.call(context);
      emit(CaptureBookPagesSuccess(capturedPages));
    } catch (e) {
      emit(CaptureBookPagesError('Failed to capture book pages: $e'));
    }
  }

  Future<void> creataPdfFromCapturedImages(List<XFile> images) async {
    emit(CreatePdfFromCapturedImagesLoading());
    try {
      final pdfDetails = await createPdfFromCapturedImagesUseCase.call(images);
      emit(CreatePdfFromCapturedImagesSuccess(pdfDetails));
    } catch (e) {
      emit(
        CreatePdfFromCapturedImagesError(
          'Failed to create PDF from captured images: $e',
        ),
      );
    }
  }

  Future<void> processPdf(Uint8List pdfBytes) async {
    try {
      final document = await pdfx.PdfDocument.openData(pdfBytes);
      final total = document.pagesCount;

      final results = <String>[];
      emit(ProcessingPdf(currrentPage: 0, totalPages: total));

      for (int page = 1; page <= total; page++) {
        final text = await ocrFirstPageFromPdfBytes(
          currentPage: page,
          pdfBytes: pdfBytes,
        );
        results.add(text);

        emit(
          ProcessingPdf(currrentPage: page, totalPages: total),
        ); // update progress
      }

      await document.close();
      emit(ProcessingPdfSuccess(results));
    } catch (e) {
      emit(ProcessingPdfError(e.toString()));
    }
  }

  Future<String> ocrFirstPageFromPdfBytes({
    required int currentPage,
    required Uint8List pdfBytes,
  }) async {
    final document = await pdfx.PdfDocument.openData(pdfBytes);
    final page = await document.getPage(currentPage);

    final pageImage = await page.render(
      width: page.width * 5,
      height: page.height * 5,
      format: pdfx.PdfPageImageFormat.png,
    );
    if (pageImage == null) {
      await page.close();
      await document.close();
      throw Exception('Failed to render PDF page to image.');
    }
    // var image = img.decodeImage(pageImage.bytes);
    // image = img.grayscale(image!);
    // image = img.contrast(image, contrast: 1.2);
    // image = img.gaussianBlur(image, radius: 1);
    // image = img.luminanceThreshold(image, threshold: 150); // عدّل حسب صورك
    final dir = await getTemporaryDirectory();
    final imageFile = File(
      '${dir.path}/page$currentPage${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await imageFile.writeAsBytes(pageImage.bytes);

    try {
      final text = FlutterTesseractOcr.extractText(
        imageFile.path,
        language: 'ara',
        args: {
          "psm": "6",
          "oem": "1",
          // "preserve_interword_spaces": "1",
          // "user_defined_dpi": "300",
        },
      );
      return normalizeArabicOcr(await text);
    } finally {
      await page.close();
      await document.close();
    }
  }

  Future<void> speakArabicTestWithNewVoice({
    required String text,
    required String voice,
  }) async {
    currentVoice = voice;
    try {
      await speakArabicUseCase.call(tts: tts, currentVoice: currentVoice, text: text);
      emit(SpeakArabicSuccess(text));
    } catch (e) {
      emit(SpeakArabicError('Failed to speak Arabic: $e'));
    }
  }

  String normalizeArabicOcr(String text) {
    // Keep paragraph breaks, but remove random line breaks inside paragraphs
    text = text.replaceAll('\r', '');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n'); // limit many newlines
    text = text.replaceAll(
      RegExp(r'(?<!\n)\n(?!\n)'),
      ' ',
    ); // single \n -> space
    text = text.replaceAll(RegExp(r'[ \t]{2,}'), ' '); // collapse spaces
    return text.trim();
  }

  Future<void> speakArabic(
    String text,
  ) async {
    try {
      await speakArabicUseCase.call(tts: tts, currentVoice: currentVoice, text: text);
      emit(SpeakArabicSuccess(text));
    } catch (e) {
      emit(SpeakArabicError('Failed to speak Arabic: $e'));
    }
  }

  void getCurrentWordIndex() async {
    if (_progressBound) return;
    _progressBound = true;
    tts.setProgressHandler((text, start, end, word) {
      if (isClosed) return;
      currentWordStartIndex = start;
      currentWordEndIndex = end;
      emit(
        GetCurrentWordIndex({
          'currentWordStartIndex': currentWordStartIndex,
          'currentWordEndIndex': currentWordEndIndex,
        }),
      );
    });
  }

  Future<void> createAudioFile({
    required String text,
    required String fileName,
  }) async {
    emit(CreatingAudioFile());
    try {
      final audioFile = await createAudioFileUseCase.call(
        tts: tts,
        text: text,
        fileName: fileName,
      );
      emit(CreateAudioFileSuccess(audioFile));
    } catch (e) {
      emit(CreateAudioFileError('Failed to create audio file: $e'));
    }
  }

  Future<void> addAudioFileToFavorite(AudioFileModel audioFile) async {
    try {
      await addAudioFileToFavoriteUseCase.call(audioFile);
      emit(AddAudioFileToFavoriteSuccess(audioFile));
    } catch (e) {
      emit(AddAudioFileToFavoriteError('Failed to add audio file: $e'));
    }
  }

  Future<void> deleteAudioFileFromFavorite(String id) async {
    try {
      await deleteAudioFileFromFavoriteUseCase.call(id);
    } catch (e) {
      emit(DeleteAudioFileFromFavoriteError('Failed to delete audio file: $e'));
    }
  }

  Future<void> saveAudioFile(AudioFileModel audioFile) async {
    try {
      await saveAudioFileUseCase.call(audioFile);
      emit(SaveAudioFileSuccess(audioFile));
    } catch (e) {
      emit(SaveAudioFileError('Failed to save audio file: $e'));
    }
  }

  Future<void> deleteAudioFileFromSaved(String id) async {
    try {
      await deleteAudioFileFromSavedUseCase.call(id);
    } catch (e) {
      emit(DeleteAudioFileFromSavedError('Failed to delete audio file: $e'));
    }
  }

  Future<bool> isAudioFileExists(String fileName) async {
    try {
      final exists = await isAudioFileExistsUseCase.call(fileName);
      return exists;
    } catch (e) {
      return false;
    }
  }
}
