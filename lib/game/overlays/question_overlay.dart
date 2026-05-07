import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../my_game.dart';

class QuestionOverlay extends StatefulWidget {
  final IsaretlerGame game;
  const QuestionOverlay({super.key, required this.game});

  @override
  State<QuestionOverlay> createState() => _QuestionOverlayState();
}

class _QuestionOverlayState extends State<QuestionOverlay> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final q = game.currentQuestion;
    if (q == null) return const SizedBox.shrink();

    final ratio = (game.remainingTime / game.maxTime).clamp(0.0, 1.0);
    final isLow = game.remainingTime <= 3.0;
    final timerColor = isLow ? const Color(0xFFE53935) : const Color(0xFF2E7D32);

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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Soru ${game.questionsInCurrentLevel + 1}/${IsaretlerGame.questionsPerLevel}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(game.currentLevel.color),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          game.currentLevel.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Puan: ${game.score}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Sayaç çubuğu + saniye
                  Row(
                    children: [
                      Icon(Icons.timer, size: 18, color: timerColor),
                      const SizedBox(width: 6),
                      Text(
                        '${game.remainingTime.ceil()} sn',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: timerColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(timerColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildQuestionHint(q),
                  const SizedBox(height: 16),
                  _buildQuestionContent(q),
                  const SizedBox(height: 24),
                  _buildOptions(q, game),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionHint(Question q) {
    String text;
    switch (q.format) {
      case QuestionFormat.fillBlank:
        text = q.topic == PunctuationTopic.buyukHarf
            ? 'Boş bırakılan yere küçük mü, büyük mü?'
            : 'Boş bırakılan yere hangi noktalama işareti gelmeli?';
        break;
      case QuestionFormat.shortAnswer:
        text = q.options.length == 2 &&
                q.options[0] == 'Doğru' &&
                q.options[1] == 'Yanlış'
            ? 'Aşağıdaki ifade doğru mu, yanlış mı?'
            : 'Aşağıdaki soruya cevap ver:';
        break;
      case QuestionFormat.longChoice:
        text = 'Aşağıdaki seçeneklerden hangisi doğru?';
        break;
    }
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  Widget _buildQuestionContent(Question q) {
    if (q.format == QuestionFormat.fillBlank) {
      // "Cümle [?] cümle"
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black87,
              height: 1.5,
            ),
            children: [
              TextSpan(text: q.before),
              const WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _Blank(),
              ),
              TextSpan(text: q.after),
            ],
          ),
        ),
      );
    }
    // shortAnswer / longChoice → düz prompt metni
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Text(
        q.prompt ?? '',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black87,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOptions(Question q, IsaretlerGame game) {
    // 1 karakterlik (sembol) şıklar → büyük yatay butonlar
    final maxLen = q.options.map((o) => o.length).reduce((a, b) => a > b ? a : b);
    final useBigSymbols = maxLen <= 1;

    if (useBigSymbols) {
      return Row(
        children: List.generate(q.options.length, (i) {
          final color = i == 0
              ? const Color(0xFF1976D2)
              : const Color(0xFFE65100);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i == 0 ? 8 : 0,
                left: i == 0 ? 0 : 8,
              ),
              child: SizedBox(
                height: 90,
                child: ElevatedButton(
                  onPressed: () => game.answerQuestion(i),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    q.options[i],
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      );
    }

    // Uzun seçenekler → A/B kartları (dikey)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(q.options.length, (i) {
        final color = i == 0
            ? const Color(0xFF1976D2)
            : const Color(0xFFE65100);
        final letter = String.fromCharCode(65 + i); // A, B
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ElevatedButton(
            onPressed: () => game.answerQuestion(i),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              elevation: 4,
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    q.options[i],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Blank extends StatelessWidget {
  const _Blank();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDD2),
        border: Border.all(color: const Color(0xFFE57373), width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '?',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFFC62828),
        ),
      ),
    );
  }
}
