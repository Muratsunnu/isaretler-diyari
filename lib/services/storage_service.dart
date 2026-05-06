import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_score.dart';

class StorageService {
  static const _key = 'leaderboard_v1';
  static const _maxEntries = 30;

  Future<List<PlayerScore>> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List)
        .map((e) => PlayerScore.fromJson(e as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => b.score.compareTo(a.score));
    return list;
  }

  Future<void> addScore(PlayerScore score) async {
    final current = await loadLeaderboard();
    current.add(score);
    current.sort((a, b) => b.score.compareTo(a.score));
    final trimmed = current.take(_maxEntries).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(trimmed.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
