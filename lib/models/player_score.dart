class PlayerScore {
  final String name;
  final int score;
  final int correctFirstTry;
  final DateTime playedAt;
  final int? level;

  PlayerScore({
    required this.name,
    required this.score,
    required this.correctFirstTry,
    required this.playedAt,
    this.level,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'correctFirstTry': correctFirstTry,
        'playedAt': playedAt.toIso8601String(),
        'level': level,
      };

  factory PlayerScore.fromJson(Map<String, dynamic> json) => PlayerScore(
        name: json['name'] as String,
        score: json['score'] as int,
        correctFirstTry: json['correctFirstTry'] as int,
        playedAt: DateTime.parse(json['playedAt'] as String),
        level: json['level'] as int?,
      );
}
