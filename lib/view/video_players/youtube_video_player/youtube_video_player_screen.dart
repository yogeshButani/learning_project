import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
import 'package:learning_project/utils/my_app_bar.dart';
import 'package:learning_project/view/video_players/youtube_video_player/youtube_video_player_controllers.dart';

import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  late YouTubeVideoPlayerProvider _youtubeProvider;

  @override
  void initState() {
    super.initState();
    // We can’t use context.read here yet, so we delay it to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _youtubeProvider =
          Provider.of<YouTubeVideoPlayerProvider>(context, listen: false);
      _youtubeProvider.init(widget.videoUrl);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _youtubeProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<YouTubeVideoPlayerProvider>();

    if (!provider.isInitialized) {
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
              child: YoutubePlayer(
                controller: provider.controller!,
                showVideoProgressIndicator: false,
                topActions: [],
                bottomActions: [],
              ),
            ),
            YoutubeVideoControlsOverlay(
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
