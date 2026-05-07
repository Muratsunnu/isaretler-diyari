import 'package:flutter/material.dart';
import '../models/player_score.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _storage = StorageService();
  List<PlayerScore> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final list = await _storage.loadLeaderboard();
    if (mounted) setState(() => _leaderboard = list);
  }

  void _start() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir isim gir.')),
      );
      return;
    }
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => GameScreen(playerName: name),
          ),
        )
        .then((_) => _refresh());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'İşaretler Diyarı',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Noktalama işaretlerini öğrenirken eğlen!',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Oyuncu adı',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _start(),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF66BB6A),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3 seviye, her seviyede 3 soru',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '• Seviye 1: 10 sn\n'
                                    '• Seviye 2: 8 sn\n'
                                    '• Seviye 3: 5 sn\n'
                                    'Her seviyede 1 yanlış cevap hakkın var!',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _start,
                                icon: const Icon(Icons.play_arrow, size: 28),
                                label: const Text(
                                  'Oyuna Başla',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.emoji_events,
                                    color: Colors.amber, size: 28),
                                const SizedBox(width: 8),
                                const Text(
                                  'Liderlik Tablosu',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                if (_leaderboard.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Tabloyu temizle',
                                    onPressed: () async {
                                      await _storage.clear();
                                      _refresh();
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_leaderboard.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Henüz oynayan yok. İlk sen ol!',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            else
                              ..._leaderboard
                                  .take(10)
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => _LeaderRow(
                                      rank: e.key + 1,
                                      score: e.value,
                                    ),
                                  ),
                          ],
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
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final int rank;
  final PlayerScore score;
  const _LeaderRow({required this.rank, required this.score});

  @override
  Widget build(BuildContext context) {
    final medal = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : '$rank.';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              medal,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Text(
              score.name,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${score.score} puan',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}
