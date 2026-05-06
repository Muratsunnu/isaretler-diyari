import 'question.dart';

enum GameLevel {
  level1(
    number: 1,
    label: 'Seviye 1',
    description: 'Noktalama işaretleri',
    questionTime: 8.0,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
    },
    color: 0xFF43A047,
  ),
  level2(
    number: 2,
    label: 'Seviye 2',
    description: 'Noktalama + Büyük Harf',
    questionTime: 8.0,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
      PunctuationTopic.buyukHarf,
    },
    color: 0xFF1E88E5,
  ),
  level3(
    number: 3,
    label: 'Seviye 3',
    description: 'Noktalama + Büyük Harf — Hızlı!',
    questionTime: 5.0,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
      PunctuationTopic.buyukHarf,
    },
    color: 0xFFE53935,
  );

  final int number;
  final String label;
  final String description;
  final double questionTime;
  final Set<PunctuationTopic> topics;
  final int color;

  const GameLevel({
    required this.number,
    required this.label,
    required this.description,
    required this.questionTime,
    required this.topics,
    required this.color,
  });
}
