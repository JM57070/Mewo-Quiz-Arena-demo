
// FOND VIDÉO QUIZ


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'futuristic_background.dart';

class VideoBackground extends StatefulWidget {
  final Widget child;
  final int level;
  final Color primaryColor;
  final Color secondaryColor;

  const VideoBackground({
    super.key,
    required this.child,
    required this.level,
    this.primaryColor = const Color(0xFF259AB3),
    this.secondaryColor = const Color(0xFF8ac1d0),
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _videoReady = false;

  late AnimationController _overlayController;
  late Animation<double> _overlayAnim;

  String get _videoAsset => 'assets/videos/quiz_bg_level${widget.level}.mp4';

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _overlayAnim = CurvedAnimation(parent: _overlayController, curve: Curves.easeOut);
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(_videoAsset);
      await controller.initialize();
      if (!mounted) { controller.dispose(); return; }
      controller.setLooping(true);
      controller.setVolume(0);
      controller.play();
      setState(() { _controller = controller; _videoReady = true; });
    } catch (_) {
      if (mounted) setState(() => _videoReady = false);
    }
  }

  @override
  void didUpdateWidget(VideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) {
      _controller?.dispose();
      _controller = null;
      _videoReady = false;
      _initVideo();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoReady || _controller == null) {
      return FuturisticBackground(
        primaryColor: widget.primaryColor,
        secondaryColor: widget.secondaryColor,
        child: widget.child,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
        FadeTransition(
          opacity: _overlayAnim,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.40),
                  Colors.black.withValues(alpha: 0.70),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FadeTransition(
            opacity: _overlayAnim,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    widget.primaryColor.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}