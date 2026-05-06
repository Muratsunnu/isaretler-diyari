import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FinishLine extends SpriteComponent with HasGameReference {
  double speed;
  bool _crossed = false;
  final void Function() onCrossed;
  final double triggerX;

  FinishLine({
    required Vector2 position,
    required this.speed,
    required this.onCrossed,
    required this.triggerX,
  }) : super(
          position: position,
          size: Vector2(96, 96),
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('finish/End.png');
    paint = Paint()..filterQuality = FilterQuality.none;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (!_crossed && position.x <= triggerX) {
      _crossed = true;
      onCrossed();
    }
  }
}
