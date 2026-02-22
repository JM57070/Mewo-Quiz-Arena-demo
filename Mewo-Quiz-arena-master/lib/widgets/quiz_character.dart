
// Personnages interactifs animés pour les pages Synopsis
// Chaque scénario a son personnage, son humeur et sa position


import 'package:flutter/material.dart';
import 'dart:math' as math;


//  Modèle de personnage 

enum CharacterMood {
  confused,    // Directeur : silencé, regard perdu
  scared,      // Collègue : larmes, panique
  angry,       // Cadre : accuse, pointe
  panic,       // Employé : bras en l'air
  mysterious,  // Hacker : encapuchonné, yeux verts
  alert,       // Technicien : alerte, en action
  focused,     // Analyste : concentré
  stressed,    // Sys Admin : épuisé
  suspicious,  // Sécurité : méfiant
}

class CharacterConfig {
  final String name;
  final CharacterMood mood;
  final bool fromLeft;      // true = entre par la gauche
  final String? imagePath; // chemin vers une image asset pour ce personnage

  const CharacterConfig({
    required this.name,
    required this.mood,
    this.fromLeft = true,
    this.imagePath,
  });
}

//  Mapping niveau + question → personnage 
const Map<String, CharacterConfig> _characterMap = {
  '2-1': CharacterConfig(
    name: 'Directeur',
    mood: CharacterMood.confused,
    fromLeft: true,
  ),
  '2-2': CharacterConfig(
    name: 'Sarah',
    mood: CharacterMood.scared,
    fromLeft: false,
  ),
  '2-3': CharacterConfig(
    name: 'M. Renaud',
    mood: CharacterMood.angry,
    fromLeft: true,
  ),
  '2-4': CharacterConfig(
    name: 'L\'Équipe',
    mood: CharacterMood.panic,
    fromLeft: false,
  ),
  '2-5': CharacterConfig(
    name: '???',
    mood: CharacterMood.mysterious,
    fromLeft: true,
  ),
  '3-1': CharacterConfig(
    name: 'Technicien',
    mood: CharacterMood.alert,
    fromLeft: false,
  ),
  '3-2': CharacterConfig(
    name: 'Analyste',
    mood: CharacterMood.focused,
    fromLeft: true,
  ),
  '3-3': CharacterConfig(
    name: 'Sys Admin',
    mood: CharacterMood.stressed,
    fromLeft: false,
  ),
  '3-4': CharacterConfig(
    name: 'RSSI',
    mood: CharacterMood.suspicious,
    fromLeft: true,
  ),
  '3-5': CharacterConfig(
    name: '???',
    mood: CharacterMood.mysterious,
    fromLeft: false,
  ),
};

CharacterConfig? getCharacterForScene(int level, int questionIndex) {
  final key = '$level-${questionIndex + 1}';
  return _characterMap[key];
}


//  Widget principal 

class QuizCharacter extends StatefulWidget {
  final int level;
  final int questionIndex;
  final Color primaryColor;

  const QuizCharacter({
    super.key,
    required this.level,
    required this.questionIndex,
    required this.primaryColor,
  });

  @override
  State<QuizCharacter> createState() => _QuizCharacterState();
}

class _QuizCharacterState extends State<QuizCharacter>
    with TickerProviderStateMixin {

  late AnimationController _entryController;
  late AnimationController _idleController;
  late AnimationController _reactionController;

  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _idleAnim;       // oscillation douce
  late Animation<double> _reactionAnim;

  CharacterConfig? _config;

  @override
  void initState() {
    super.initState();
    _config = getCharacterForScene(widget.level, widget.questionIndex);

    //  Entrée en scène 
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    final fromLeft = _config?.fromLeft ?? true;
    _slideAnim = Tween<Offset>(
      begin: Offset(fromLeft ? -1.5 : 1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    ));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    //  Animation idle (flottement) 
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _idleAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    //  Réaction sur tap 
    _reactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _reactionAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _reactionController,
        curve: Curves.elasticOut,
      ),
    );

    // Lancer l'entrée avec un léger délai
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void didUpdateWidget(QuizCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionIndex != widget.questionIndex ||
        oldWidget.level != widget.level) {
      _config = getCharacterForScene(widget.level, widget.questionIndex);
      _entryController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _idleController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  void _onTap() {
    _reactionController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_idleAnim, _reactionAnim]),
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, _idleAnim.value),
                child: Transform.scale(
                  scale: _reactionAnim.value,
                  child: _CharacterBody(
                    config: _config!,
                    primaryColor: widget.primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


//  Corps du personnage (dessin Flutter) 

class _CharacterBody extends StatelessWidget {
  final CharacterConfig config;
  final Color primaryColor;

  const _CharacterBody({
    required this.config,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (config.imagePath != null) {
      return _buildWithImage();
    }
    return _buildDrawnCharacter();
  }

  Widget _buildWithImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          config.imagePath!,
          height: 140,
          errorBuilder: (ctx, err, _) => _buildDrawnCharacter(),
        ),
        const SizedBox(height: 4),
        _NameTag(name: config.name, color: primaryColor),
      ],
    );
  }

  Widget _buildDrawnCharacter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 140,
          child: CustomPaint(
            painter: _CharacterPainter(
              mood: config.mood,
              color: _moodColor(config.mood, primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 4),
        _NameTag(name: config.name, color: _moodColor(config.mood, primaryColor)),
      ],
    );
  }

  Color _moodColor(CharacterMood mood, Color fallback) {
    switch (mood) {
      case CharacterMood.angry:      return const Color(0xFFEF5350);
      case CharacterMood.scared:     return const Color(0xFFFFB74D);
      case CharacterMood.mysterious: return const Color(0xFF00E5FF);
      case CharacterMood.panic:      return const Color(0xFFFF7043);
      case CharacterMood.focused:    return const Color(0xFF66BB6A);
      case CharacterMood.alert:      return const Color(0xFFFFCA28);
      case CharacterMood.stressed:   return const Color(0xFFAB47BC);
      case CharacterMood.suspicious: return const Color(0xFF26C6DA);
      case CharacterMood.confused:   return fallback;
    }
  }
}


//  CustomPainter : dessin du personnage selon l'humeur 

class _CharacterPainter extends CustomPainter {
  final CharacterMood mood;
  final Color color;

  _CharacterPainter({required this.mood, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    //  Corps 
    final bodyColor = color.withValues(alpha: 0.85);
    final skinColor = const Color(0xFFFFDDCC);
    final darkerBody = Color.lerp(color, Colors.black, 0.25)!;

    // Corps (rectangle arrondi)
    paint.color = bodyColor;
    if (mood == CharacterMood.mysterious) {
      // Hacker : manteau sombre avec capuche
      _drawHacker(canvas, size, paint, color);
      return;
    }

    // Jambes
    paint.color = darkerBody;
    final legW = size.width * 0.18;
    final legH = size.height * 0.28;
    final legTop = size.height * 0.65;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.27, legTop, legW, legH),
        const Radius.circular(6),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.52, legTop, legW, legH),
        const Radius.circular(6),
      ),
      paint,
    );

    // Torse
    paint.color = bodyColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.38, size.width * 0.6, size.height * 0.3),
        const Radius.circular(10),
      ),
      paint,
    );

    // Bras (selon humeur)
    paint.color = bodyColor;
    _drawArms(canvas, size, paint, mood);

    // Tête
    paint.color = skinColor;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.24),
      size.width * 0.23,
      paint,
    );

    // Cheveux
    paint.color = _hairColor(mood);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.24),
        radius: size.width * 0.23,
      ),
      math.pi,
      math.pi,
      false,
      paint..style = PaintingStyle.fill,
    );

    // Visage (yeux + bouche)
    _drawFace(canvas, size, mood);
  }

  void _drawArms(Canvas canvas, Size size, Paint paint, CharacterMood mood) {
    final armW = size.width * 0.12;
    final armH = size.height * 0.22;
    final armTop = size.height * 0.40;

    switch (mood) {
      case CharacterMood.angry:
        // Bras gauche levé (accuse)
        paint.color = paint.color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.06, size.height * 0.20, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.82, armTop, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
      case CharacterMood.panic:
        // Bras levés
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.05, size.height * 0.18, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.83, size.height * 0.18, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
      default:
        // Bras normaux le long du corps
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.06, armTop, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.82, armTop, armW, armH),
            const Radius.circular(6),
          ),
          paint,
        );
    }
  }

  void _drawFace(Canvas canvas, Size size, CharacterMood mood) {
    final eyePaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final cy = size.height * 0.24;
    final eyeR = size.width * 0.035;
    final eyeY = cy - size.width * 0.04;

    switch (mood) {
      case CharacterMood.scared:
        // Yeux grands ouverts
        canvas.drawCircle(Offset(cx - size.width * 0.09, eyeY), eyeR * 1.5, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.09, eyeY), eyeR * 1.5, eyePaint);
        // Larme
        final tearPaint = Paint()..color = const Color(0xFF64B5F6);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx - size.width * 0.09, eyeY + eyeR * 2.5),
            width: eyeR * 0.8,
            height: eyeR * 1.5,
          ),
          tearPaint,
        );
        // Bouche tremblante (courbe vers le bas)
        final mouthPaint = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        final path = Path();
        path.moveTo(cx - size.width * 0.1, cy + size.width * 0.08);
        path.quadraticBezierTo(cx, cy + size.width * 0.14,
            cx + size.width * 0.1, cy + size.width * 0.08);
        canvas.drawPath(path, mouthPaint);

      case CharacterMood.angry:
        // Sourcils froncés
        final browPaint = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cx - size.width * 0.14, eyeY - eyeR * 1.5),
          Offset(cx - size.width * 0.04, eyeY - eyeR * 0.5),
          browPaint,
        );
        canvas.drawLine(
          Offset(cx + size.width * 0.14, eyeY - eyeR * 1.5),
          Offset(cx + size.width * 0.04, eyeY - eyeR * 0.5),
          browPaint,
        );
        canvas.drawCircle(Offset(cx - size.width * 0.09, eyeY), eyeR, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.09, eyeY), eyeR, eyePaint);
        // Bouche en ligne droite
        canvas.drawLine(
          Offset(cx - size.width * 0.09, cy + size.width * 0.1),
          Offset(cx + size.width * 0.09, cy + size.width * 0.1),
          browPaint,
        );

      case CharacterMood.confused:
        // Yeux normaux + point d'interrogation
        canvas.drawCircle(Offset(cx - size.width * 0.09, eyeY), eyeR, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.09, eyeY), eyeR, eyePaint);
        // Sourcil relevé d'un côté
        final browPaint2 = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cx + size.width * 0.04, eyeY - eyeR * 2),
          Offset(cx + size.width * 0.14, eyeY - eyeR * 3),
          browPaint2,
        );
        // Bouche en vague
        final mouthPaint = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        final path = Path();
        path.moveTo(cx - size.width * 0.1, cy + size.width * 0.1);
        path.quadraticBezierTo(cx - size.width * 0.02, cy + size.width * 0.07,
            cx + size.width * 0.02, cy + size.width * 0.1);
        path.quadraticBezierTo(cx + size.width * 0.08, cy + size.width * 0.13,
            cx + size.width * 0.1, cy + size.width * 0.1);
        canvas.drawPath(path, mouthPaint);

      case CharacterMood.focused:
        // Yeux mi-clos concentrés
        final linePaint = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(cx - size.width * 0.14, eyeY),
          Offset(cx - size.width * 0.04, eyeY),
          linePaint,
        );
        canvas.drawLine(
          Offset(cx + size.width * 0.04, eyeY),
          Offset(cx + size.width * 0.14, eyeY),
          linePaint,
        );
        // Bouche neutre
        canvas.drawLine(
          Offset(cx - size.width * 0.07, cy + size.width * 0.1),
          Offset(cx + size.width * 0.07, cy + size.width * 0.1),
          linePaint,
        );

      default:
        // Yeux standards
        canvas.drawCircle(Offset(cx - size.width * 0.09, eyeY), eyeR, eyePaint);
        canvas.drawCircle(Offset(cx + size.width * 0.09, eyeY), eyeR, eyePaint);
        // Bouche légèrement souriante
        final smilePaint = Paint()
          ..color = const Color(0xFF333333)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        final path = Path();
        path.moveTo(cx - size.width * 0.08, cy + size.width * 0.09);
        path.quadraticBezierTo(cx, cy + size.width * 0.14,
            cx + size.width * 0.08, cy + size.width * 0.09);
        canvas.drawPath(path, smilePaint);
    }
  }

  void _drawHacker(Canvas canvas, Size size, Paint paint, Color color) {
    // Silhouette sombre mystérieuse

    // Manteau long
    paint.color = const Color(0xFF1A1A2E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.30, size.width * 0.70, size.height * 0.65),
        const Radius.circular(8),
      ),
      paint,
    );

    // Capuche
    paint.color = const Color(0xFF16213E);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.25),
        width: size.width * 0.60,
        height: size.width * 0.55,
      ),
      paint,
    );

    // Visage dans l'ombre
    paint.color = const Color(0xFF0A0A1A);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.26),
        width: size.width * 0.38,
        height: size.width * 0.30,
      ),
      paint,
    );

    // Yeux qui brillent (vert néon)
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      Offset(size.width * 0.40, size.height * 0.25),
      size.width * 0.05,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.25),
      size.width * 0.05,
      glowPaint,
    );
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.40, size.height * 0.25),
      size.width * 0.03,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.25),
      size.width * 0.03,
      eyePaint,
    );

    // Lueur autour du personnage
    final auroraPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.55),
        width: size.width * 0.8,
        height: size.height * 0.75,
      ),
      auroraPaint,
    );
  }

  Color _hairColor(CharacterMood mood) {
    switch (mood) {
      case CharacterMood.angry:    return const Color(0xFF5D4037);
      case CharacterMood.scared:   return const Color(0xFFFFB300);
      case CharacterMood.stressed: return const Color(0xFF757575);
      default:                     return const Color(0xFF4E342E);
    }
  }

  @override
  bool shouldRepaint(_CharacterPainter old) =>
      old.mood != mood || old.color != color;
}


//  Tag nom sous le personnage 

class _NameTag extends StatelessWidget {
  final String name;
  final Color color;

  const _NameTag({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


//  Bulle de réaction (emoji réaction au tap) 

class ReactionBubble extends StatefulWidget {
  final CharacterMood mood;
  final Color color;

  const ReactionBubble({super.key, required this.mood, required this.color});

  @override
  State<ReactionBubble> createState() => _ReactionBubbleState();
}

class _ReactionBubbleState extends State<ReactionBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _anim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _emoji {
    switch (widget.mood) {
      case CharacterMood.confused:   return '❓';
      case CharacterMood.scared:     return '😱';
      case CharacterMood.angry:      return '😠';
      case CharacterMood.panic:      return '🚨';
      case CharacterMood.mysterious: return '👁️';
      case CharacterMood.alert:      return '⚡';
      case CharacterMood.focused:    return '🔍';
      case CharacterMood.stressed:   return '💦';
      case CharacterMood.suspicious: return '🕵️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.15),
          border: Border.all(color: widget.color.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
                color: widget.color.withValues(alpha: 0.3), blurRadius: 10),
          ],
        ),
        child: Text(_emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}