import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProvider extends ChangeNotifier {
  CachedVideoPlayerPlus? player;
  VoidCallback? _listener;

  bool isInitialized = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double playbackSpeed = 1.0;

  double _volume = 1.0;
  bool _isMuted = false;
  bool _isLandscape = false;

  double get volume => _volume;
  bool get isMuted => _isMuted;
  bool get isLandscape => _isLandscape;

  Future<void> init(String url) async {
    // Remove old player
    disposePlayer();

    isInitialized = false;
    isPlaying = false;
    position = Duration.zero;
    duration = Duration.zero;
    notifyListeners();

    try {
      player = CachedVideoPlayerPlus.networkUrl(
        Uri.parse(url),
        invalidateCacheIfOlderThan: const Duration(minutes: 60),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: true,
        ),
      );

      await player?.initialize();
      duration = player?.controller.value.duration ?? Duration.zero;
      isInitialized = true;

      // Create and store listener
      _listener = () {
        if (player?.controller.value.isInitialized ?? false) {
          position = player!.controller.value.position;
          isPlaying = player!.controller.value.isPlaying;
          notifyListeners();
        }
      };
      player?.controller.addListener(_listener!);

      notifyListeners();
      play();
    } catch (e) {
      debugPrint("Video initialization failed: $e");
      Future.delayed(const Duration(seconds: 1), () {
        if (!isInitialized) init(url);
      });
    }
  }

  void play() {
    player?.controller.play();
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    player?.controller.pause();
    isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    isPlaying ? pause() : play();
  }

  void seekTo(Duration newPosition) {
    player?.controller.seekTo(newPosition);
  }

  void disposePlayer() {
    if (player != null) {
      if (_listener != null) {
        player?.controller.removeListener(_listener!);
        _listener = null;
      }
      player?.dispose();
      player = null;
    }
  }

  void seekForward() {
    final newPosition = position + const Duration(seconds: 10);
    player?.controller.seekTo(newPosition < duration ? newPosition : duration);
  }

  void seekBackward() {
    final newPosition = position - const Duration(seconds: 10);
    player?.controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed = speed;
    await player?.controller.setPlaybackSpeed(speed);
    notifyListeners();
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    _isMuted = _volume == 0.0;
    player?.controller.setVolume(_volume);
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _volume = _isMuted ? 0.0 : 1.0;
    player?.controller.setVolume(_volume);
    notifyListeners();
  }

  void toggleOrientation() {
    if (_isLandscape) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
    } else {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
    }
    _isLandscape = !_isLandscape;
    notifyListeners();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }
}

