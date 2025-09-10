import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/app_providers.dart';
import 'package:learning_project/view/themes/theme_provider.dart';
import 'package:learning_project/view/themes/theme_settings_screen.dart';
import 'package:learning_project/view/video_players/reels_test_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    AppProviders.getProviders(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Testing App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor, // app primary color
          surface: Color(0xFFFFFFFF), // for background
          onSurface: Colors.black, // for texts, icons
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor, // app primary color
          surface: Color(0xFF2A2525), // for background
          onSurface: Colors.white, // for texts, icons
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, widget) {
        return ScrollConfiguration(
          behavior: const ScrollBehaviorModified(),
          child: widget!,
        );
      },
      home: const ReelsTestScreen(),
    );
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics());
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
