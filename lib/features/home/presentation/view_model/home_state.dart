part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class PickPdfSuccess extends HomeState {
  final PdfDetailsModel pdfDetails;
  PickPdfSuccess(this.pdfDetails);
}

final class PickPdfError extends HomeState {
  final String errorMessage;
  PickPdfError(this.errorMessage);
}

final class ProcessingPdf extends HomeState {
  final int currrentPage;
  final int totalPages;
  ProcessingPdf({required this.currrentPage, required this.totalPages});
}

final class ProcessingPdfSuccess extends HomeState {
  final List<String> processedText;
  ProcessingPdfSuccess(this.processedText);
}

final class ProcessingPdfError extends HomeState {
  final String errorMessage;
  ProcessingPdfError(this.errorMessage);
}

final class SpeakArabicSuccess extends HomeState {
  final String text;
  SpeakArabicSuccess(this.text);
}

final class SpeakArabicError extends HomeState {
  final String errorMessage;
  SpeakArabicError(this.errorMessage);
}

final class GetCurrentWordIndex extends HomeState {
  final Map<String, int> currentWordIndex;
  GetCurrentWordIndex(this.currentWordIndex);
}

final class CreateAudioFileSuccess extends HomeState {
  final File audioFile;
  CreateAudioFileSuccess(this.audioFile);
}

final class CreateAudioFileError extends HomeState {
  final String errorMessage;
  CreateAudioFileError(this.errorMessage);
}
