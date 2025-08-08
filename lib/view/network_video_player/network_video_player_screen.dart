import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/view/network_video_player/network_video_player_controllers.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const NetworkVideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<NetworkVideoPlayerScreen> createState() =>
      _NetworkVideoPlayerScreenState();
}

class _NetworkVideoPlayerScreenState extends State<NetworkVideoPlayerScreen> {
  bool isLandscape = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoPlayerProvider>().init(widget.videoUrl);
    });
  }

  void toggleOrientation() {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    setState(() => isLandscape = !isLandscape);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    context.read<VideoPlayerProvider>().disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoPlayerProvider>();

    if (!provider.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: provider.player.controller.value.aspectRatio,
              child: VideoPlayer(
                provider.player.controller,
              ),
            ),
          ),
          VideoControlsOverlay(
            onToggleOrientation: toggleOrientation,
          ),
        ],
      ),
    );
  }
}
