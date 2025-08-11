import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learning_project/services/providers/network_video_player_provider.dart';
import 'package:learning_project/utils/app_colors.dart';
import 'package:learning_project/view/network_video_player/network_playback_speed_controller.dart';
import 'package:learning_project/view/network_video_player/network_volume_controller.dart';
import 'package:provider/provider.dart';

class NetworkVideoControlsOverlay extends StatefulWidget {
  final VoidCallback onToggleOrientation;

  const NetworkVideoControlsOverlay({super.key, required this.onToggleOrientation});

  @override
  State<NetworkVideoControlsOverlay> createState() => _NetworkVideoControlsOverlayState();
}

class _NetworkVideoControlsOverlayState extends State<NetworkVideoControlsOverlay> {
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
    final provider = context.watch<VideoPlayerProvider>();

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
              // Center Play/Pause
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
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black87.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.replay_10,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Play/Pause button
                  GestureDetector(
                    onTap: () {
                      provider.togglePlayPause();
                      _startHideTimer();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black87.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        provider.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // +10 seconds button
                  GestureDetector(
                    onTap: () {
                      provider.seekForward();
                      _startHideTimer();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black87.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.forward_10,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),

              // Bottom Controls
              Positioned(
                bottom: 30,
                left: 15,
                right: 15,
                child: Column(
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
                              child: const Icon(Icons.screen_rotation,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              spacing: 30,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) => NetworkVolumeControlSheet(),
                                    );
                                  },
                                  child: Icon(
                                    provider.isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => const NetworkPlaybackSpeedController(),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Slider + Time
                    Row(
                      children: [
                        Text(
                          _formatDuration(provider.position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Transform.scale(
                            scale: 1.11,
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
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }
}
