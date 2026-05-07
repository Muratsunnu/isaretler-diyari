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

enum GamePhase {
  running,
  asking,
  info,
  levelTransition,
  finishing,
  finished,
}

class IsaretlerGame extends FlameGame {
  // Her level'da kaç soru
  static const int questionsPerLevel = 3;
  static const String questionOverlay = 'question';
  static const String infoOverlay = 'info';
  static const String levelTransitionOverlay = 'levelTransition';

  // Geriye dönük: bazı yerler "totalQuestions" kullanıyor (3 level × 3)
  static const int totalQuestions = questionsPerLevel * 3;

  IsaretlerGame();

  late RunnerPlayer player;
  late Ground ground;
  late PixelBackground bg;
  Obstacle? activeObstacle;
  FinishLine? finishLine;

  GamePhase phase = GamePhase.running;
  double scrollSpeed = 340;

  // Mevcut level + bir sonrakine geçiş için referans
  GameLevel currentLevel = GameLevel.level1;
  GameLevel? pendingNextLevel;

  /// Her level'da en fazla 1 yanlış cevap → bilgi+tekrar; ikincide kayıt edip geç
  bool _wrongUsedThisLevel = false;
  // Mevcut level'da kaç soru cevaplandı (3 olunca level biter)
  int questionsInCurrentLevel = 0;

  // Toplam istatistikler
  int questionsAsked = 0;
  int correctFirstTry = 0;
  int score = 0;

  // Soru sayacı
  double remainingTime = 0;
  double get maxTime => currentLevel.questionTime;

  Question? currentQuestion;
  bool _currentIsRetry = false;

  final List<Question> _questionPool = [];
  final Random _rng = Random();

  void Function()? onPhaseChange;
  void Function(int finalScore, int correctFirstTry)? onFinished;

  @override
  Color backgroundColor() => Color(currentLevel.skyColor);

  @override
  Future<void> onLoad() async {
    bg = PixelBackground(size: size, assetPath: currentLevel.backgroundAsset);
    add(bg);

    ground = Ground(
      position: Vector2(0, size.y - 80),
      size: Vector2(size.x, 80),
      scrollSpeed: scrollSpeed,
      grassColor: Color(currentLevel.groundColor),
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
      ..addAll(questionsForLevel(currentLevel))
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
    if (phase == GamePhase.asking) {
      remainingTime -= dt;
      if (remainingTime <= 0 && currentQuestion != null) {
        remainingTime = 0;
        _onTimeout();
      }
      return;
    }
    if (phase == GamePhase.info) return;
    if (phase == GamePhase.levelTransition) return;

    super.update(dt);

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
    remainingTime = currentLevel.questionTime;
    phase = GamePhase.asking;
    player.isRunning = false;
    overlays.add(questionOverlay);
    onPhaseChange?.call();
  }

  void _onTimeout() {
    // Süre doldu = yanlış
    _handleWrong();
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
      _onQuestionDone();
    } else {
      _handleWrong();
    }
  }

  void _handleWrong() {
    if (!_wrongUsedThisLevel) {
      // Bu level'daki tek joker harcanıyor: bilgi göster + tekrar dene
      _wrongUsedThisLevel = true;
      phase = GamePhase.info;
      overlays.remove(questionOverlay);
      overlays.add(infoOverlay);
      onPhaseChange?.call();
    } else {
      // Joker bitti — yanlışı kaydet, sonraki engele geç (info gösterme)
      _onQuestionDone();
    }
  }

  void _onQuestionDone() {
    questionsAsked++;
    questionsInCurrentLevel++;
    overlays.remove(questionOverlay);
    _passObstacle();
  }

  void closeInfoAndRetry() {
    overlays.remove(infoOverlay);
    _currentIsRetry = true;
    remainingTime = currentLevel.questionTime;
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

      if (questionsInCurrentLevel >= questionsPerLevel) {
        _onLevelComplete();
      } else {
        Future.delayed(const Duration(milliseconds: 500), _spawnObstacle);
      }
    });
  }

  void _onLevelComplete() {
    final next = currentLevel.next;
    if (next == null) {
      // Son level → bitiş çizgisi
      phase = GamePhase.finishing;
      Future.delayed(const Duration(milliseconds: 600), _spawnFinishLine);
    } else {
      // Level transition overlay göster
      pendingNextLevel = next;
      phase = GamePhase.levelTransition;
      player.isRunning = false;
      overlays.add(levelTransitionOverlay);
      onPhaseChange?.call();
    }
  }

  Future<void> advanceToNextLevel() async {
    final next = pendingNextLevel;
    if (next == null) return;

    // Level değişkenleri
    currentLevel = next;
    pendingNextLevel = null;
    _wrongUsedThisLevel = false;
    questionsInCurrentLevel = 0;

    // Görsel temayı değiştir
    await bg.swapAsset(currentLevel.backgroundAsset);
    ground.setGrassColor(Color(currentLevel.groundColor));

    overlays.remove(levelTransitionOverlay);
    _refillPool();

    phase = GamePhase.running;
    player.isRunning = true;
    onPhaseChange?.call();

    Future.delayed(const Duration(milliseconds: 400), _spawnObstacle);
  }

  void _finish() {
    phase = GamePhase.finished;
    player.isRunning = true;
    onFinished?.call(score, correctFirstTry);
  }
}
