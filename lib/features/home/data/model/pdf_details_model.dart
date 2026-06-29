import 'dart:typed_data';

class PdfDetailsModel {
  final Uint8List pdfBytes;
  final Uint8List coverImageBytes;
  final String title;
  final String? author;
  final int pageCount;

  PdfDetailsModel({
    required this.pdfBytes,
    required this.coverImageBytes,
    required this.title,
    this.author,
    required this.pageCount,
  });
}