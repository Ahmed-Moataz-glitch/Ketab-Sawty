import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketab_sawty/core/utils/app_constants.dart';
import 'package:ketab_sawty/core/utils/app_theme.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/core/view/widgets/validator.dart';
import 'package:ketab_sawty/core/view_model/voice_cubit/voice_cubit.dart';
import 'package:ketab_sawty/features/home/data/model/audio_file_model.dart';
import 'package:ketab_sawty/features/home/data/model/pdf_details_model.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Validator Tests', () {
    test('validateName validates presence of name', () {
      expect(Validator.validateName(null), isNotNull);
      expect(Validator.validateName(''), isNotNull);
      expect(Validator.validateName('Ahmed'), isNull);
    });

    test('validateEmail validates format correctly', () {
      expect(Validator.validateEmail(null), isNotNull);
      expect(Validator.validateEmail(''), isNotNull);
      expect(Validator.validateEmail('invalid-email'), isNotNull);
      expect(Validator.validateEmail('test@example.com'), isNull);
    });

    test('validatePassword validates length, digit and uppercase', () {
      expect(Validator.validatePassword(null), isNotNull);
      expect(Validator.validatePassword('weak'), isNotNull);
      expect(Validator.validatePassword('Valid1@Pass'), isNull);
    });

    test('validateConfirmPassword checks match with password', () {
      expect(Validator.validateConfirmPassword(null, 'Pass123'), isNotNull);
      expect(Validator.validateConfirmPassword('Pass1', 'Pass2'), isNotNull);
      expect(Validator.validateConfirmPassword('Pass123', 'Pass123'), isNull);
    });

    test('validatePhoneNumber checks 13 digits format', () {
      expect(Validator.validatePhoneNumber(null), isNotNull);
      expect(Validator.validatePhoneNumber('123'), isNotNull);
      expect(Validator.validatePhoneNumber('+201001234567'), isNull);
    });

    test('validateCode checks at least 6 digits', () {
      expect(Validator.validateCode(null), isNotNull);
      expect(Validator.validateCode('12345'), isNotNull);
      expect(Validator.validateCode('123456'), isNull);
    });
  });

  group('Model Tests', () {
    test('AudioFileModel properties are stored correctly', () {
      final model = AudioFileModel(
        id: 'book_1',
        coverImageBytes: Uint8List.fromList([1, 2, 3]),
        audioFilePath: '/path/to/audio.wav',
        audioPosition: 120,
        audioDuration: 360,
        title: 'كتاب صوتي تجريبي',
        author: 'مؤلف تجريبي',
      );

      expect(model.id, equals('book_1'));
      expect(model.title, equals('كتاب صوتي تجريبي'));
      expect(model.author, equals('مؤلف تجريبي'));
      expect(model.audioPosition, equals(120));
      expect(model.audioDuration, equals(360));
      expect(model.coverImageBytes.length, equals(3));
    });

    test('PdfDetailsModel properties and fallbacks work correctly', () {
      final details = PdfDetailsModel(
        id: 'pdf_1',
        pdfBytes: Uint8List.fromList([4, 5, 6]),
        coverImageBytes: Uint8List.fromList([7, 8]),
        title: 'عنوان تجريبي',
        author: 'المؤلف',
        pageCount: 15,
      );

      expect(details.id, equals('pdf_1'));
      expect(details.title, equals('عنوان تجريبي'));
      expect(details.author, equals('المؤلف'));
      expect(details.pageCount, equals(15));
      expect(details.pdfBytes?.length, equals(3));
      expect(details.coverImageBytes.length, equals(2));
    });
  });

  group('Voice & Theme Utility Tests', () {
    test('voiceIdFromMode returns expected voice identifiers', () {
      expect(
        VoiceCubit.voiceIdFromMode(VoiceModeState.voice1),
        equals('ar-xa-x-arz-local'),
      );
      expect(
        VoiceCubit.voiceIdFromMode(VoiceModeState.voice2),
        equals('ar-xa-x-ard-local'),
      );
      expect(
        VoiceCubit.voiceIdFromMode(VoiceModeState.voice3),
        equals('ar-xa-x-ara-local'),
      );
    });

    test('AppTheme defines light and dark themes properly', () {
      expect(AppTheme.light.brightness, equals(Brightness.light));
      expect(AppTheme.dark.brightness, equals(Brightness.dark));
    });
  });

  group('KetabSawty App Smoke Test', () {
    late Directory tempDir;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      tempDir = await Directory.systemTemp.createTemp('hive_ketab_sawty_test');
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter<AudioFileModel>(AudioFileModelAdapter());
      }
      if (!Hive.isBoxOpen(AppConstants.favoriteAudioFilesBox)) {
        await Hive.openBox<AudioFileModel>(AppConstants.favoriteAudioFilesBox);
      }
      if (!Hive.isBoxOpen(AppConstants.savedAudioFilesBox)) {
        await Hive.openBox<AudioFileModel>(AppConstants.savedAudioFilesBox);
      }
      if (!getIt.isRegistered<HomeCubit>()) {
        await setupGetIt();
      }
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    testWidgets('KetabSawty initializes and renders main bottom nav', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const KetabSawty());
      await tester.pump();

      // Verify that the MaterialApp is mounted and renders
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
