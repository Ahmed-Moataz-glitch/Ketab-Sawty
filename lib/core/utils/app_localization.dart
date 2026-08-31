// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

abstract class AppLocalization {
  static bool isArabic(){
    return Intl.getCurrentLocale() == 'ar';
  }
}