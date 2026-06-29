import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class PickPdfUseCase {
  final HomeRepo homeRepo;
  PickPdfUseCase(this.homeRepo);

  Future<PdfDetailsModel?> call() {
    return homeRepo.pickPdf();
  }
}