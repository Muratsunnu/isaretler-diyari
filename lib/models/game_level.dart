import 'question.dart';

enum GameLevel {
  level1(
    number: 1,
    label: 'Seviye 1',
    description: 'Kolay başlangıç',
    questionTime: 10.0,
    obstacleSpeedMultiplier: 1.0,
    color: 0xFF43A047,
    backgroundAsset: 'bg/BgL1.png',
    skyColor: 0xFF4FA8E0,
    groundColor: 0xFF4CAF50,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
      PunctuationTopic.buyukHarf,
    },
  ),
  level2(
    number: 2,
    label: 'Seviye 2',
    description: 'Engeller hızlanıyor',
    questionTime: 8.0,
    obstacleSpeedMultiplier: 1.30,
    color: 0xFFFFB300,
    backgroundAsset: 'bg/BgL2.png',
    skyColor: 0xFFFFC76B,
    groundColor: 0xFF7C8B3D,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
      PunctuationTopic.buyukHarf,
    },
  ),
  level3(
    number: 3,
    label: 'Seviye 3',
    description: 'Hızlı düşün, hızlı cevapla!',
    questionTime: 5.0,
    obstacleSpeedMultiplier: 1.70,
    color: 0xFFE53935,
    backgroundAsset: 'bg/BgL3.png',
    skyColor: 0xFFE07AB5,
    groundColor: 0xFF6A4C2A,
    topics: {
      PunctuationTopic.nokta,
      PunctuationTopic.virgul,
      PunctuationTopic.ikiNokta,
      PunctuationTopic.buyukHarf,
    },
  );

  final int number;
  final String label;
  final String description;
  final double questionTime;
  final double obstacleSpeedMultiplier;
  final Set<PunctuationTopic> topics;
  final int color;
  final String backgroundAsset;
  final int skyColor;
  final int groundColor;

  const GameLevel({
    required this.number,
    required this.label,
    required this.description,
    required this.questionTime,
    required this.obstacleSpeedMultiplier,
    required this.topics,
    required this.color,
    required this.backgroundAsset,
    required this.skyColor,
    required this.groundColor,
  });

  GameLevel? get next {
    switch (this) {
      case GameLevel.level1:
        return GameLevel.level2;
      case GameLevel.level2:
        return GameLevel.level3;
      case GameLevel.level3:
        return null;
    }
  }
}
