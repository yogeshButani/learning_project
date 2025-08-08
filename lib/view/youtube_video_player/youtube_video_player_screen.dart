import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final provider = context.read<YouTubeVideoPlayerProvider>();
    provider.initialize(widget.videoUrl);

    return Consumer<YouTubeVideoPlayerProvider>(
      builder: (context, p, child) {
        return Column(
          children: [
            YoutubePlayer(
              controller: p.controller,
              showVideoProgressIndicator: false,
              topActions: [],
              bottomActions: [],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    p.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: p.playPause,
                ),
                IconButton(
                  icon: Icon(
                    p.isMuted ? Icons.volume_off : Icons.volume_up,
                  ),
                  onPressed: p.toggleMute,
                ),
                Expanded(
                  child: Slider(
                    value: p.volume,
                    min: 0,
                    max: 100,
                    onChanged: p.setVolume,
                  ),
                ),
              ],
            ),
            Slider(
              value: p.currentPosition.inSeconds.toDouble(),
              max: p.totalDuration.inSeconds.toDouble(),
              onChanged: (value) {
                p.seekTo(Duration(seconds: value.toInt()));
              },
            ),
          ],
        );
      },
    );
  }
}
