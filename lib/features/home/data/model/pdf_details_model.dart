import 'dart:typed_data';

class PdfDetailsModel {
  final String id;
  final Uint8List? pdfBytes;
  final Uint8List coverImageBytes;
  final String title;
  final String? author;
  final int? pageCount;

  PdfDetailsModel({
    required this.id,
    this.pdfBytes,
    required this.coverImageBytes,
    required this.title,
    this.author,
    this.pageCount,
  });
}