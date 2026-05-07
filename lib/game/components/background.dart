import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Tile'lı pixel art arka plan — sola doğru yavaşça kayar.
/// Asset yolu runtime'da değiştirilebilir (level değişiminde).
class PixelBackground extends PositionComponent with HasGameReference {
  ui.Image? _img;
  double _offset = 0;
  final double scrollSpeed;
  String _assetPath;

  PixelBackground({
    required Vector2 size,
    required String assetPath,
    this.scrollSpeed = 25,
  })  : _assetPath = assetPath,
        super(size: size, priority: -10);

  @override
  Future<void> onLoad() async {
    _img = await game.images.load(_assetPath);
  }

  /// Yeni level başladığında çağrılır — yeni bg yüklenir.
  Future<void> swapAsset(String newPath) async {
    if (_assetPath == newPath) return;
    _assetPath = newPath;
    final img = await game.images.load(newPath);
    _img = img;
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

/// Yer zemini — level'e göre renk değiştirebilir.
class Ground extends PositionComponent {
  double scrollSpeed;
  double _offset = 0;
  Color _grassColor;
  Color _grassLight;
  Color _grassDark;
  final Color _dirtColor = const Color(0xFF6D4C41);
  final Color _dirtShade = const Color(0xFF5D4037);

  Ground({
    required Vector2 position,
    required Vector2 size,
    required this.scrollSpeed,
    Color grassColor = const Color(0xFF4CAF50),
  })  : _grassColor = grassColor,
        _grassLight = _lighter(grassColor, 0.12),
        _grassDark = _darker(grassColor, 0.18),
        super(position: position, size: size, priority: -1);

  void setGrassColor(Color c) {
    _grassColor = c;
    _grassLight = _lighter(c, 0.12);
    _grassDark = _darker(c, 0.18);
  }

  static Color _lighter(Color c, double t) =>
      Color.lerp(c, Colors.white, t) ?? c;
  static Color _darker(Color c, double t) =>
      Color.lerp(c, Colors.black, t) ?? c;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = _grassColor);

    // Çim üst şeridi
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y * 0.18),
      Paint()..color = _grassLight,
    );

    // Toprak (alt katman)
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.42, size.x, size.y * 0.58),
      Paint()..color = _dirtColor,
    );

    // Toprak üst gölgesi
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.42, size.x, 4),
      Paint()..color = _dirtShade,
    );

    // Çim tutamları (kayan)
    final tuftPaint = Paint()..color = _grassDark;
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
