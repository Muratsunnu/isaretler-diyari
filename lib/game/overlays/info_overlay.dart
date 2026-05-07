import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../my_game.dart';

class InfoOverlay extends StatelessWidget {
  final IsaretlerGame game;
  const InfoOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final q = game.currentQuestion;
    if (q == null) return const SizedBox.shrink();

    final outOfLives = game.isOutOfLivesInfo;

    return Container(
      color: Colors.black54,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb,
                          color: Color(0xFFFFA000), size: 32),
                      SizedBox(width: 10),
                      Text(
                        'Bilgi Notu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    q.format == QuestionFormat.fillBlank
                        ? 'Doğru kullanım:'
                        : 'Doğru cevap:',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (q.format == QuestionFormat.fillBlank)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF66BB6A)),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: q.before),
                            TextSpan(
                              text: q.options[q.correctIndex],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            TextSpan(text: q.after),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF66BB6A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF2E7D32), size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              q.options[q.correctIndex],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    q.explanation,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  if (outOfLives)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE57373)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.heart_broken,
                              color: Color(0xFFC62828), size: 22),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Canın bitti! Yarışman burada sona eriyor.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB71C1C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: outOfLives
                          ? game.closeInfoAndEndGame
                          : game.closeInfoAndRetry,
                      icon: Icon(
                        outOfLives ? Icons.flag_circle : Icons.refresh,
                      ),
                      label: Text(
                        outOfLives
                            ? 'Yarışmayı bitir'
                            : 'Anladım, tekrar deneyeceğim',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: outOfLives
                            ? const Color(0xFFC62828)
                            : const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
