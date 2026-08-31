// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioFileModelAdapter extends TypeAdapter<AudioFileModel> {
  @override
  final int typeId = 0;

  @override
  AudioFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioFileModel(
      id: fields[0] as String,
      coverImageBytes: fields[1] as Uint8List,
      audioFilePath: fields[2] as String,
      audioPosition: fields[3] as int,
      audioDuration: fields[4] as int,
      title: fields[5] as String,
      author: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFileModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coverImageBytes)
      ..writeByte(2)
      ..write(obj.audioFilePath)
      ..writeByte(3)
      ..write(obj.audioPosition)
      ..writeByte(4)
      ..write(obj.audioDuration)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.author);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
