import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/utils/my_app_bar.dart';
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
  late VideoPlayerProvider _networkVideoPlayer;

  @override
  void initState() {
    super.initState();
    // We can’t use context.read here yet, so we delay it to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _networkVideoPlayer =
          Provider.of<VideoPlayerProvider>(context, listen: false);
      _networkVideoPlayer.init(widget.videoUrl);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _networkVideoPlayer.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoPlayerProvider>();
    if (!provider.isInitialized || provider.player == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio:
                    provider.player?.controller.value.aspectRatio ?? 9 / 16,
                child: VideoPlayer(
                  provider.player!.controller,
                ),
              ),
            ),
            NetworkVideoControlsOverlay(
              onToggleOrientation: () => provider.toggleOrientation(),
              header: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: MyAppbar(
                  title: '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
