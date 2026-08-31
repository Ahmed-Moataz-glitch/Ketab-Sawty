import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class CreatePdfFromCapturedImagesUseCase {
  final HomeRepo homeRepo;
  CreatePdfFromCapturedImagesUseCase(this.homeRepo);

  Future<PdfDetailsModel> call(List<XFile> images) {
    return homeRepo.createPdfFromCapturedImages(images);
  }
}