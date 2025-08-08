import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:provider/provider.dart';

class PlaybackSpeedController extends StatefulWidget {
  const PlaybackSpeedController({super.key});

  @override
  State<PlaybackSpeedController> createState() => _PlaybackSpeedControllerState();
}

class _PlaybackSpeedControllerState extends State<PlaybackSpeedController> {
  final List<double> speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final playbackSpeedProvider = context.watch<VideoPlayerProvider>();
    final selectedSpeed = playbackSpeedProvider.playbackSpeed;

    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Playback Speed",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: speeds.map((speed) {
              final isSelected = speed == selectedSpeed;
              return GestureDetector(
                onTap: () {
                  playbackSpeedProvider.setPlaybackSpeed(speed);
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.appColor
                        : Colors.grey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${speed}x",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}