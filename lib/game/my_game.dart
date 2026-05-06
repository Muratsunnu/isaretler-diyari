import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/questions_data.dart';
import '../models/game_level.dart';
import '../models/question.dart';
import 'components/background.dart';
import 'components/finish_line.dart';
import 'components/obstacle.dart';
import 'components/player.dart';

enum GamePhase { running, asking, info, finishing, finished }

class IsaretlerGame extends FlameGame {
  static const int totalQuestions = 5;
  static const String questionOverlay = 'question';
  static const String infoOverlay = 'info';

  final GameLevel level;

  IsaretlerGame({required this.level});

  late RunnerPlayer player;
  late Ground ground;
  Obstacle? activeObstacle;
  FinishLine? finishLine;

  GamePhase phase = GamePhase.running;
  double scrollSpeed = 340;
  int questionsAsked = 0;
  int correctFirstTry = 0;
  int score = 0;

  // Soru süresi (saniye)
  double remainingTime = 0;
  double get maxTime => level.questionTime;

  Question? currentQuestion;
  bool _currentIsRetry = false;

  final List<Question> _questionPool = [];
  final Random _rng = Random();

  void Function()? onPhaseChange;
  void Function(int finalScore, int correctFirstTry)? onFinished;

  @override
  Color backgroundColor() => const Color(0xFF63A1FF);

  @override
  Future<void> onLoad() async {
    add(PixelBackground(size: size));

    ground = Ground(
      position: Vector2(0, size.y - 80),
      size: Vector2(size.x, 80),
      scrollSpeed: scrollSpeed,
    );
    add(ground);

    player = RunnerPlayer(position: Vector2(80, size.y - 80));
    add(player);

    _refillPool();
    _spawnObstacle();
  }

  void _refillPool() {
    _questionPool
      ..clear()
      ..addAll(questionsForLevel(level))
      ..shuffle(_rng);
  }

  void _spawnObstacle() {
    final type =
        ObstacleType.values[_rng.nextInt(ObstacleType.values.length)];
    final obstacle = Obstacle(
      type: type,
      position: Vector2(size.x + 50, size.y - 80),
      speed: scrollSpeed,
    );
    activeObstacle = obstacle;
    add(obstacle);
  }

  void _spawnFinishLine() {
    final fl = FinishLine(
      position: Vector2(size.x + 50, size.y - 80),
      speed: scrollSpeed,
      triggerX: player.position.x,
      onCrossed: _onFinishCrossed,
    );
    finishLine = fl;
    add(fl);
  }

  void _onFinishCrossed() {
    if (phase == GamePhase.finished) return;
    _finish();
  }

  @override
  void update(double dt) {
    // Soru sırasında sadece zamanlayıcı çalışır
    if (phase == GamePhase.asking) {
      remainingTime -= dt;
      if (remainingTime <= 0 && currentQuestion != null) {
        remainingTime = 0;
        _onTimeout();
      }
      return;
    }
    if (phase == GamePhase.info) return;

    super.update(dt);

    // Engel tetikleme sadece koşma fazında
    if (phase != GamePhase.running) return;

    final obstacle = activeObstacle;
    if (obstacle == null || obstacle.triggered) return;

    final triggerX = player.position.x + 90;
    if (obstacle.position.x <= triggerX) {
      obstacle.triggered = true;
      obstacle.stopped = true;
      _askQuestion();
    }
  }

  void _askQuestion() {
    if (_questionPool.isEmpty) _refillPool();
    currentQuestion = _questionPool.removeLast();
    _currentIsRetry = false;
    remainingTime = level.questionTime;
    phase = GamePhase.asking;
    player.isRunning = false;
    overlays.add(questionOverlay);
    onPhaseChange?.call();
  }

  void _onTimeout() {
    // Süre doldu — yanlış cevap gibi davran, bilgi ekranı göster
    phase = GamePhase.info;
    overlays.remove(questionOverlay);
    overlays.add(infoOverlay);
    onPhaseChange?.call();
  }

  void answerQuestion(int chosenIndex) {
    final q = currentQuestion;
    if (q == null) return;

    final correct = chosenIndex == q.correctIndex;
    if (correct) {
      if (!_currentIsRetry) {
        correctFirstTry++;
        score += 20;
      } else {
        score += 5;
      }
      questionsAsked++;
      overlays.remove(questionOverlay);
      _passObstacle();
    } else {
      phase = GamePhase.info;
      overlays.remove(questionOverlay);
      overlays.add(infoOverlay);
      onPhaseChange?.call();
    }
  }

  void closeInfoAndRetry() {
    overlays.remove(infoOverlay);
    _currentIsRetry = true;
    remainingTime = level.questionTime;
    phase = GamePhase.asking;
    overlays.add(questionOverlay);
    onPhaseChange?.call();
  }

  void _passObstacle() {
    final obstacle = activeObstacle;
    if (obstacle != null) {
      obstacle.stopped = false;
    }
    phase = GamePhase.running;
    player.isRunning = true;
    player.jump();
    onPhaseChange?.call();

    Future.delayed(const Duration(milliseconds: 800), () {
      activeObstacle?.removeFromParent();
      activeObstacle = null;

      if (questionsAsked >= totalQuestions) {
        phase = GamePhase.finishing;
        Future.delayed(const Duration(milliseconds: 600), _spawnFinishLine);
      } else {
        Future.delayed(const Duration(milliseconds: 500), _spawnObstacle);
      }
    });
  }

  void _finish() {
    phase = GamePhase.finished;
    player.isRunning = true;
    onFinished?.call(score, correctFirstTry);
  }
}
