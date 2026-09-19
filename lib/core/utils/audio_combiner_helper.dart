import 'dart:io';
import 'dart:typed_data';

class AudioCombinerHelper {
  /// Splits large text into smaller chunks safe for TTS engines (max ~700 chars)
  /// keeping sentence boundaries intact.
  static List<String> splitTextIntoChunks(String text, {int maxChunkSize = 700}) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return [];
    if (trimmed.length <= maxChunkSize) return [trimmed];

    final chunks = <String>[];
    // Split by common sentence delimiters (Arabic & English) or newlines
    final delimiterPattern = RegExp(r'(?<=[.\n!؟،؛?])\s+');
    final sentences = trimmed.split(delimiterPattern);

    final currentChunk = StringBuffer();

    for (final sentence in sentences) {
      final s = sentence.trim();
      if (s.isEmpty) continue;

      if (currentChunk.length + s.length + 1 > maxChunkSize) {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk.toString().trim());
          currentChunk.clear();
        }
        // If a single sentence is longer than maxChunkSize, split by words
        if (s.length > maxChunkSize) {
          final words = s.split(' ');
          for (final word in words) {
            if (currentChunk.length + word.length + 1 > maxChunkSize) {
              if (currentChunk.isNotEmpty) {
                chunks.add(currentChunk.toString().trim());
                currentChunk.clear();
              }
            }
            currentChunk.write(currentChunk.isEmpty ? word : ' $word');
          }
        } else {
          currentChunk.write(s);
        }
      } else {
        currentChunk.write(currentChunk.isEmpty ? s : ' $s');
      }
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.toString().trim());
    }

    return chunks;
  }

  /// Combines multiple WAV files into a single WAV file.
  /// Handles standard RIFF PCM WAV headers.
  static Future<File> combineWavFiles({
    required List<File> wavFiles,
    required File targetFile,
  }) async {
    final validFiles = <File>[];
    for (final f in wavFiles) {
      if (await f.exists() && await f.length() > 44) {
        validFiles.add(f);
      }
    }

    if (validFiles.isEmpty) {
      throw Exception('No valid WAV files provided to combine.');
    }

    if (validFiles.length == 1) {
      if (validFiles.first.path == targetFile.path) {
        return targetFile;
      }
      await validFiles.first.copy(targetFile.path);
      return targetFile;
    }

    final firstBytes = await validFiles.first.readAsBytes();
    final firstDataOffset = _findDataChunkOffset(firstBytes);
    if (firstDataOffset == -1) {
      // Fallback: simply copy the first valid file
      await validFiles.first.copy(targetFile.path);
      return targetFile;
    }

    // Header up to the data chunk (firstDataOffset + 8 bytes for "data" + 4-byte size)
    final header = Uint8List.fromList(firstBytes.sublist(0, firstDataOffset + 8));

    final pcmDataChunks = <Uint8List>[];
    int totalPcmLength = 0;

    for (final f in validFiles) {
      final bytes = await f.readAsBytes();
      final dataOffset = _findDataChunkOffset(bytes);
      if (dataOffset != -1 && bytes.length > dataOffset + 8) {
        final pcm = Uint8List.sublistView(bytes, dataOffset + 8);
        pcmDataChunks.add(pcm);
        totalPcmLength += pcm.length;
      }
    }

    if (totalPcmLength == 0) {
      await validFiles.first.copy(targetFile.path);
      return targetFile;
    }

    // Update ChunkSize (Total file size - 8) in the RIFF header at offset 4
    final totalFileSize = header.length + totalPcmLength;
    final byteData = header.buffer.asByteData(header.offsetInBytes, header.lengthInBytes);
    byteData.setUint32(4, totalFileSize - 8, Endian.little);

    // Update Subchunk2Size (data length) at firstDataOffset + 4
    byteData.setUint32(firstDataOffset + 4, totalPcmLength, Endian.little);

    final sink = targetFile.openWrite();
    sink.add(header);
    for (final pcm in pcmDataChunks) {
      sink.add(pcm);
    }
    await sink.flush();
    await sink.close();

    return targetFile;
  }

  /// Locates the "data" 4-byte ASCII signature in a WAV header
  static int _findDataChunkOffset(Uint8List bytes) {
    // Search for ASCII 'd', 'a', 't', 'a' (0x64, 0x61, 0x74, 0x61)
    final len = bytes.length - 4;
    for (int i = 12; i < len && i < 200; i++) {
      if (bytes[i] == 0x64 &&
          bytes[i + 1] == 0x61 &&
          bytes[i + 2] == 0x74 &&
          bytes[i + 3] == 0x61) {
        return i;
      }
    }
    return -1;
  }
}
