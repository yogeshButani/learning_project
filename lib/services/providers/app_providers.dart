import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/load_multiple_videos_provider.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
import 'package:learning_project/view/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static MultiProvider getProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => YouTubeVideoPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TrainingVideosProvider(),
        ),
      ],
      child: child,
    );
  }
}
