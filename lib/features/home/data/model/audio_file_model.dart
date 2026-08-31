// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'audio_file_model.g.dart';

@HiveType(typeId: 0)
class AudioFileModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Uint8List coverImageBytes;
  @HiveField(2)
  final String audioFilePath;
  @HiveField(3)
  final int audioPosition;
  @HiveField(4)
  final int audioDuration;
  @HiveField(5)
  final String title;
  @HiveField(6)
  final String author;

  AudioFileModel({
    required this.id,
    required this.coverImageBytes,
    required this.audioFilePath,
    required this.audioPosition,
    required this.audioDuration,
    required this.title,
    required this.author,
  });
}
