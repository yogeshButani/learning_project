import 'package:flutter/material.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoPlayerScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
