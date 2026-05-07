enum PunctuationTopic { ikiNokta, nokta, virgul, buyukHarf, genelKultur }

/// Soru sunum formatı.
/// - fillBlank: "Cümle [?] cümle" + 2 kısa sembol şıkkı (eski format)
/// - shortAnswer: "Soru?" + 2 kısa şık (sembol veya 1-2 kelime)
/// - longChoice: "Soru?" + 2 uzun cümle/A-B kartları
enum QuestionFormat { fillBlank, shortAnswer, longChoice }

class Question {
  /// fillBlank için cümle başı
  final String before;

  /// fillBlank için cümle sonu
  final String after;

  /// shortAnswer/longChoice için ana soru metni
  final String? prompt;

  final List<String> options;
  final int correctIndex;
  final String explanation;
  final PunctuationTopic topic;
  final QuestionFormat format;

  const Question({
    this.before = '',
    this.after = '',
    this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.topic,
    this.format = QuestionFormat.fillBlank,
  });

  String get fullSentence =>
      '$before${options[correctIndex]}$after'.trim();
}
