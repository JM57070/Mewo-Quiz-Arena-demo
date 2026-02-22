
// PAGE D'ACCUEIL



import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widgets/mewo_widgets.dart';
import 'screen_quiz.dart';

class Screen1Welcome extends StatefulWidget {
  const Screen1Welcome({super.key});

  @override
  State<Screen1Welcome> createState() => _Screen1WelcomeState();
}

class _Screen1WelcomeState extends State<Screen1Welcome>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _videoReady = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeInAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeInAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller =
          VideoPlayerController.asset('assets/videos/welcome_bg.mp4');
      await controller.initialize();
      if (!mounted) { controller.dispose(); return; }
      controller.setLooping(true);
      controller.setVolume(0);
      await controller.play();
      setState(() { _videoController = controller; _videoReady = true; });
    } catch (e) {
      debugPrint('Video absente, fallback: $e');
      if (mounted) setState(() => _videoReady = false);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, secondAnim) => const ScreenQuiz(),
        transitionsBuilder: (ctx, anim, secondAnim, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Color(0x44000000), Color(0xBB000000)],
              ),
            ),
          ),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  FadeTransition(opacity: _fadeInAnim, child: const MewoLogo()),
                  const Spacer(),
                  FadeTransition(
                    opacity: _fadeInAnim,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                      ).createShader(bounds),
                      child: const Text(
                        'QUIZ ARENA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900,
                          color: Colors.white, letterSpacing: 6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _fadeInAnim,
                    child: const Text(
                      '15 questions  •  3 niveaux',
                      style: TextStyle(fontSize: 13, color: Colors.white60, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 55),
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: MewoButton(label: '🔍  JOUER', fontSize: 28, onTap: _startQuiz),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_videoReady && _videoController != null) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5BB8F5), Color(0xFF87CEEB), Color(0xFFD4A574)],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}