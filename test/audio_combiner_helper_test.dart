import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ketab_sawty/core/utils/audio_combiner_helper.dart';

void main() {
  group('AudioCombinerHelper - Text Chunking', () {
    test('returns empty list for empty string or whitespace', () {
      expect(AudioCombinerHelper.splitTextIntoChunks(''), isEmpty);
      expect(AudioCombinerHelper.splitTextIntoChunks('   \n\t '), isEmpty);
    });

    test('keeps short text as a single chunk', () {
      const text = 'هذا كتاب صوتي رائع باللغة العربية.';
      final chunks = AudioCombinerHelper.splitTextIntoChunks(text, maxChunkSize: 500);
      expect(chunks.length, equals(1));
      expect(chunks.first, equals(text));
    });

    test('splits long text respecting Arabic sentence delimiters', () {
      final text = 'الجملة الأولى عن تاريخ الأدب العربي. '
          'الجملة الثانية تناقش الرواية الحديثة وتطورها، '
          'وهنا نسأل هل حققت انتشاراً كافياً؟ '
          'نعم لقد حققت إنجازاً عظيماً!';
      final chunks = AudioCombinerHelper.splitTextIntoChunks(text, maxChunkSize: 50);
      expect(chunks.length, greaterThan(1));
      for (final chunk in chunks) {
        expect(chunk.length, lessThanOrEqualTo(65));
        expect(chunk.trim(), isNotEmpty);
      }
    });

    test('splits very long sentences without delimiters by words safely', () {
      final longSentence = List.generate(50, (i) => 'كلمة$i').join(' ');
      final chunks = AudioCombinerHelper.splitTextIntoChunks(longSentence, maxChunkSize: 40);
      expect(chunks.length, greaterThan(1));
      for (final chunk in chunks) {
        expect(chunk.length, lessThanOrEqualTo(45));
      }
    });
  });

  group('AudioCombinerHelper - WAV Concatenation', () {
    Uint8List createDummyWav(int pcmLength) {
      final bytes = Uint8List(44 + pcmLength);
      final byteData = ByteData.view(bytes.buffer);

      // 'RIFF'
      bytes[0] = 0x52; bytes[1] = 0x49; bytes[2] = 0x46; bytes[3] = 0x46;
      byteData.setUint32(4, 36 + pcmLength, Endian.little);
      // 'WAVE'
      bytes[8] = 0x57; bytes[9] = 0x41; bytes[10] = 0x56; bytes[11] = 0x45;
      // 'fmt '
      bytes[12] = 0x66; bytes[13] = 0x6D; bytes[14] = 0x74; bytes[15] = 0x20;
      byteData.setUint32(16, 16, Endian.little);
      byteData.setUint16(20, 1, Endian.little); // PCM
      byteData.setUint16(22, 1, Endian.little); // Mono
      byteData.setUint32(24, 16000, Endian.little); // Sample rate 16kHz
      byteData.setUint32(28, 32000, Endian.little); // Byte rate
      byteData.setUint16(32, 2, Endian.little); // Block align
      byteData.setUint16(34, 16, Endian.little); // 16-bit
      // 'data'
      bytes[36] = 0x64; bytes[37] = 0x61; bytes[38] = 0x74; bytes[39] = 0x61;
      byteData.setUint32(40, pcmLength, Endian.little);

      // fill dummy PCM
      for (int i = 0; i < pcmLength; i++) {
        bytes[44 + i] = (i % 256);
      }
      return bytes;
    }

    test('combines two WAV files into one with correct combined data size', () async {
      final tempDir = Directory.systemTemp.createTempSync('wav_test');
      try {
        final f1 = File('${tempDir.path}/part1.wav');
        final f2 = File('${tempDir.path}/part2.wav');
        final out = File('${tempDir.path}/combined.wav');

        await f1.writeAsBytes(createDummyWav(100));
        await f2.writeAsBytes(createDummyWav(200));

        final result = await AudioCombinerHelper.combineWavFiles(
          wavFiles: [f1, f2],
          targetFile: out,
        );

        expect(await result.exists(), isTrue);
        final outBytes = await result.readAsBytes();
        expect(outBytes.length, equals(44 + 300));

        final bd = ByteData.view(outBytes.buffer);
        // Total file size - 8 in header
        expect(bd.getUint32(4, Endian.little), equals(36 + 300));
        // Subchunk2Size (data size)
        expect(bd.getUint32(40, Endian.little), equals(300));
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}
