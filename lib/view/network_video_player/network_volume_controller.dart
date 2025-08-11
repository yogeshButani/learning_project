import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:provider/provider.dart';

class NetworkVolumeControlSheet extends StatefulWidget {
  const NetworkVolumeControlSheet({super.key});

  @override
  State<NetworkVolumeControlSheet> createState() => _NetworkVolumeControlSheetState();
}

class _NetworkVolumeControlSheetState extends State<NetworkVolumeControlSheet> {
  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoPlayerProvider>();

    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 15,
        children: [
          const Text(
            "Volume Control",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  videoProvider.isMuted ? Icons.volume_off : Icons.volume_up,
                  size: 30,
                ),
                onPressed: () {
                  videoProvider.toggleMute();
                },
              ),
              Expanded(
                child: Slider(
                  value: videoProvider.volume,
                  min: 0.0,
                  max: 1.0,
                  activeColor: AppColors.appColor,
                  inactiveColor: Colors.black87,
                  onChanged: (value) {
                    videoProvider.setVolume(value);
                  },
                ),
              ),
              Text(
                "${(videoProvider.volume * 100).round()}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
