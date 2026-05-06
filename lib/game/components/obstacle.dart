import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum ObstacleType { puddle, bush, rock }

class Obstacle extends PositionComponent with HasGameReference {
  final ObstacleType type;
  double speed;
  bool stopped = false;
  bool triggered = false;
  double _t = 0;
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
      case ObstacleType.puddle:
        return Vector2(120, 36);
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
      case ObstacleType.rock:
        _sprite = await game.images.load('obstacles/Rock.png');
        break;
      case ObstacleType.bush:
        _sprite = await game.images.load('obstacles/Bush.png');
        break;
      case ObstacleType.puddle:
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (!stopped) position.x -= speed * dt;
  }

  @override
  void render(Canvas canvas) {
    switch (type) {
      case ObstacleType.puddle:
        _renderPuddle(canvas);
        break;
      case ObstacleType.bush:
      case ObstacleType.rock:
        _renderSprite(canvas);
        break;
    }
  }

  void _renderSprite(Canvas canvas) {
    final img = _sprite;
    if (img == null) return;
    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      size.toRect(),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  // ---- PUDDLE ----
  // 3/4 perspektifli, çukura yansıyan gökyüzü, çamur kenarlı su birikintisi.
  // size = (120, 36), bottomLeft anchor → y=0 üst (uzak/arka), y=36 alt (yakın/ön)
  void _renderPuddle(Canvas canvas) {
    // Sunny Land'in sıcak toprak + canlı su paletine yakın renkler
    const dirtRimLight = Color(0xFF7B5C3F);  // ön/açık çamur
    const dirtRimDark = Color(0xFF3E2A1A);   // arka/karanlık çamur
    const waterEdge = Color(0xFF124869);     // suyun en koyu kenarı
    const waterMain = Color(0xFF2683B3);     // ana su rengi
    const waterLight = Color(0xFF65BCDC);    // sığ/yansıma açık mavi
    const skyShine = Color(0xFFE0F4FF);      // gökyüzü beyaz parıltı

    final w = size.x;
    final h = size.y;

    // 1) Çukurun yere düşürdüğü gölge (zeminde, çukurun çevresinde)
    final groundShadow = Paint()..color = Colors.black.withValues(alpha: 0.22);
    canvas.drawOval(
      Rect.fromLTWH(-2, h * 0.12, w + 4, h),
      groundShadow,
    );

    // 2) Çamur kenar — açık ton (ön/üst görünür kısım)
    canvas.drawOval(
      Rect.fromLTWH(0, h * 0.08, w, h * 0.92),
      Paint()..color = dirtRimLight,
    );

    // 3) Çamur kenar — koyu ton (arka rim, çukurun gerisinde, gölgede)
    // Asimetrik: sadece üst yarım arc
    final darkRimPath = Path()
      ..moveTo(w * 0.04, h * 0.55)
      ..quadraticBezierTo(w * 0.05, h * 0.10, w * 0.32, h * 0.05)
      ..quadraticBezierTo(w * 0.65, h * 0.0, w * 0.96, h * 0.55)
      ..quadraticBezierTo(w * 0.92, h * 0.30, w * 0.6, h * 0.20)
      ..quadraticBezierTo(w * 0.35, h * 0.20, w * 0.08, h * 0.30)
      ..close();
    canvas.drawPath(darkRimPath, Paint()..color = dirtRimDark);

    // 4) Suyun kenarı — koyu navy (su yüzeyinin sınırı)
    canvas.drawOval(
      Rect.fromLTWH(w * 0.06, h * 0.22, w * 0.88, h * 0.70),
      Paint()..color = waterEdge,
    );

    // 5) Ana su yüzeyi
    canvas.drawOval(
      Rect.fromLTWH(w * 0.10, h * 0.30, w * 0.80, h * 0.55),
      Paint()..color = waterMain,
    );

    // 6) Yansıma bandı — sığ açık mavi (üst yarı, gökyüzünü yansıtıyor)
    canvas.drawOval(
      Rect.fromLTWH(w * 0.16, h * 0.32, w * 0.68, h * 0.28),
      Paint()..color = waterLight,
    );

    // 7) Pixel-blok beyaz parıltı (gökyüzü yansıması, chunky pixel art tarzı)
    final shinePaint = Paint()..color = skyShine;
    final wobble = (sin(_t * 2.5) * 1.5).roundToDouble();
    // Üstte 3 yatay parça, soldan sağa azalan
    canvas.drawRect(
      Rect.fromLTWH(w * 0.22 + wobble, h * 0.40, w * 0.30, 3),
      shinePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.30 + wobble, h * 0.50, w * 0.20, 2),
      shinePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.58 - wobble, h * 0.45, w * 0.10, 2),
      shinePaint,
    );

    // 8) Animasyonlu beyaz dalgacık (ince çizgi, chunky)
    final ripple = Paint()..color = Colors.white.withValues(alpha: 0.55);
    final ripX = w * 0.40 + sin(_t * 3.0) * 4;
    canvas.drawRect(
      Rect.fromLTWH(ripX, h * 0.62, w * 0.18, 2),
      ripple,
    );
    canvas.drawRect(
      Rect.fromLTWH(ripX + 6, h * 0.72, w * 0.10, 2),
      ripple,
    );

    // 9) Kenarda küçük çim/ot tutamları (Sunny Land hissi)
    final grassDark = Paint()..color = const Color(0xFF3F6E1E);
    final grassLight = Paint()..color = const Color(0xFF6FA634);
    // Sol kenar
    _grassTuft(canvas, w * 0.04, h * 0.20, grassDark, grassLight);
    // Sağ kenar
    _grassTuft(canvas, w * 0.92, h * 0.18, grassDark, grassLight);
    // Ön orta küçük ot
    _grassTuft(canvas, w * 0.50, h * 0.94, grassDark, grassLight, small: true);
  }

  void _grassTuft(Canvas canvas, double x, double y, Paint dark, Paint light,
      {bool small = false}) {
    final s = small ? 0.6 : 1.0;
    canvas.drawRect(Rect.fromLTWH(x, y, 2 * s, 6 * s), dark);
    canvas.drawRect(Rect.fromLTWH(x + 3 * s, y - 2, 2 * s, 7 * s), light);
    canvas.drawRect(Rect.fromLTWH(x + 6 * s, y, 2 * s, 5 * s), dark);
  }

  String get displayName {
    switch (type) {
      case ObstacleType.puddle:
        return 'Su Birikintisi';
      case ObstacleType.bush:
        return 'Çalı';
      case ObstacleType.rock:
        return 'Kaya';
    }
  }
}
