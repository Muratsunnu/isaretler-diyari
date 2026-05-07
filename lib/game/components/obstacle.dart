import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ObstacleType { dog, bush, rock }

class Obstacle extends PositionComponent with HasGameReference {
  final ObstacleType type;
  double speed;
  bool stopped = false;
  bool triggered = false;
  double _animTime = 0;
  ui.Image? _sprite;

  Obstacle({
    required this.type,
    required Vector2 position,
    required this.speed,
  }) : super(
          position: position,
          size: _sizeFor(type),
          anchor: Anchor.bottomLeft,
        );

  static Vector2 _sizeFor(ObstacleType t) {
    switch (t) {
      case ObstacleType.dog:
        // Opossum: 36x28 base → görsel 90x70
        return Vector2(90, 70);
      case ObstacleType.bush:
        return Vector2(82, 50);
      case ObstacleType.rock:
        return Vector2(72, 72);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    switch (type) {
      case ObstacleType.dog:
        _sprite = await game.images.load('obstacles/Dog.png');
        break;
      case ObstacleType.rock:
        _sprite = await game.images.load('obstacles/Rock.png');
        break;
      case ObstacleType.bush:
        _sprite = await game.images.load('obstacles/Bush.png');
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animTime += dt;
    if (!stopped) position.x -= speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final img = _sprite;
    if (img == null) return;

    if (type == ObstacleType.dog) {
      _renderDogAnimated(canvas, img);
    } else {
      _renderStaticSprite(canvas, img);
    }
  }

  void _renderStaticSprite(Canvas canvas, ui.Image img) {
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      size.toRect(),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  void _renderDogAnimated(Canvas canvas, ui.Image img) {
    // Spritesheet: 6 frame × 36×28
    const frameCount = 6;
    const frameW = 36.0;
    const frameH = 28.0;
    const frameDur = 0.10;
    final frame = ((_animTime / frameDur).floor() % frameCount).toInt();

    // Köpek oyuncuya doğru koşuyor — orijinal yönünde çizilsin (flip yok)
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(frame * frameW, 0, frameW, frameH),
      size.toRect(),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  String get displayName {
    switch (type) {
      case ObstacleType.dog:
        return 'Köpek';
      case ObstacleType.bush:
        return 'Çalı';
      case ObstacleType.rock:
        return 'Kaya';
    }
  }
}
