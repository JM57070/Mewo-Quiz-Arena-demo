// Logo MEWO réutilisable affiché en haut de chaque écran


import 'package:flutter/material.dart';

class MewoLogo extends StatelessWidget {
  const MewoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icône du logo 
        Image.asset(
          'assets/images/logo_mewo.png',
          height: 80,
          errorBuilder: (_, _, _) => _buildFallbackLogo(),
        ),

        //Texte "mewo Campus Métiers" style 3D
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFFF5722)],
          ).createShader(bounds),
          child: const Text(
            'mewo Campus\nMétiers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white, 
              height: 1.1,
              shadows: [
                Shadow(offset: Offset(3, 3), color: Colors.black54, blurRadius: 4),
                Shadow(offset: Offset(-1, -1), color: Color(0xFF006400), blurRadius: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Logo de secours si l'image s'affiche pas 
  Widget _buildFallbackLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _colorBlock(Colors.blue, 20, 30),
        _colorBlock(Colors.green, 16, 24),
        const SizedBox(width: 4),
        _colorBlock(Colors.pink, 16, 24),
        _colorBlock(Colors.orange, 12, 30),
        _colorBlock(Colors.red, 16, 20),
      ],
    );
  }

  Widget _colorBlock(Color color, double w, double h) {
    return Container(
      width: w, height: h,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}


// Bouton ovale transparent style MEWO

class MewoButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double fontSize;

  const MewoButton({
    super.key,
    required this.label,
    required this.onTap,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white.withValues(alpha: 0.3),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: const [
              Shadow(offset: Offset(1, 1), color: Colors.black87, blurRadius: 2),
            ],
          ),
        ),
      ),
    );
  }
}


// Bouton flèche "suivant" pour avancer dans les écrans du quiz

class NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withValues(alpha: 0.7),
          border: Border.all(color: Colors.white70, width: 2),
        ),
        child: const Icon(Icons.double_arrow, color: Colors.white, size: 28),
      ),
    );
  }
}