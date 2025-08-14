import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:provider/provider.dart';

class YoutubeVolumeControlSheet extends StatefulWidget {
  const YoutubeVolumeControlSheet({super.key});

  @override
  State<YoutubeVolumeControlSheet> createState() =>
      _YoutubeVolumeControlSheetState();
}

class _YoutubeVolumeControlSheetState extends State<YoutubeVolumeControlSheet> {
  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<YouTubeVideoPlayerProvider>();

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
              SvgPicture.asset(
                videoProvider.isMuted
                    ? 'assets/images/ic_video_volume_mute.svg'
                    : 'assets/images/ic_video_volume_unmute.svg',
                height: 25,
                width: 25,
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
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
                    color: AppColors.textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
