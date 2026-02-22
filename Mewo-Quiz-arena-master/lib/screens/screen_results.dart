//  ÉCRAN RÉSULTATS
// Profil principal affiché direct
// Profil secondaire débloqué via email + prénom


import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/futuristic_background.dart';
import '../models/answer_record.dart';
import 'screen1_welcome.dart';


//  Modèle de profil 

class _ProfileData {
  final String title;
  final String emoji;
  final String description;
  final String formation;
  final String postes;
  final Color color;

  const _ProfileData({
    required this.title,
    required this.emoji,
    required this.description,
    required this.formation,
    required this.postes,
    required this.color,
  });
}

//  Correspondances profil brut → affichage 

_ProfileData _getProfileData(String rawProfil) {
  // Correspondances directes (niveaux 2 & 3)
  const exact = <String, _ProfileData>{
    'Technique & Opérationnel': _ProfileData(
      title: 'Technicien Opérationnel',
      emoji: '⚙️',
      description:
          'Face à la crise, vous êtes dans l\'action immédiate. Vous diagnostiquez, '
          'réparez et maintenez les systèmes en état de marche. Votre force : '
          'agir vite et efficacement sur le terrain, sans attendre.',
      formation: 'BTS SIO – SISR\n(Solutions d\'Infrastructure Systèmes et Réseaux)',
      postes: 'Technicien réseau • Administrateur systèmes • Support IT N2/N3',
      color: Color(0xFF00BCD4),
    ),
    'Conception & Stratégie': _ProfileData(
      title: 'Architecte Stratégique',
      emoji: '🧠',
      description:
          'Vous prenez du recul avant d\'agir. Vous analysez, anticipez et '
          'comprenez les systèmes dans leur globalité. Votre force : '
          'concevoir des solutions durables et anticiper les menaces.',
      formation: 'BTS SIO – SLAM\n(Solutions Logicielles et Applications Métiers)',
      postes: 'Analyste cybersécurité • Chef de projet IT • Consultant technique',
      color: Color(0xFF7C4DFF),
    ),
    'Support & Exploitation Technique': _ProfileData(
      title: 'Expert Support',
      emoji: '🛠️',
      description:
          'Vous êtes le pilier de la stabilité. Vous intervenez rapidement pour '
          'maintenir les systèmes en état de marche avec méthode et efficacité. '
          'Votre rigueur est un atout indispensable.',
      formation: 'BTS SIO – SISR\nTechnicien de maintenance informatique',
      postes: 'Support N2/N3 • Exploitation systèmes • Technicien datacenter',
      color: Color(0xFF00ACC1),
    ),
    'Analyse & Sécurité Technique': _ProfileData(
      title: 'Analyste Sécurité',
      emoji: '🔐',
      description:
          'Vous creusez, documentez, anticipez. Votre approche de la sécurité '
          'est méthodique et prospective. Vous ne corrigez pas seulement — '
          'vous prévenez et construisez des défenses durables.',
      formation: 'BTS SIO + Spécialisation Cybersécurité\nLicence Pro Sécurité des SI',
      postes: 'Analyste SOC • Pentesteur • RSSI junior • Consultant sécurité',
      color: Color(0xFF00E5FF),
    ),
  };

  if (exact.containsKey(rawProfil)) return exact[rawProfil]!;

  // Correspondances par mots-clés (niveau 1)
  final p = rawProfil.toLowerCase();

  if (p.contains('informatique') || p.contains('technologique') || p.contains('technique')) {
    return const _ProfileData(
      title: 'Profil Technologique',
      emoji: '💻',
      description:
          'Vous êtes naturellement attiré par les systèmes, les machines et les '
          'solutions numériques. Votre curiosité tech et votre logique analytique '
          'sont des atouts précieux dans les métiers du numérique.',
      formation: 'MEWO INFORMATIQUE\nBTS SIO (SISR ou SLAM)',
      postes: 'Développeur • Technicien IT • Administrateur systèmes',
      color: Color(0xFF259AB3),
    );
  }

  if (p.contains('santé') || p.contains('soin') || p.contains('empathique') || p.contains('soignant')) {
    return const _ProfileData(
      title: 'Profil Soin & Santé',
      emoji: '💊',
      description:
          'Votre sens de l\'écoute, votre empathie et votre rigueur sont des '
          'qualités fondamentales dans les métiers de la santé. Vous êtes naturellement '
          'tourné vers l\'aide aux autres.',
      formation: 'MEWO SANTÉ',
      postes: 'Aide-soignant • Assistant médical • Ambulancier',
      color: Color(0xFF4CAF50),
    );
  }

  if (p.contains('juridique') || p.contains('rigoureux') || p.contains('structuré')) {
    return const _ProfileData(
      title: 'Profil Juridique & Rigueur',
      emoji: '⚖️',
      description:
          'Vous aimez les règles, les structures et la précision. Votre sens de '
          'l\'organisation et de l\'analyse vous prédispose aux métiers du droit '
          'et de l\'administration.',
      formation: 'MEWO JURIDIQUE',
      postes: 'Secrétaire juridique • Assistant RH • Paralégal',
      color: Color(0xFF9C27B0),
    );
  }

  if (p.contains('animal') || p.contains('animalier') || p.contains('nature')) {
    return const _ProfileData(
      title: 'Profil Animalier & Nature',
      emoji: '🐾',
      description:
          'Vous avez une connexion naturelle avec le vivant. Votre patience, '
          'bienveillance et amour du monde animal sont des qualités précieuses '
          'dans les métiers animaliers.',
      formation: 'MEWO ANIMAL',
      postes: 'Toiletteur • Éducateur canin • Technicien vétérinaire',
      color: Color(0xFF66BB6A),
    );
  }

  // Fallback : service / polyvalent
  return const _ProfileData(
    title: 'Profil Service & Relation',
    emoji: '🤝',
    description:
        'Vous êtes polyvalent, adaptable et naturellement orienté vers les '
        'autres. Vous excellez dans les environnements dynamiques qui demandent '
        'contact humain et réactivité.',
    formation: 'MEWO SERVICE',
    postes: 'Commercial • Conseiller client • Chargé de relation',
    color: Color(0xFFFF9800),
  );
}


//  Écran principal 

class ScreenResults extends StatefulWidget {
  final List<AnswerRecord> answers;

  const ScreenResults({super.key, required this.answers});

  @override
  State<ScreenResults> createState() => _ScreenResultsState();
}

class _ScreenResultsState extends State<ScreenResults>
    with SingleTickerProviderStateMixin {
  //  Animations 
  late AnimationController _revealController;
  late Animation<double> _revealAnim;
  late Animation<Offset> _slideAnim;

  //  État formulaire secondaire 
  bool _showSecondaryForm = false;
  bool _secondaryUnlocked = false;
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  //  Profils calculés 
  late String _primaryProfileKey;
  String? _secondaryProfileKey;

  //  Stats 
  late Map<String, int> _profileCounts;
  late int _total;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _revealAnim =
        CurvedAnimation(parent: _revealController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _revealController, curve: Curves.easeOut));

    _calculateProfiles();
    _revealController.forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _calculateProfiles() {
    _total = widget.answers.length;
    _profileCounts = {};
    for (final a in widget.answers) {
      _profileCounts[a.profil] = (_profileCounts[a.profil] ?? 0) + 1;
    }
    final sorted = _profileCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _primaryProfileKey =
        sorted.isNotEmpty ? sorted[0].key : 'Technique & Opérationnel';
    _secondaryProfileKey = sorted.length > 1 ? sorted[1].key : null;
  }

  
  @override
  Widget build(BuildContext context) {
    final primary = _getProfileData(_primaryProfileKey);
    final secondary = _secondaryProfileKey != null
        ? _getProfileData(_secondaryProfileKey!)
        : null;

    return Scaffold(
      body: FuturisticBackground(
        primaryColor: primary.color,
        secondaryColor: const Color(0xFF1A237E),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                //  En-tête 
                FadeTransition(
                  opacity: _revealAnim,
                  child: _buildHeader(primary),
                ),

                const SizedBox(height: 20),

                //  Profil principal (toujours visible) 
                SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _revealAnim,
                    child: _buildPrimaryCard(primary),
                  ),
                ),

                const SizedBox(height: 18),

                //  Profil secondaire 
                if (secondary != null)
                  FadeTransition(
                    opacity: _revealAnim,
                    child: _buildSecondarySection(secondary),
                  ),

                const SizedBox(height: 28),

                //  Bouton recommencer 
                FadeTransition(
                  opacity: _revealAnim,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Screen1Welcome()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24, width: 1.5),
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                      child: const Text(
                        '↩  Recommencer le quiz',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  //  En-tête résultats 

  Widget _buildHeader(_ProfileData p) {
    return Column(
      children: [
        Text(
          '🎯  RÉSULTATS',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(color: p.color.withValues(alpha: 0.9), blurRadius: 24),
              Shadow(color: p.color.withValues(alpha: 0.4), blurRadius: 50),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$_total réponses analysées',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  
  //  Carte Profil Principal 

  Widget _buildPrimaryCard(_ProfileData p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.color.withValues(alpha: 0.32),
            Colors.black.withValues(alpha: 0.28),
          ],
        ),
        border: Border.all(color: p.color, width: 2),
        boxShadow: [
          BoxShadow(
              color: p.color.withValues(alpha: 0.28), blurRadius: 24, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          _Badge(label: 'PROFIL PRINCIPAL', color: p.color),

          const SizedBox(height: 16),

          // Titre profil
          Text(
            '${p.emoji}  ${p.title}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            p.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xCCFFFFFF),
              height: 1.75,
            ),
          ),

          const SizedBox(height: 16),

          // Formation
          _InfoBlock(
            icon: Icons.school_outlined,
            label: 'Formation recommandée',
            value: p.formation,
            color: p.color,
          ),

          const SizedBox(height: 10),

          // Postes
          _InfoBlock(
            icon: Icons.work_outline,
            label: 'Débouchés professionnels',
            value: p.postes,
            color: p.color,
          ),
        ],
      ),
    );
  }

  
  //  Section Profil Secondaire 

  Widget _buildSecondarySection(_ProfileData p) {
    if (_secondaryUnlocked) {
      return _buildRevealedSecondary(p);
    }
    if (_showSecondaryForm) {
      return _buildEmailForm(p);
    }
    return _buildLockedSecondary(p);
  }

  //  État verrouillé (aperçu flou) 
  Widget _buildLockedSecondary(_ProfileData p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.5),
      ),
      child: Column(
        children: [
          // Titre de section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.white38, size: 14),
              const SizedBox(width: 6),
              Text(
                'PROFIL SECONDAIRE DÉTECTÉ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.35),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Aperçu flou
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Contenu flouté
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Opacity(
                    opacity: 0.6,
                    child: Column(
                      children: [
                        Text(
                          '${p.emoji}  ${p.title}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Overlay sombre
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.lock, color: Colors.white70, size: 28),
                      const SizedBox(height: 6),
                      const Text(
                        'Profil masqué',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bouton débloquer
          GestureDetector(
            onTap: () => setState(() => _showSecondaryForm = true),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    p.color.withValues(alpha: 0.45),
                    p.color.withValues(alpha: 0.2),
                  ],
                ),
                border: Border.all(color: p.color, width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: p.color.withValues(alpha: 0.3), blurRadius: 14),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_open_rounded, color: p.color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Voir mon profil complet',
                    style: TextStyle(
                      color: p.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Formulaire email 
  Widget _buildEmailForm(_ProfileData p) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: p.color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: p.color.withValues(alpha: 0.12), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔓  Débloquer le profil secondaire',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: p.color,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Recevez vos résultats complets par email',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),

          const SizedBox(height: 20),

          // Champ prénom
          _FormField(
            controller: _prenomController,
            label: 'Prénom',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 12),

          // Champ email
          _FormField(
            controller: _emailController,
            label: 'Adresse email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              // Annuler
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showSecondaryForm = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    child: const Center(
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Valider
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _submitEmail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [p.color, p.color.withValues(alpha: 0.65)],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: p.color.withValues(alpha: 0.4), blurRadius: 14),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Voir mon profil  →',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              '🔒  Vos données ne seront pas partagées avec des tiers',
              style: TextStyle(color: Colors.white30, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  void _submitEmail() {
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();

    if (prenom.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remplissez tous les champs')),
      );
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adresse email invalide')),
      );
      return;
    }

    setState(() {
      _secondaryUnlocked = true;
      _showSecondaryForm = false;
    });
  }

  //  Profil secondaire révélé 
  Widget _buildRevealedSecondary(_ProfileData p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.color.withValues(alpha: 0.22),
            Colors.black.withValues(alpha: 0.25),
          ],
        ),
        border: Border.all(color: p.color.withValues(alpha: 0.65), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Badge(label: 'PROFIL SECONDAIRE', color: p.color),

          const SizedBox(height: 16),

          Text(
            '${p.emoji}  ${p.title}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            p.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xBFFFFFFF),
              height: 1.7,
            ),
          ),

          const SizedBox(height: 14),

          _InfoBlock(
            icon: Icons.school_outlined,
            label: 'Formation recommandée',
            value: p.formation,
            color: p.color,
          ),

          const SizedBox(height: 16),

          // Bouton "Recevoir par email"
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: p.color.withValues(alpha: 0.95),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '📧 Résultats envoyés à ${_emailController.text}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: p.color.withValues(alpha: 0.15),
                border: Border.all(color: p.color.withValues(alpha: 0.55)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email_outlined, color: p.color, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Recevoir mes résultats par email',
                    style: TextStyle(
                      color: p.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//  Widgets utilitaires 

/// Badge coloré (ex: "PROFIL PRINCIPAL")
class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/// Bloc d'information (formation / postes)
class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoBlock({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xBFFFFFFF),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Champ de formulaire stylisé
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white60, width: 1.5),
        ),
      ),
    );
  }
}