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
  // Mevcut level'ın çarpanına göre ölçeklenir
  static const double _baseScrollSpeed = 340;
  double get scrollSpeed =>
      _baseScrollSpeed * currentLevel.obstacleSpeedMultiplier;
  // Oyuncu yarışmayı tamamlayamadan kaybetti mi
  bool gameOver = false;

  // Mevcut level + bir sonrakine geçiş için referans
  GameLevel currentLevel = GameLevel.level1;
  GameLevel? pendingNextLevel;

  /// Her level'da 1 can: yanlış cevapta tükenir. Tükenince retry yok.
  static const int livesPerLevel = 1;
  int livesThisLevel = livesPerLevel;
  /// İnfo ekranı şu an "advance" modunda mı (canı tükenmiş, retry yok)
  bool isOutOfLivesInfo = false;

  // Mevcut level'da kaç soru cevaplandı (3 olunca level biter)
  int questionsInCurrentLevel = 0;

  // Toplam istatistikler
  int questionsAsked = 0;
  int correctFirstTry = 0;
  int score = 0;

  Question? currentQuestion;
  bool _currentIsRetry = false;

  final List<Question> _questionPool = [];
  final Random _rng = Random();

  void Function()? onPhaseChange;
  void Function(int finalScore, int correctFirstTry, bool gameOver)? onFinished;

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
      // Diğer engeller gibi sağdan gelir, mevcut level hızıyla
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
    if (phase == GamePhase.asking) return;
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
    phase = GamePhase.asking;
    player.isRunning = false;
    overlays.add(questionOverlay);
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
      _onQuestionDone();
    } else {
      _handleWrong();
    }
  }

  void _handleWrong() {
    if (livesThisLevel > 0) {
      // Can var → can düş, info göster, aynı soruya retry
      livesThisLevel--;
      isOutOfLivesInfo = false;
      phase = GamePhase.info;
      overlays.remove(questionOverlay);
      overlays.add(infoOverlay);
      onPhaseChange?.call();
    } else {
      // Can yok → info göster ama retry yok, "Devam" ile sıradaki soru
      isOutOfLivesInfo = true;
      phase = GamePhase.info;
      overlays.remove(questionOverlay);
      overlays.add(infoOverlay);
      onPhaseChange?.call();
    }
  }

  void _onQuestionDone({bool success = true}) {
    questionsAsked++;
    questionsInCurrentLevel++;
    overlays.remove(questionOverlay);
    _passObstacle(success: success);
  }

  /// Info ekranındaki "Yarışmayı bitir" — can yok, oyun biter, sonuç ekranı
  void closeInfoAndEndGame() {
    overlays.remove(infoOverlay);
    isOutOfLivesInfo = false;
    gameOver = true; // Yarıda kaldı
    _finish();
  }

  void closeInfoAndRetry() {
    overlays.remove(infoOverlay);
    _currentIsRetry = true;
    phase = GamePhase.asking;
    overlays.add(questionOverlay);
    onPhaseChange?.call();
  }

  void _passObstacle({bool success = true}) {
    final obstacle = activeObstacle;
    if (obstacle != null) {
      obstacle.stopped = false;
    }
    phase = GamePhase.running;
    player.isRunning = true;
    // Sadece doğru cevapta zıplar; yanlışta engel sessizce geçer
    if (success) player.jump();
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
      // Son level → bitiş çizgisi (hemen)
      phase = GamePhase.finishing;
      Future.delayed(const Duration(milliseconds: 200), _spawnFinishLine);
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
    livesThisLevel = livesPerLevel; // Can yenilendi
    isOutOfLivesInfo = false;
    questionsInCurrentLevel = 0;

    // Görsel temayı + zemin hızını yeni level'e göre değiştir
    await bg.swapAsset(currentLevel.backgroundAsset);
    ground.setGrassColor(Color(currentLevel.groundColor));
    ground.scrollSpeed = scrollSpeed;

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
    onFinished?.call(score, correctFirstTry, gameOver);
  }
}
