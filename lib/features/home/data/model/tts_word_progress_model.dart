class TtsWordProgressModel {
  final String text;
  final String word;
  final int currentWordStartIndex;
  final int currentWordEndIndex;

  TtsWordProgressModel({
    required this.text,
    required this.word,
    required this.currentWordStartIndex,
    required this.currentWordEndIndex,
  });
}
