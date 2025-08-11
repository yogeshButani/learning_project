import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
import 'package:learning_project/view/youtube_video_player/youtube_video_player_controllers.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const YoutubeVideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<YoutubeVideoPlayerScreen> createState() => _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<YouTubeVideoPlayerProvider>().init(widget.videoUrl);
  }

  @override
  void dispose() {
    context.read<YouTubeVideoPlayerProvider>().disposeController();
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: YoutubePlayer(
              controller: provider.controller,
              showVideoProgressIndicator: false,
              topActions: [],
              bottomActions: [],
            ),
          ),
          YoutubeVideoControlsOverlay(onToggleOrientation: () {}),
        ],
      ),
    );
  }
}


