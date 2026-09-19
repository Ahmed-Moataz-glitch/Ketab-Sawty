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
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:ketab_sawty/core/utils/shared_preferences.dart';
import 'package:ketab_sawty/core/view_model/voice_cubit/voice_cubit.dart';

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
  }) : super(HomeInitial()) {
    initVoice();
  }

  Future<void> initVoice() async {
    try {
      final voiceMode = await FlutterSharedPreferences.instance.getVoice();
      currentVoice = VoiceCubit.voiceIdFromMode(voiceMode);
    } catch (_) {
      currentVoice = 'ar-xa-x-arz-local';
    }
  }

  void updateVoice(String voice) {
    currentVoice = voice;
  }

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

  Future<void> createPdfFromCapturedImages(List<XFile> images) async {
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
    sf.PdfDocument? sfDoc;
    pdfx.PdfDocument? pdfxDoc;
    try {
      // 1. Open Syncfusion document to check for digital text
      sfDoc = sf.PdfDocument(inputBytes: pdfBytes);
      final totalPages = sfDoc.pages.count;
      final results = <String>[];
      emit(ProcessingPdf(currrentPage: 0, totalPages: totalPages));

      final textExtractor = sf.PdfTextExtractor(sfDoc);

      for (int page = 1; page <= totalPages; page++) {
        String pageText = '';
        try {
          // Syncfusion pages are 0-indexed
          pageText = textExtractor.extractText(
            startPageIndex: page - 1,
            endPageIndex: page - 1,
          );
          pageText = normalizeArabicOcr(pageText);
        } catch (e) {
          debugPrint('Digital text extraction failed for page $page: $e');
        }

        // If digital text extraction found substantial text (>= 15 characters), use it!
        if (pageText.trim().length >= 15) {
          results.add(pageText);
        } else {
          // Scanned page fallback: use Tesseract OCR
          // Lazily open pdfx document once for the whole loop
          pdfxDoc ??= await pdfx.PdfDocument.openData(pdfBytes);
          final ocrText = await _ocrPage(
            document: pdfxDoc,
            currentPage: page,
          );
          results.add(ocrText.isNotEmpty ? ocrText : pageText);
        }

        emit(ProcessingPdf(currrentPage: page, totalPages: totalPages));
      }

      emit(ProcessingPdfSuccess(results));
    } catch (e) {
      emit(ProcessingPdfError(e.toString()));
    } finally {
      sfDoc?.dispose();
      await pdfxDoc?.close();
    }
  }

  Future<String> _ocrPage({
    required pdfx.PdfDocument document,
    required int currentPage,
  }) async {
    final page = await document.getPage(currentPage);
    File? tempImageFile;
    try {
      // Scale by 2.0x instead of 5.0x for optimal OCR speed & memory usage (~300 DPI)
      final pageImage = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: pdfx.PdfPageImageFormat.png,
      );
      if (pageImage == null) {
        return '';
      }

      final dir = await getTemporaryDirectory();
      tempImageFile = File(
        '${dir.path}/page_${currentPage}_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await tempImageFile.writeAsBytes(pageImage.bytes);

      final text = await FlutterTesseractOcr.extractText(
        tempImageFile.path,
        language: 'ara',
        args: {
          "psm": "3",
          "oem": "1",
        },
      );
      return normalizeArabicOcr(text);
    } catch (e) {
      debugPrint('OCR extraction error on page $currentPage: $e');
      return '';
    } finally {
      await page.close();
      if (tempImageFile != null) {
        try {
          if (await tempImageFile.exists()) {
            await tempImageFile.delete();
          }
        } catch (_) {}
      }
    }
  }

  Future<String> ocrFirstPageFromPdfBytes({
    required int currentPage,
    required Uint8List pdfBytes,
  }) async {
    final document = await pdfx.PdfDocument.openData(pdfBytes);
    try {
      return await _ocrPage(document: document, currentPage: currentPage);
    } finally {
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
      if (currentVoice.isEmpty) {
        await initVoice();
      }
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
      if (currentVoice.isEmpty) {
        await initVoice();
      }
      final audioFile = await createAudioFileUseCase.call(
        tts: tts,
        text: text,
        fileName: fileName,
        currentVoice: currentVoice,
      );
      emit(CreateAudioFileSuccess(audioFile));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '').trim();
      emit(CreateAudioFileError(message));
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
