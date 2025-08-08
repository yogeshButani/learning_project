import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProvider extends ChangeNotifier {
  late final CachedVideoPlayerPlus player;
  bool isInitialized = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double playbackSpeed = 1.0;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  double _volume = 1.0; // Range: 0.0 - 1.0
  bool _isMuted = false;
  Future<void> init(String url) async {
    player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(url),
      invalidateCacheIfOlderThan: const Duration(minutes: 60),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: true,
      ),
    );

    await player.initialize();
    duration = player.controller.value.duration;
    isInitialized = true;

    // Set listeners
    player.controller.addListener(() {
      position = player.controller.value.position;
      isPlaying = player.controller.value.isPlaying;
      notifyListeners();
    });

    notifyListeners();
    play();
  }

  void play() {
    player.controller.play();
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    player.controller.pause();
    isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    isPlaying ? pause() : play();
  }

  void seekTo(Duration newPosition) {
    player.controller.seekTo(newPosition);
  }

  void disposePlayer() {
    player.dispose();
  }

  void seekForward() {
    final newPosition = position + const Duration(seconds: 10);
    if (newPosition < duration) {
      player.controller.seekTo(newPosition);
    } else {
      player.controller.seekTo(duration);
    }
  }

  void seekBackward() {
    final newPosition = position - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      player.controller.seekTo(newPosition);
    } else {
      player.controller.seekTo(Duration.zero);
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed = speed;
    await player.controller.setPlaybackSpeed(speed);
    notifyListeners();
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    _isMuted = _volume == 0.0;
    player.controller.setVolume(_volume);
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _volume = _isMuted ? 0.0 : 1.0;
    player.controller.setVolume(_volume);
    notifyListeners();
  }
}
