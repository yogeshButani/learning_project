import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:provider/provider.dart';

class AppProviders {
  static MultiProvider getProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoPlayerProvider(),
        ),
      ],
      child: child,
    );
  }
}
