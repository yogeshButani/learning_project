import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';

class TrainingVideosProvider extends ChangeNotifier {
  final Map<String, CachedVideoPlayerPlus> _players = {};
  final Map<String, bool> _initialized = {};

  /// How many videos ahead to preload
  final int preloadCount;

  TrainingVideosProvider({this.preloadCount = 2});

  Future<void> preload(List<String> urls, int currentIndex) async {
    final start = currentIndex;
    final end = (currentIndex + preloadCount).clamp(0, urls.length);

    for (var i = start; i < end; i++) {
      final url = urls[i];
      if (!_players.containsKey(url)) {
        try {
          final player = CachedVideoPlayerPlus.networkUrl(
            Uri.parse(url),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: true,
            ),
          );

          await player.initialize();
          _players[url] = player;
          _initialized[url] = true;
        } catch (e) {
          debugPrint("Error initializing $url: $e");
          _initialized[url] = false;
        }
      }
    }
    notifyListeners();
  }

  CachedVideoPlayerPlus? getPlayer(String url) => _players[url];

  bool isInitialized(String url) => _initialized[url] ?? false;

  void pauseAll() {
    for (var player in _players.values) {
      if (player.controller.value.isPlaying) {
        player.controller.pause();
      }
    }
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }
}