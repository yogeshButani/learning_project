import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayerProvider with ChangeNotifier {
  late final YoutubePlayerController _controller;
  bool isInitialized = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double playbackSpeed = 1.0;

  double get volume => _volume;
  bool get isMuted => _isMuted;

  double _volume = 1.0; // 0.0 to 1.0
  bool _isMuted = false;

  YoutubePlayerController get controller => _controller;

  Future<void> init(String videoUrl) async {
    if (isInitialized) return; // prevent re-init

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
    );

    _controller.addListener(() {
      final value = _controller.value;
      position = value.position;
      duration = value.metaData.duration;
      isPlaying = value.isPlaying;
      notifyListeners();
    });

    await Future.delayed(const Duration(milliseconds: 500));
    duration = _controller.metadata.duration;
    isInitialized = true;
    notifyListeners();
    play();
  }


  void play() {
    _controller.play();
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _controller.pause();
    isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    isPlaying ? pause() : play();
  }

  void seekTo(Duration newPosition) {
    _controller.seekTo(newPosition);
  }

  void disposeController() {
    _controller.dispose();
    isInitialized = false;
  }

  void seekForward() {
    final newPosition = position + const Duration(seconds: 10);
    _controller.seekTo(newPosition < duration ? newPosition : duration);
  }

  void seekBackward() {
    final newPosition = position - const Duration(seconds: 10);
    _controller.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed = speed;
     _controller.setPlaybackRate(speed);
    notifyListeners();
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    _isMuted = _volume == 0.0;
    _controller.setVolume((_volume * 100).toInt());
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _volume = _isMuted ? 0.0 : 1.0;
    _controller.setVolume((_volume * 100).toInt());
    notifyListeners();
  }
}

