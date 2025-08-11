import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_project/services/providers/youtube_video_player_provider.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:learning_project/view/youtube_video_player/youtube_playback_speed_controller.dart';
import 'package:learning_project/view/youtube_video_player/youtube_volume_controller.dart';
import 'package:provider/provider.dart';

class YoutubeVideoControlsOverlay extends StatefulWidget {
  final VoidCallback onToggleOrientation;
  final Widget? header;

  const YoutubeVideoControlsOverlay({
    super.key,
    required this.onToggleOrientation,
    this.header,
  });

  @override
  State<YoutubeVideoControlsOverlay> createState() =>
      _YoutubeVideoControlsOverlayState();
}

class _YoutubeVideoControlsOverlayState
    extends State<YoutubeVideoControlsOverlay> {
  bool _visible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() => _visible = !_visible);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<YouTubeVideoPlayerProvider>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showControlsTemporarily,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !_visible,
          child: Stack(
            children: [
              widget.header ?? SizedBox.shrink(),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: [
                  // -10 seconds button
                  GestureDetector(
                    onTap: () {
                      provider.seekBackward();
                      _startHideTimer();
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_video_backward.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  // Play/Pause button
                  GestureDetector(
                    onTap: () {
                      provider.togglePlayPause();
                      _startHideTimer();
                    },
                    child: SvgPicture.asset(
                      provider.isPlaying
                          ? 'assets/images/ic_video_pause.svg'
                          : 'assets/images/ic_video_play.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  // +10 seconds button
                  GestureDetector(
                    onTap: () {
                      provider.seekForward();
                      _startHideTimer();
                    },
                    child: SvgPicture.asset(
                      'assets/images/ic_video_forward.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              )),

              // Bottom Controls
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Column(
                  spacing: 10,
                  children: [
                    // Orientation Button
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              onTap: widget.onToggleOrientation,
                              behavior: HitTestBehavior.translucent,
                              child: SvgPicture.asset(
                                provider.isLandscape
                                    ? 'assets/images/ic_video_screen_rotate_undo.svg'
                                    : 'assets/images/ic_video_screen_rotate.svg',
                                height: 30,
                                width: 30,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 15,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) =>
                                          YoutubeVolumeControlSheet(),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    provider.isMuted
                                        ? 'assets/images/ic_video_volume_mute.svg'
                                        : 'assets/images/ic_video_volume_unmute.svg',
                                    height: 30,
                                    width: 30,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) =>
                                          const YoutubePlaybackSpeedController(),
                                    );
                                  },
                                  child: Text(
                                    '${provider.playbackSpeed}X',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          _formatDuration(provider.position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: provider.position.inSeconds
                                .clamp(0, provider.duration.inSeconds)
                                .toDouble(),
                            max: provider.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              provider
                                  .seekTo(Duration(seconds: value.toInt()));
                              _startHideTimer();
                            },
                            activeColor: AppColors.appColor,
                            inactiveColor: Colors.white54,
                          ),
                        ),
                        Text(
                          _formatDuration(provider.duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes; // total minutes
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
