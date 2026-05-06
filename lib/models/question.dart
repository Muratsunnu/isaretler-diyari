enum PunctuationTopic { ikiNokta, nokta, virgul, buyukHarf }

class Question {
  final String before;
  final String after;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final PunctuationTopic topic;

  const Question({
    required this.before,
    required this.after,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.topic,
  });

  String get fullSentence =>
      '$before${options[correctIndex]}$after'.trim();
}
