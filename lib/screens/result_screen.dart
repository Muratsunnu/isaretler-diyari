import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String playerName;
  final int score;
  final int correctFirstTry;
  final bool gameOver;
  static const int _totalQuestions = 9;

  const ResultScreen({
    super.key,
    required this.playerName,
    required this.score,
    required this.correctFirstTry,
    this.gameOver = false,
  });

  String get _title => gameOver ? 'Yarışma yarıda kaldı, $playerName' : 'Tebrikler $playerName!';

  String get _message {
    if (gameOver) {
      return 'Canın bittiği için yarışman bitti. Bilgi notlarını okudun, tekrar denersen başarırsın!';
    }
    if (correctFirstTry == _totalQuestions) {
      return 'Mükemmel! Tüm soruları ilk denemede bildin!';
    }
    if (correctFirstTry >= 6) return 'Harika iş çıkardın!';
    if (correctFirstTry >= 3) return 'İyi denemeydi, biraz daha pratik!';
    return 'Pes etme! Bilgi notlarıyla öğrendin, tekrar dene.';
  }

  String get _emoji {
    if (gameOver) return '💔';
    if (correctFirstTry == _totalQuestions) return '🏆';
    if (correctFirstTry >= 6) return '🌟';
    if (correctFirstTry >= 3) return '👍';
    return '📚';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFB6E5A1)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_emoji, style: const TextStyle(fontSize: 72)),
                        const SizedBox(height: 8),
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: gameOver
                                ? const Color(0xFFC62828)
                                : const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            gameOver
                                ? 'Yarışma yarıda kaldı 💔'
                                : '3 Seviye Tamamlandı 🎉',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _message,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _Stat(
                          label: 'Toplam Puan',
                          value: '$score',
                          color: const Color(0xFF2E7D32),
                        ),
                        const SizedBox(height: 12),
                        _Stat(
                          label: 'İlk Denemede Doğru',
                          value: '$correctFirstTry / $_totalQuestions',
                          color: const Color(0xFF1976D2),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.home),
                            label: const Text(
                              'Ana Menü',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
