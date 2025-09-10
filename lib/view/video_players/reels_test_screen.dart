import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/load_multiple_videos_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ReelsTestScreen extends StatefulWidget {
  const ReelsTestScreen({super.key});

  @override
  State<ReelsTestScreen> createState() => _ReelsTestScreenState();
}

class _ReelsTestScreenState extends State<ReelsTestScreen> {
  final PageController _pageController = PageController();

  final List<String> videoUrls = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<TrainingVideosProvider>(context, listen: false);
      provider.preload(videoUrls, currentIndex);

      // Play first video automatically
      final player = provider.getPlayer(videoUrls[currentIndex]);
      if (player != null && provider.isInitialized(videoUrls[currentIndex])) {
        player.controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);

          final provider =
          Provider.of<TrainingVideosProvider>(context, listen: false);

          // Pause all old videos
          provider.pauseAll();

          // Preload current + next N videos
          provider.preload(videoUrls, index);

          // Auto-play current
          final player = provider.getPlayer(videoUrls[index]);
          if (player != null && provider.isInitialized(videoUrls[index])) {
            player.controller.play();
          }
        },
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              ReelsVideoWidget(videoUrl: videoUrls[index]),
              Positioned(
                bottom: 40,
                left: 20,
                child: Text(
                  "Video ${index + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ReelsVideoWidget extends StatelessWidget {
  final String videoUrl;

  const ReelsVideoWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingVideosProvider>(context);
    final player = provider.getPlayer(videoUrl);
    final initialized = provider.isInitialized(videoUrl);

    if (!initialized || player == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        if (player.controller.value.isPlaying) {
          player.controller.pause();
        } else {
          player.controller.play();
        }
      },
      child: AspectRatio(
        aspectRatio: player.controller.value.aspectRatio,
        child: VideoPlayer(player.controller),
      ),
    );
  }
}