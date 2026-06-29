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
      coverImageBytes: fields[1] as Uint8List,
      title: fields[2] as String,
      author: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFileModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coverImageBytes)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
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
