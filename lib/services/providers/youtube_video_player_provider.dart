import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayerProvider with ChangeNotifier {
  YoutubePlayerController? _controller;
  VoidCallback? _listener;

  bool isInitialized = false;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double playbackSpeed = 1.0;

  double _volume = 1.0; // 0.0 to 1.0
  bool _isMuted = false;
  bool _isLandscape = false;

  bool get isLandscape => _isLandscape;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  YoutubePlayerController? get controller => _controller;

  Future<void> init(String videoUrl) async {
    // Dispose old controller if any
    disposeController();

    // Reset state
    isInitialized = false;
    isPlaying = false;
    position = Duration.zero;
    duration = Duration.zero;
    notifyListeners();

    try {
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
          enableCaption: false,
          isLive: false,
          useHybridComposition: true,
        ),
      );

      // Store listener so we can remove it later
      _listener = () {
        final value = _controller?.value;
        if (value != null && value.isReady) {
          position = value.position;
          duration = value.metaData.duration;
          isPlaying = value.isPlaying;
          notifyListeners();
        }
      };
      _controller?.addListener(_listener!);

      // Wait a short time to ensure metadata loads
      await Future.delayed(const Duration(milliseconds: 500));

      if (_controller != null) {
        duration = _controller!.metadata.duration;
        isInitialized = true;
        notifyListeners();
        play();
      }
    } catch (e) {
      debugPrint("YouTube video initialization failed: $e");
    }
  }

  void play() {
    _controller?.play();
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _controller?.pause();
    isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    isPlaying ? pause() : play();
  }

  void seekTo(Duration newPosition) {
    _controller?.seekTo(newPosition);
  }

  void disposeController() {
    if (_controller != null) {
      if (_listener != null) {
        _controller?.removeListener(_listener!);
        _listener = null;
      }
      _controller?.dispose();
      _controller = null;
      isInitialized = false;
    }
  }

  void seekForward() {
    final newPosition = position + const Duration(seconds: 10);
    _controller?.seekTo(newPosition < duration ? newPosition : duration);
  }

  void seekBackward() {
    final newPosition = position - const Duration(seconds: 10);
    _controller?.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed = speed;
    _controller?.setPlaybackRate(speed);
    notifyListeners();
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    _isMuted = _volume == 0.0;
    _controller?.setVolume((_volume * 100).toInt());
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _volume = _isMuted ? 0.0 : 1.0;
    _controller?.setVolume((_volume * 100).toInt());
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
    disposeController();
    super.dispose();
  }
}

