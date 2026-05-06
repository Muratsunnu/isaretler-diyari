import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Tile'lı pixel art arka plan — sola doğru yavaşça kayar (parallax efekti).
class PixelBackground extends PositionComponent with HasGameReference {
  ui.Image? _img;
  double _offset = 0;
  final double scrollSpeed;

  PixelBackground({required Vector2 size, this.scrollSpeed = 25})
      : super(size: size, priority: -10);

  @override
  Future<void> onLoad() async {
    _img = await game.images.load('bg/Blue.png');
  }

  @override
  void render(Canvas canvas) {
    final img = _img;
    if (img == null) {
      canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF63A1FF));
      return;
    }
    final tileW = img.width.toDouble();
    final tileH = img.height.toDouble();
    final startX = -(_offset % tileW);
    final paint = Paint()..filterQuality = FilterQuality.none;

    for (double y = 0; y < size.y; y += tileH) {
      for (double x = startX; x < size.x; x += tileW) {
        canvas.drawImageRect(
          img,
          Rect.fromLTWH(0, 0, tileW, tileH),
          Rect.fromLTWH(x, y, tileW, tileH),
          paint,
        );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _offset += scrollSpeed * dt;
  }
}

/// Yer zemini — pixel art tarzına yakın yeşil/kahverengi katmanlar.
class Ground extends PositionComponent {
  final double scrollSpeed;
  double _offset = 0;
  Ground({required Vector2 position, required Vector2 size, required this.scrollSpeed})
      : super(position: position, size: size, priority: -1);

  @override
  void render(Canvas canvas) {
    final groundPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawRect(size.toRect(), groundPaint);

    // Çim üst şeridi (daha açık yeşil)
    final grassTop = Paint()..color = const Color(0xFF66BB6A);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y * 0.18),
      grassTop,
    );

    // Toprak (alt katman)
    final dirtPaint = Paint()..color = const Color(0xFF6D4C41);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.42, size.x, size.y * 0.58),
      dirtPaint,
    );

    // Toprak üst gölgesi
    final dirtShade = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.42, size.x, 4),
      dirtShade,
    );

    // Çim tutamları (kayan)
    final tuftPaint = Paint()..color = const Color(0xFF388E3C);
    const tuftSpacing = 36.0;
    final start = -(_offset % tuftSpacing);
    for (double x = start; x < size.x; x += tuftSpacing) {
      final path = Path()
        ..moveTo(x, size.y * 0.18)
        ..lineTo(x + 4, size.y * 0.18 - 8)
        ..lineTo(x + 8, size.y * 0.18)
        ..close();
      canvas.drawPath(path, tuftPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _offset += scrollSpeed * dt;
  }
}
