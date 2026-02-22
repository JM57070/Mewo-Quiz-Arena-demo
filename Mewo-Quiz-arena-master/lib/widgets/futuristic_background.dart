
// Fond animé "cyberpunk / futuriste" pour les écrans de quiz
// Grille néon avec particules lumineuses et rayons de lumière


import 'package:flutter/material.dart';
import 'dart:math' as math;

class FuturisticBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;   // Couleur principale
  final Color secondaryColor; // Couleur secondaire

  const FuturisticBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFF259AB3),    
    this.secondaryColor = const Color(0xFF8ac1d0),  
  });

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with TickerProviderStateMixin {

  late AnimationController _gridController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    // Grille qui avance (perspective)
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Particules qui flottent
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Lueur pulsante
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gridController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond dégradé sombre
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0A0A2E),  
                  const Color(0xFF0D0D3E),
                  Color.lerp(widget.primaryColor, Colors.black, 0.85)!,
                ],
              ),
            ),
          ),
        ),

        // Grille perspective animée
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _gridController,
            builder: (_, _) => CustomPaint(
              painter: _GridPainter(
                progress: _gridController.value,
                color: widget.primaryColor,
              ),
            ),
          ),
        ),

        // Rayons de lumière verticaux
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (_, _) => CustomPaint(
              painter: _LightRayPainter(
                progress: _glowController.value,
                primary: widget.primaryColor,
                secondary: widget.secondaryColor,
              ),
            ),
          ),
        ),

        // Particules flottantes
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (_, _) => CustomPaint(
              painter: _ParticlePainter(
                progress: _particleController.value,
                color: widget.primaryColor,
              ),
            ),
          ),
        ),

        // Contenu par-dessus
        widget.child,
      ],
    );
  }
}


// Grille perspective sol cyber

class _GridPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GridPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final horizon = size.height * 0.55; // Ligne d'horizon
    final numLines = 12;
    // Lignes horizontales (perspective)
    for (int i = 0; i <= numLines; i++) {
      // Le décalage crée l'effet de mouvement vers le bas
      double t = (i / numLines + progress) % 1.0;
      // Perspective : les lignes s'écartent vers le bas
      double y = horizon + (size.height - horizon) * (t * t);

      double opacity = t * 0.5;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint..color = color.withValues(alpha: opacity),
      );
    }

    // Lignes verticales (fuyantes vers le centre)
    final numVertical = 10;
    for (int i = -numVertical ~/ 2; i <= numVertical ~/ 2; i++) {
      double xBottom = cx + (i / (numVertical / 2)) * size.width * 0.6;
      canvas.drawLine(
        Offset(cx, horizon),
        Offset(xBottom, size.height),
        paint..color = color.withValues(alpha: 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.progress != progress;
}


// Rayons de lumière verticaux pulsants

class _LightRayPainter extends CustomPainter {
  final double progress;
  final Color primary;
  final Color secondary;

  _LightRayPainter({
    required this.progress,
    required this.primary,
    required this.secondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Rayon central (blanc → couleur principale)
    final centerRay = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          primary.withValues(alpha: 0.15 + 0.1 * progress),
          Colors.white.withValues(alpha: 0.05 + 0.05 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.4),
        width: 80 + 20 * progress,
        height: size.height * 0.8,
      ),
      centerRay,
    );

    // Rayon secondaire (gauche)
    final sideRay = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          secondary.withValues(alpha: 0.1 + 0.08 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * 0.3),
        width: 30,
        height: size.height * 0.6,
      ),
      sideRay,
    );

    // Rayon droit
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.35),
        width: 25,
        height: size.height * 0.55,
      ),
      sideRay,
    );
  }

  @override
  bool shouldRepaint(covariant _LightRayPainter old) => old.progress != progress;
}


// Particules flottantes (petits points lumineux)

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  static final _random = math.Random(42); // Seed fixe = positions cohérentes
  static final List<_Particle> _particles = List.generate(
    25,
    (i) => _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      speed: 0.1 + _random.nextDouble() * 0.3,
      size: 1.5 + _random.nextDouble() * 3,
      phase: _random.nextDouble(),
    ),
  );

  _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      // La particule remonte doucement, puis recommence en bas
      double y = (p.y - progress * p.speed + p.phase) % 1.0;
      double x = p.x + 0.03 * math.sin(progress * 2 * math.pi + p.phase * 10);

      double opacity = math.sin(progress * math.pi * 2 + p.phase * math.pi) * 0.4 + 0.4;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        Paint()..color = color.withValues(alpha: opacity.clamp(0.1, 0.8)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, speed, size, phase;
  const _Particle({
    required this.x, required this.y,
    required this.speed, required this.size, required this.phase,
  });
}