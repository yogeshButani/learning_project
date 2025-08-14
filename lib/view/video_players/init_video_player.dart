import 'package:flutter/material.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:learning_project/view/video_players/network_video_player/network_video_player_screen.dart';

import 'package:learning_project/view/video_players/youtube_video_player/youtube_video_player_screen.dart';


enum UrlType {
  youtube,
  vimeo,
  video,
  unknown,
}

class InitVideoScreen extends StatelessWidget {
  final String videoUrl;

  const InitVideoScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: FutureBuilder<UrlType>(
        future: videoType(),
        builder: (BuildContext context, AsyncSnapshot<UrlType> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loader while detecting video type
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading video"));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Invalid video URL",
              ),
            );
          }

          // Switch on enum directly (type-safe)
          switch (snapshot.data) {
            case UrlType.youtube:
              return YoutubeVideoPlayerScreen(
                videoUrl: videoUrl,
              );
            case UrlType.vimeo:
              return Container();
            case UrlType.video:
              return NetworkVideoPlayerScreen(
                videoUrl: videoUrl,
              );
            default:
              return const Center(
                child: Text(
                  "Unsupported video type",
                ),
              );
          }
        },
      ),
    );
  }

  Future<UrlType> videoType() async {
    return getUrlType(videoUrl);
  }
}

// Function to detect video type
UrlType getUrlType(String url) {
  final youtubePatterns = [
    RegExp(r'^https?://(www\.)?youtube\.com/', caseSensitive: false),
    RegExp(r'^https?://youtu\.be/', caseSensitive: false),
  ];
  final vimeoPattern = RegExp(
      r'^https?://(www\.)?(vimeo\.com|player\.vimeo\.com)/',
      caseSensitive: false);
  final videoPattern = RegExp(
      r'\.(mp4|avi|mkv|mov|wmv|flv|webm|m4v|3gp|asf|rm|vob|ts|f4v|ogv|divx|mpeg|mpg|swf|mxf|qt|dat|dvr-ms)$',
      caseSensitive: false);

  if (youtubePatterns.any((pattern) => pattern.hasMatch(url))) {
    return UrlType.youtube;
  } else if (vimeoPattern.hasMatch(url)) {
    return UrlType.vimeo;
  } else if (videoPattern.hasMatch(url)) {
    return UrlType.video;
  } else {
    return UrlType.unknown;
  }
}
