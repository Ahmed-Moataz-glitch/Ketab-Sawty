import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketab_sawty/features/home/domain/repo/repo/home_repo.dart';

class CaptureBookPagesUseCase {
  final HomeRepo homeRepo;
  CaptureBookPagesUseCase(this.homeRepo);

  Future<List<XFile>> call(BuildContext context) {
    return homeRepo.captureBookPages(context);
  }
}