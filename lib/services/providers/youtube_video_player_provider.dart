import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayerProvider with ChangeNotifier {
  late YoutubePlayerController _controller;
  bool _isMuted = false;
  double _volume = 100;
  bool _isPlaying = false;

  YoutubePlayerController get controller => _controller;

  bool get isMuted => _isMuted;

  double get volume => _volume;

  bool get isPlaying => _isPlaying;

  void initialize(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        showLiveFullscreenButton: false,
        disableDragSeek: false,
        hideControls: true,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    final value = _controller.value;
    _isPlaying = value.isPlaying;
    notifyListeners();
  }

  void playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    notifyListeners();
  }

  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _controller.mute();
    } else {
      _controller.unMute();
    }
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value;
    _controller.setVolume(value.toInt());
    notifyListeners();
  }

  Duration get currentPosition => _controller.value.position;

  Duration get totalDuration => _controller.metadata.duration;

  void disposeController() {
    _controller.dispose();
  }
}
