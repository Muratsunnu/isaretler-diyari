import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerAnim { idle, run, jump, fall }

class _SpriteCfg {
  static const String runFile = 'player/Run.png';
  static const String idleFile = 'player/Idle.png';
  static const String jumpFile = 'player/Jump.png';
  static const String fallFile = 'player/Fall.png';

  static final Vector2 frameSize = Vector2.all(32);

  static const int runFrames = 12;
  static const int idleFrames = 11;
  static const int jumpFrames = 1;
  static const int fallFrames = 1;

  static const double runStep = 0.05;
  static const double idleStep = 0.08;
  static const double jumpStep = 0.10;
  static const double fallStep = 0.10;
}

class RunnerPlayer extends SpriteAnimationGroupComponent<PlayerAnim>
    with HasGameReference {
  static const double _jumpHeight = 110;
  static const double _jumpDuration = 0.75;

  bool isRunning = true;
  bool _isJumping = false;
  double _jumpT = 0;
  late double _baseY;

  RunnerPlayer({required Vector2 position})
      : super(
          position: position,
          size: Vector2(96, 96),
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    _baseY = position.y;

    final runImg = await game.images.load(_SpriteCfg.runFile);
    final idleImg = await game.images.load(_SpriteCfg.idleFile);
    final jumpImg = await game.images.load(_SpriteCfg.jumpFile);
    final fallImg = await game.images.load(_SpriteCfg.fallFile);

    animations = {
      PlayerAnim.idle: SpriteAnimation.fromFrameData(
        idleImg,
        SpriteAnimationData.sequenced(
          amount: _SpriteCfg.idleFrames,
          stepTime: _SpriteCfg.idleStep,
          textureSize: _SpriteCfg.frameSize,
        ),
      ),
      PlayerAnim.run: SpriteAnimation.fromFrameData(
        runImg,
        SpriteAnimationData.sequenced(
          amount: _SpriteCfg.runFrames,
          stepTime: _SpriteCfg.runStep,
          textureSize: _SpriteCfg.frameSize,
        ),
      ),
      PlayerAnim.jump: SpriteAnimation.fromFrameData(
        jumpImg,
        SpriteAnimationData.sequenced(
          amount: _SpriteCfg.jumpFrames,
          stepTime: _SpriteCfg.jumpStep,
          textureSize: _SpriteCfg.frameSize,
          loop: false,
        ),
      ),
      PlayerAnim.fall: SpriteAnimation.fromFrameData(
        fallImg,
        SpriteAnimationData.sequenced(
          amount: _SpriteCfg.fallFrames,
          stepTime: _SpriteCfg.fallStep,
          textureSize: _SpriteCfg.frameSize,
          loop: false,
        ),
      ),
    };

    // Pixel art keskin görünsün — bulanıklaştırma kapalı
    paint = Paint()..filterQuality = FilterQuality.none;

    current = PlayerAnim.run;
  }

  void jump() {
    if (_isJumping) return;
    _isJumping = true;
    _jumpT = 0;
    current = PlayerAnim.jump;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isJumping) {
      _jumpT += dt;
      final p = (_jumpT / _jumpDuration).clamp(0.0, 1.0);
      position.y = _baseY - _jumpHeight * 4 * p * (1 - p);
      // Tepe noktasından sonra düşüş animasyonu
      current = p < 0.5 ? PlayerAnim.jump : PlayerAnim.fall;
      if (_jumpT >= _jumpDuration) {
        _isJumping = false;
        position.y = _baseY;
        current = isRunning ? PlayerAnim.run : PlayerAnim.idle;
      }
    } else {
      final desired = isRunning ? PlayerAnim.run : PlayerAnim.idle;
      if (current != desired) current = desired;
    }
  }
}
