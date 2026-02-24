// ============================================================
// screens/screen_results.dart — ÉCRAN RÉSULTATS v4
// Reçoit dominantPole + metierGroup de screen_quiz.dart
// Mappe vers les 16 profils formations MEWO réels
// Profil principal affiché direct
// Profil secondaire débloqué via email + prénom
// ============================================================

import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/futuristic_background.dart';
import '../models/answer_record.dart';
import 'screen1_welcome.dart';

// ================================================================
// ---- Modèle de profil ----

class _ProfileData {
  final String title;
  final String emoji;
  final String description;
  final String formation;
  final String niveau;
  final String postes;
  final Color color;

  const _ProfileData({
    required this.title,
    required this.emoji,
    required this.description,
    required this.formation,
    required this.niveau,
    required this.postes,
    required this.color,
  });
}

// ================================================================
// ---- Mapping v4 : pôle + groupe + typeN3 → profil MEWO réel ----

_ProfileData _getProfileFromV4(String pole, String metierGroup, String typeN3) {
  final key = '${pole}_${metierGroup}_$typeN3';

  switch (key) {
    case 'info_terrain_A':
      return const _ProfileData(
        title: 'Technicien Informatique',
        emoji: '🖥️',
        description:
            'Tu es dans l\'action terrain. Tu diagnostiques, dépannes et maintiens '
            'les systèmes en état de marche avec réactivité et polyvalence. '
            'Ton atout : intervenir vite et efficacement là où les gens ont besoin de toi.',
        formation:
            'Technicien informatique de proximité (Bac Pro N4)\n'
            'ou Technicien d\'infrastructure informatique et sécurité (BTS N5)',
        niveau: 'Bac N4 ou BTS N5',
        postes:
            'Technicien Informatique • Support IT • Technicien de maintenance • Helpdesk N2/N3',
        color: Color(0xFF0097A7),
      );
    case 'info_terrain_B':
      return const _ProfileData(
        title: 'Expert Cybersécurité & Réseaux',
        emoji: '🔒',
        description:
            'Tu analyses en profondeur avant d\'agir. Tu construis des architectures sécurisées, '
            'audites les systèmes et anticipes les menaces. '
            'Ton atout : devenir la référence incontestée sur la sécurité.',
        formation:
            'Administrateur Système Réseaux et Cyber Sécurité (Licence N6)\n'
            'ou Expert réseau infrastructure et sécurité (Master N7)',
        niveau: 'Licence N6 ou Master N7',
        postes:
            'Administrateur de système informatique • Analyste SOC • Expert Cyber Sécurité • RSSI',
        color: Color(0xFF006064),
      );
    case 'info_dev_A':
      return const _ProfileData(
        title: 'Développeur Informatique',
        emoji: '💻',
        description:
            'Tu codes, tu livres, tu itères. Tu crées des applications utilisées '
            'au quotidien et tu t\'épanouis dans les cycles agiles. '
            'Ton atout : transformer des idées en produits rapidement.',
        formation:
            'BTS SIO — Service Informatique aux Organisations (BTS N5)\n'
            'ou Concepteur Développeur Web Full Stack (Licence N6)',
        niveau: 'BTS N5 ou Licence N6',
        postes: 'Développeur Informatique • Développeur Web Full Stack • Développeur mobile',
        color: Color(0xFF1565C0),
      );
    case 'info_dev_B':
      return const _ProfileData(
        title: 'Expert Architecture Logicielle',
        emoji: '🧠',
        description:
            'Tu penses systèmes complexes, scalabilité et architecture avant de coder. '
            'Tu définis les choix techniques qui engagent un produit sur plusieurs années. '
            'Ton atout : être le cerveau technique qui structure la vision produit.',
        formation: 'Expert en Architecture et Développement logiciel (Master N7)',
        niveau: 'Master N7',
        postes:
            'Expert en Développement Informatique • Responsable de projet informatique • Lead Tech • CTO',
        color: Color(0xFF1A237E),
      );
    case 'sante_contact_A':
      return const _ProfileData(
        title: 'Aide-Soignant·e',
        emoji: '🩺',
        description:
            'Tu es présent·e au chevet des patients dans les moments les plus difficiles. '
            'Tu apportes soin, confort et humanité au quotidien. '
            'Ton atout : ta bienveillance et ta capacité à créer un lien de confiance profond.',
        formation: 'Aide-soignant·e (Bac N4)',
        niveau: 'Bac N4',
        postes:
            'Aide-soignant·e en hôpital • Aide-soignant·e en EHPAD • Auxiliaire de vie',
        color: Color(0xFFC2185B),
      );
    case 'sante_contact_B':
      return const _ProfileData(
        title: 'Secrétaire Médicale',
        emoji: '📋',
        description:
            'Tu es le pilier organisationnel d\'une structure médicale. '
            'Tu accueilles, coordonnes et assures que tout tourne parfaitement. '
            'Ton atout : ton organisation et ta capacité à rassurer les patients.',
        formation: 'Secrétaire médical·e (Bac N4)',
        niveau: 'Bac N4',
        postes:
            'Secrétaire médicale en cabinet • Secrétaire médicale en hôpital • Hôtesse d\'accueil médical',
        color: Color(0xFF880E4F),
      );
    case 'sante_expertise_A':
      return const _ProfileData(
        title: 'Diététicien·ne',
        emoji: '🥗',
        description:
            'Tu es l\'expert·e de l\'alimentation thérapeutique. Tu accompagnes des patients '
            'vers un mieux-être en proposant des plans nutritionnels personnalisés. '
            'Ton atout : voir des transformations concrètes grâce à toi.',
        formation: 'BTS Diététique et Nutrition (BTS N5)',
        niveau: 'BTS N5',
        postes:
            'Diététicien·ne hospitalier • Diététicien·ne libéral·e • Nutritionniste conseil',
        color: Color(0xFF2E7D32),
      );
    case 'sante_expertise_B':
      return const _ProfileData(
        title: 'Opticien·ne Lunettier',
        emoji: '👓',
        description:
            'Tu corriges la vision, tu équipes et tu conseilles. Tu allies expertise '
            'technique en optique et relation client au quotidien. '
            'Ton atout : ce moment unique où un patient découvre la clarté du monde grâce à toi.',
        formation: 'BTS Opticien Lunettier (BTS N5)',
        niveau: 'BTS N5',
        postes:
            'Opticien·ne Lunettier en boutique • Opticien·ne en cabinet médical',
        color: Color(0xFF6A1B9A),
      );
    case 'animal_clinique_A':
    case 'animal_gestion_A':
      return const _ProfileData(
        title: 'Auxiliaire Vétérinaire',
        emoji: '🐾',
        description:
            'Tu es le bras droit du vétérinaire. Tu assistes aux actes médicaux, '
            'surveilles les animaux en convalescence et maîtrises les gestes techniques. '
            'Ton atout : la confiance que le vétérinaire te fait.',
        formation: 'Auxiliaire spécialité vétérinaire (Bac N4)',
        niveau: 'Bac N4',
        postes:
            'Auxiliaire vétérinaire en clinique • Auxiliaire vétérinaire en refuge • Assistant chirurgical vétérinaire',
        color: Color(0xFF2E7D32),
      );
    case 'animal_clinique_B':
    case 'animal_gestion_B':
      return const _ProfileData(
        title: 'Chargé·e de Gestion Animalière',
        emoji: '🏥',
        description:
            'Tu fais tourner la clinique ou le refuge comme une horloge. '
            'Tu gères l\'accueil, les plannings, la facturation et la relation propriétaires. '
            'Ton atout : ta capacité à organiser et à rassurer.',
        formation: 'Auxiliaire spécialité vétérinaire — option Gestion (Bac N4)',
        niveau: 'Bac N4',
        postes:
            'Chargé·e de gestion en clinique vétérinaire • Responsable accueil animalier • Manager de structure animalière',
        color: Color(0xFF1B5E20),
      );
    case 'juridique_redaction_A':
    case 'juridique_conseil_A':
      return const _ProfileData(
        title: 'Assistant·e Juridique',
        emoji: '📁',
        description:
            'Tu es l\'expert·e des dossiers, des actes et des procédures. '
            'Ta rigueur documentaire est irréprochable et les avocats te font confiance. '
            'Ton atout : zéro erreur, zéro délai manqué.',
        formation: 'BTS Assistant Juridique (BTS N5)',
        niveau: 'BTS N5',
        postes:
            'Assistant·e Juridique en cabinet d\'avocats • Assistant·e juridique en entreprise • Clerc de notaire',
        color: Color(0xFFBF360C),
      );
    case 'juridique_redaction_B':
    case 'juridique_conseil_B':
      return const _ProfileData(
        title: 'Collaborateur·trice Juriste Notarial·e',
        emoji: '⚖️',
        description:
            'Tu accompagnes les clients avec pédagogie et empathie. '
            'Tu expliques simplement des choses complexes et tu inspires confiance. '
            'Ton atout : les clients te recommandent à leurs proches.',
        formation: 'BTS Assistant Juridique (BTS N5)',
        niveau: 'BTS N5',
        postes:
            'Collaborateur·trice Juriste Notarial·e • Assistant·e notarial·e • Conseiller·ère juridique',
        color: Color(0xFFE65100),
      );
    case 'service_enfance_A':
    case 'service_animation_A':
      return const _ProfileData(
        title: 'Auxiliaire Petite Enfance / Assistante Maternelle',
        emoji: '👶',
        description:
            'Tu es le repère affectif et sécurisant des tout-petits. '
            'Tu accompagnes leur éveil sensoriel et leurs premiers apprentissages. '
            'Ton atout : les familles te font confiance dès la naissance.',
        formation: 'CAP Petite Enfance AEPE (CAP N3)',
        niveau: 'CAP N3',
        postes:
            'Accompagnement éducatif Petite Enfance • Assistante Maternelle • Garde d\'enfant',
        color: Color(0xFF1A237E),
      );
    case 'service_enfance_B':
    case 'service_animation_B':
      return const _ProfileData(
        title: 'Animateur·trice Périscolaire',
        emoji: '🎨',
        description:
            'Tu crées et animes des activités éducatives et ludiques pour des groupes. '
            'Tu construis une ambiance périscolaire que les enfants réclament. '
            'Ton atout : voir les enfants s\'épanouir grâce à tes projets.',
        formation: 'CAP Petite Enfance AEPE (CAP N3)',
        niveau: 'CAP N3',
        postes:
            'Animateur·trice périscolaire • Accompagnant éducatif Petite Enfance • Animateur·trice ALSH',
        color: Color(0xFF283593),
      );
    default:
      // Fallback générique par pôle
      return _getFallbackProfile(pole);
  }
}

_ProfileData _getFallbackProfile(String pole) {
  switch (pole) {
    case 'info':
      return const _ProfileData(
        title: 'Profil Informatique',
        emoji: '💻',
        description: 'Tu es naturellement attiré·e par les systèmes numériques et la technologie.',
        formation: 'Pôle MEWO Informatique',
        niveau: 'BTS N5 ou Licence N6',
        postes: 'Développeur • Technicien IT • Administrateur systèmes',
        color: Color(0xFF0097A7),
      );
    case 'sante':
      return const _ProfileData(
        title: 'Profil Santé',
        emoji: '🏥',
        description: 'Ton empathie et ta rigueur sont des atouts dans les métiers de la santé.',
        formation: 'Pôle MEWO Santé',
        niveau: 'Bac N4 ou BTS N5',
        postes: 'Aide-soignant·e • Diététicien·ne • Opticien·ne • Secrétaire médicale',
        color: Color(0xFFC2185B),
      );
    case 'animal':
      return const _ProfileData(
        title: 'Profil Animal',
        emoji: '🐾',
        description: 'Ta connexion au vivant et ta patience sont précieuses dans le secteur animal.',
        formation: 'Pôle MEWO Animal',
        niveau: 'Bac N4',
        postes: 'Auxiliaire vétérinaire • Chargé·e de gestion animalière',
        color: Color(0xFF2E7D32),
      );
    case 'juridique':
      return const _ProfileData(
        title: 'Profil Juridique',
        emoji: '⚖️',
        description: 'Ta rigueur et ton sens de l\'organisation te prédisposent aux métiers du droit.',
        formation: 'Pôle MEWO Juridique',
        niveau: 'BTS N5',
        postes: 'Assistant·e juridique • Collaborateur·trice juriste notarial·e',
        color: Color(0xFFBF360C),
      );
    default:
      return const _ProfileData(
        title: 'Profil Service',
        emoji: '🤝',
        description: 'Tu es naturellement tourné·e vers les enfants et les familles.',
        formation: 'Pôle MEWO Service',
        niveau: 'CAP N3',
        postes: 'Accompagnant éducatif • Animateur périscolaire • Assistante maternelle',
        color: Color(0xFF1A237E),
      );
  }
}

/// Calcule le type N3 (A ou B) à partir des réponses de niveau 3
String _computeTypeN3(List<AnswerRecord> answers) {
  final n3 = answers.where((a) => a.level == 3).toList();
  final n3A = n3.where((a) => a.letter == 'A').length;
  final n3B = n3.where((a) => a.letter == 'B').length;
  return n3A >= n3B ? 'A' : 'B';
}

// ================================================================
// ---- Écran principal ----

class ScreenResults extends StatefulWidget {
  final List<AnswerRecord> answers;
  final String dominantPole;
  final String metierGroup;

  const ScreenResults({
    super.key,
    required this.answers,
    required this.dominantPole,
    required this.metierGroup,
  });

  @override
  State<ScreenResults> createState() => _ScreenResultsState();
}

class _ScreenResultsState extends State<ScreenResults>
    with SingleTickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnim;
  late Animation<Offset> _slideAnim;

  bool _showSecondaryForm = false;
  bool _secondaryUnlocked = false;
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  late _ProfileData _primaryProfile;
  late _ProfileData _secondaryProfile;
  late int _total;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _revealAnim = CurvedAnimation(parent: _revealController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _revealController, curve: Curves.easeOut));
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
    final typeN3 = _computeTypeN3(widget.answers);
    _primaryProfile = _getProfileFromV4(widget.dominantPole, widget.metierGroup, typeN3);
    final altType = typeN3 == 'A' ? 'B' : 'A';
    _secondaryProfile = _getProfileFromV4(widget.dominantPole, widget.metierGroup, altType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FuturisticBackground(
        primaryColor: _primaryProfile.color,
        secondaryColor: const Color(0xFF1A237E),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(children: [
              FadeTransition(opacity: _revealAnim, child: _buildHeader()),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(opacity: _revealAnim, child: _buildPrimaryCard()),
              ),
              const SizedBox(height: 18),
              FadeTransition(opacity: _revealAnim, child: _buildSecondarySection()),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _revealAnim,
                child: GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) => const Screen1Welcome()),
                    (route) => false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white24, width: 1.5),
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                    child: const Text('↩  Recommencer le quiz',
                        style: TextStyle(color: Colors.white60, fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(children: [
      Text('🎯  RÉSULTATS',
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900,
            color: Colors.white, letterSpacing: 2,
            shadows: [
              Shadow(color: _primaryProfile.color.withValues(alpha: 0.9), blurRadius: 24),
              Shadow(color: _primaryProfile.color.withValues(alpha: 0.4), blurRadius: 50),
            ])),
      const SizedBox(height: 6),
      Text('$_total réponses analysées',
          style: const TextStyle(color: Colors.white54, fontSize: 13, letterSpacing: 1)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _primaryProfile.color.withValues(alpha: 0.18),
          border: Border.all(color: _primaryProfile.color.withValues(alpha: 0.6)),
        ),
        child: Text(_primaryProfile.niveau,
            style: TextStyle(fontSize: 11, color: _primaryProfile.color,
                fontWeight: FontWeight.bold)),
      ),
    ]);
  }

  Widget _buildPrimaryCard() {
    final p = _primaryProfile;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [p.color.withValues(alpha: 0.32), Colors.black.withValues(alpha: 0.28)]),
        border: Border.all(color: p.color, width: 2),
        boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.28), blurRadius: 24, spreadRadius: 2)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _BadgeWidget(label: 'PROFIL PRINCIPAL', color: p.color),
        const SizedBox(height: 16),
        Text('${p.emoji}  ${p.title}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 12),
        Text(p.description, style: const TextStyle(fontSize: 14,
            color: Color(0xCCFFFFFF), height: 1.75)),
        const SizedBox(height: 16),
        _InfoBlockWidget(icon: Icons.school_outlined,
            label: 'Formation recommandée · ${p.niveau}', value: p.formation, color: p.color),
        const SizedBox(height: 10),
        _InfoBlockWidget(icon: Icons.work_outline,
            label: 'Débouchés professionnels', value: p.postes, color: p.color),
      ]),
    );
  }

  Widget _buildSecondarySection() {
    if (_secondaryUnlocked) return _buildRevealedSecondary();
    if (_showSecondaryForm) return _buildEmailForm();
    return _buildLockedSecondary();
  }

  Widget _buildLockedSecondary() {
    final p = _secondaryProfile;
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.5),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.lock_outline, color: Colors.white38, size: 14),
          const SizedBox(width: 6),
          Text('PROFIL SECONDAIRE DÉTECTÉ',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.35), letterSpacing: 2)),
        ]),
        const SizedBox(height: 14),
        ClipRRect(borderRadius: BorderRadius.circular(12),
          child: Stack(alignment: Alignment.center, children: [
            ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Opacity(opacity: 0.6,
                child: Column(children: [
                  Text('${p.emoji}  ${p.title}', textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(p.description, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.6)),
                ]))),
            Container(padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.55)),
              child: const Column(children: [
                Icon(Icons.lock, color: Colors.white70, size: 28),
                SizedBox(height: 6),
                Text('Profil masqué', style: TextStyle(color: Colors.white60,
                    fontSize: 13, fontWeight: FontWeight.bold)),
              ])),
          ])),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _showSecondaryForm = true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(colors: [
                p.color.withValues(alpha: 0.45), p.color.withValues(alpha: 0.2)]),
              border: Border.all(color: p.color, width: 1.5),
              boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.3), blurRadius: 14)],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock_open_rounded, color: p.color, size: 18),
              const SizedBox(width: 8),
              Text('Voir mon profil complet', style: TextStyle(color: p.color,
                  fontWeight: FontWeight.bold, fontSize: 15)),
            ])),
        ),
      ]),
    );
  }

  Widget _buildEmailForm() {
    final p = _secondaryProfile;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: p.color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.12), blurRadius: 20)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🔓  Débloquer le profil secondaire',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: p.color)),
        const SizedBox(height: 6),
        const Text('Recevez vos résultats complets par email',
            style: TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 20),
        _FormFieldWidget(controller: _prenomController, label: 'Prénom', icon: Icons.person_outline),
        const SizedBox(height: 12),
        _FormFieldWidget(controller: _emailController, label: 'Adresse email',
            icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _showSecondaryForm = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18))),
              child: const Center(child: Text('Annuler',
                  style: TextStyle(color: Colors.white38, fontSize: 14)))),
          )),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: GestureDetector(
            onTap: _submitEmail,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(colors: [p.color, p.color.withValues(alpha: 0.65)]),
                boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.4), blurRadius: 14)],
              ),
              child: const Center(child: Text('Voir mon profil  →',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)))),
          )),
        ]),
        const SizedBox(height: 10),
        const Center(child: Text('🔒  Vos données ne seront pas partagées avec des tiers',
            style: TextStyle(color: Colors.white30, fontSize: 10))),
      ]),
    );
  }

  void _submitEmail() {
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    if (prenom.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remplissez tous les champs'))); return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adresse email invalide'))); return;
    }
    setState(() { _secondaryUnlocked = true; _showSecondaryForm = false; });
  }

  Widget _buildRevealedSecondary() {
    final p = _secondaryProfile;
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [p.color.withValues(alpha: 0.22), Colors.black.withValues(alpha: 0.25)]),
        border: Border.all(color: p.color.withValues(alpha: 0.65), width: 1.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _BadgeWidget(label: 'PROFIL SECONDAIRE', color: p.color),
        const SizedBox(height: 16),
        Text('${p.emoji}  ${p.title}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 10),
        Text(p.description, style: const TextStyle(fontSize: 13,
            color: Color(0xBFFFFFFF), height: 1.7)),
        const SizedBox(height: 14),
        _InfoBlockWidget(icon: Icons.school_outlined, label: 'Formation · ${p.niveau}',
            value: p.formation, color: p.color),
        const SizedBox(height: 10),
        _InfoBlockWidget(icon: Icons.work_outline, label: 'Débouchés professionnels',
            value: p.postes, color: p.color),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: p.color.withValues(alpha: 0.95),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text('📧 Résultats envoyés à ${_emailController.text}',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ]))),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: p.color.withValues(alpha: 0.15),
              border: Border.all(color: p.color.withValues(alpha: 0.55)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.email_outlined, color: p.color, size: 16),
              const SizedBox(width: 8),
              Text('Recevoir mes résultats par email',
                  style: TextStyle(color: p.color, fontWeight: FontWeight.bold, fontSize: 13)),
            ])),
        ),
      ]),
    );
  }
}

// ================================================================
// ---- Widgets utilitaires ----

class _BadgeWidget extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgeWidget({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1)),
    child: Text(label, style: const TextStyle(fontSize: 10,
        fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)));
}

class _InfoBlockWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoBlockWidget({required this.icon, required this.label,
      required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: color.withValues(alpha: 0.3))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, color: color,
            fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 13,
            color: Color(0xBFFFFFFF), height: 1.5)),
      ])),
    ]));
}

class _FormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  const _FormFieldWidget({required this.controller, required this.label,
      required this.icon, this.keyboardType});
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white60, width: 1.5))));
}