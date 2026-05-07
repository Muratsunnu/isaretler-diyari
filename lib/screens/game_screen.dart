import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/my_game.dart';
import '../game/overlays/info_overlay.dart';
import '../game/overlays/level_transition_overlay.dart';
import '../game/overlays/question_overlay.dart';
import '../models/player_score.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  const GameScreen({super.key, required this.playerName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final IsaretlerGame _game;
  final _storage = StorageService();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _game = IsaretlerGame();
    _game.onPhaseChange = () {
      if (mounted) setState(() {});
    };
    _game.onFinished = (s, c) => _handleFinished(s, c);
  }

  Future<void> _handleFinished(int score, int correctFirstTry) async {
    if (_saved) return;
    _saved = true;
    await _storage.addScore(PlayerScore(
      name: widget.playerName,
      score: score,
      correctFirstTry: correctFirstTry,
      playedAt: DateTime.now(),
      level: 3,
    ));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          playerName: widget.playerName,
          score: score,
          correctFirstTry: correctFirstTry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget<IsaretlerGame>(
            game: _game,
            overlayBuilderMap: {
              IsaretlerGame.questionOverlay: (_, g) =>
                  QuestionOverlay(game: g),
              IsaretlerGame.infoOverlay: (_, g) => InfoOverlay(game: g),
              IsaretlerGame.levelTransitionOverlay: (_, g) =>
                  LevelTransitionOverlay(game: g),
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Wrap(
                spacing: 8,
                children: [
                  _Pill(icon: Icons.person, label: widget.playerName),
                  _Pill(icon: Icons.star, label: '${_game.score}'),
                  _Pill(
                    icon: Icons.help_outline,
                    label:
                        '${_game.questionsInCurrentLevel}/${IsaretlerGame.questionsPerLevel}',
                  ),
                  _Pill(
                    icon: Icons.flag,
                    label: _game.currentLevel.label,
                    color: Color(_game.currentLevel.color),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.85),
                  foregroundColor: Colors.black87,
                ),
                icon: const Icon(Icons.close),
                tooltip: 'Çıkış',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _Pill({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF2E7D32);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: c),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
