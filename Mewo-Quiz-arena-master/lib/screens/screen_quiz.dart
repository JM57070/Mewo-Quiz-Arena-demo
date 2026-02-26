// ============================================================
// screens/screen_quiz.dart — ENTONNOIR FULL DYNAMIQUE v4
// ============================================================
//
//  MODIFICATIONS v4 vs v3 :
//
//  1. ENTONNOIR DÉMARRÉ DÈS LE NIVEAU 2
//     → N2 n'est plus un jeu générique (tech/humain)
//     → N2 est spécifique au pôle détecté en N1
//     → getQuestionsNiveau2(pole) chargé à la transition N1→N2
//
//  2. N3 ADAPTÉ AU PÔLE + GROUPE MÉTIER
//     → computeMetierGroup(answers, pole) calculé après N2
//     → getQuestionsNiveau3(pole, metierGroup) chargé à N2→N3
//
//  3. NOUVELLES VARIABLES D'ÉTAT
//     → _dominantPole   : String — calculé fin N1
//     → _metierGroup    : String — calculé fin N2
//     → _dynamicN2Questions : List — chargé à transition N1→N2
//     → _dynamicN3Questions : List — chargé à transition N2→N3
//
//  4. CONFIGS VISUELLES DYNAMIQUES
//     → _getN2Config(pole)           — N2 coloré selon le pôle
//     → _getN3Config(pole, groupe)   — N3 coloré + texte précis
//
//  5. CONSERVATION COMPLÈTE
//     → Layout grille 2×2 N1 (4 réponses ABCD)
//     → Liste verticale N2/N3 (2 réponses AB)
//     → Typewriter, synopsis, personnages, animations
//     → Barre de progression, bouton suivant
//
// ============================================================

import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/video_background.dart';
import '../widgets/quiz_character.dart';
import '../models/quiz_question.dart';
import '../models/answer_record.dart';
import 'screen_results.dart';

enum QuizPhase { levelIntro, synopsis, question }

class _LevelConfig {
  final String levelName;
  final String subtitle;
  final String introText;
  final Color primary;
  final Color secondary;

  const _LevelConfig({
    required this.levelName,
    required this.subtitle,
    required this.introText,
    required this.primary,
    required this.secondary,
  });
}

// ── Config N1 (fixe) ─────────────────────────────────────────
const _LevelConfig _configN1 = _LevelConfig(
  levelName: 'NIVEAU 1',
  subtitle: 'DÉCOUVERTE',
  introText:
      'Cinq questions rapides et fun.\n'
      'Réponds à l\'instinct — il n\'y a pas de bonne ou mauvaise réponse.',
  primary: Color(0xFF00BCD4),
  secondary: Color(0xFF80DEEA),
);

// ── Config N2 dynamique selon le pôle détecté ────────────────
_LevelConfig _getN2Config(String pole) {
  switch (pole) {
    case 'info':
      return const _LevelConfig(
        levelName: 'NIVEAU 2',
        subtitle: 'INFORMATIQUE',
        introText:
            'Ton pôle : l\'informatique. 💻\n'
            'Deux grandes voies s\'ouvrent dans ce domaine :\n'
            'l\'infrastructure, les réseaux et la sécurité —\n'
            'ou le développement logiciel et la conception.\n'
            'Ces cinq questions vont affiner ta direction.',
        primary: Color(0xFF0097A7),
        secondary: Color(0xFF80DEEA),
      );
    case 'sante':
      return const _LevelConfig(
        levelName: 'NIVEAU 2',
        subtitle: 'SANTÉ',
        introText:
            'Ton pôle : la santé et le soin. 🏥\n'
            'Deux directions se dessinent :\n'
            'le contact direct avec les patients au quotidien —\n'
            'ou l\'expertise médicale en consultation spécialisée.\n'
            'Ces cinq questions vont préciser ta vocation.',
        primary: Color(0xFFC2185B),
        secondary: Color(0xFFF48FB1),
      );
    case 'animal':
      return const _LevelConfig(
        levelName: 'NIVEAU 2',
        subtitle: 'ANIMAL',
        introText:
            'Ton pôle : le monde animal. 🐾\n'
            'Deux rôles distincts t\'attendent :\n'
            'les soins cliniques en cabinet vétérinaire —\n'
            'ou la gestion et le management en structure animalière.\n'
            'Ces cinq questions vont identifier le tien.',
        primary: Color(0xFF33691E),
        secondary: Color(0xFFA5D6A7),
      );
    case 'juridique':
      return const _LevelConfig(
        levelName: 'NIVEAU 2',
        subtitle: 'JURIDIQUE',
        introText:
            'Ton pôle : le droit et la rigueur. ⚖️\n'
            'Deux facettes du métier juridique :\n'
            'la rédaction d\'actes et la gestion de dossiers —\n'
            'ou le conseil, l\'accompagnement et la relation client.\n'
            'Ces cinq questions vont te situer.',
        primary: Color(0xFFBF360C),
        secondary: Color(0xFFFFAB91),
      );
    case 'service':
    default:
      return const _LevelConfig(
        levelName: 'NIVEAU 2',
        subtitle: 'SERVICE',
        introText:
            'Ton pôle : les enfants et les familles. 🤝\n'
            'Deux univers très différents dans ce secteur :\n'
            'les tout-petits et la petite enfance (0-3 ans) —\n'
            'ou l\'animation périscolaire avec des groupes d\'enfants.\n'
            'Ces cinq questions vont affiner ton univers.',
        primary: Color(0xFF1A237E),
        secondary: Color(0xFF9FA8DA),
      );
  }
}

// ── Config N3 dynamique selon pôle + groupe métier ───────────
_LevelConfig _getN3Config(String pole, String metierGroup) {
  final key = '${pole}_$metierGroup';
  switch (key) {
    case 'info_terrain':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'INFRA & RÉSEAU',
        introText:
            'Direction confirmée : Infrastructure, Réseaux, Sécurité. 🔒\n'
            'Une dernière question à trancher :\n'
            'opérationnel·le sur le terrain dès le Bac ou BTS —\n'
            'ou expert·e spécialisé·e après une Licence ou un Master ?',
        primary: Color(0xFF00897B),
        secondary: Color(0xFF80CBC4),
      );
    case 'info_dev':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'DEV & CONCEPTION',
        introText:
            'Direction confirmée : Développement et Conception logicielle. 🧑‍💻\n'
            'Une dernière question à trancher :\n'
            'développeur·se opérationnel·le (BTS SIO ou Licence) —\n'
            'ou expert·e en architecture logicielle (Master) ?',
        primary: Color(0xFF1565C0),
        secondary: Color(0xFF90CAF9),
      );
    case 'sante_contact':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'SOIN & PRÉSENCE',
        introText:
            'Direction confirmée : contact et présence au quotidien. 🩺\n'
            'Deux métiers distincts dans cette direction :\n'
            'aide-soignant·e — soins d\'hygiène et de confort directs —\n'
            'ou secrétaire médicale — accueil et gestion administrative.',
        primary: Color(0xFFC2185B),
        secondary: Color(0xFFF48FB1),
      );
    case 'sante_expertise':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'EXPERTISE MÉDICALE',
        introText:
            'Direction confirmée : expertise médicale spécialisée. 🔬\n'
            'Deux spécialités très différentes :\n'
            'diététicien·ne — nutrition, alimentation, maladies métaboliques —\n'
            'ou opticien·ne lunettier — vision, yeux, lunettes et lentilles.',
        primary: Color(0xFF6A1B9A),
        secondary: Color(0xFFCE93D8),
      );
    case 'animal_clinique':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'SOINS VÉTÉRINAIRES',
        introText:
            'Direction confirmée : soins cliniques en cabinet vétérinaire. 🐕\n'
            'Ces cinq questions vont préciser ta spécialisation\n'
            'dans le métier d\'auxiliaire vétérinaire.',
        primary: Color(0xFF2E7D32),
        secondary: Color(0xFFA5D6A7),
      );
    case 'animal_gestion':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'GESTION ANIMALIÈRE',
        introText:
            'Direction confirmée : gestion et management en structure animalière. 🏥\n'
            'Ces cinq questions vont préciser ton profil\n'
            'en tant que chargé·e de gestion animalière.',
        primary: Color(0xFF33691E),
        secondary: Color(0xFFA5D6A7),
      );
    case 'juridique_redaction':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'ASSISTANT JURIDIQUE',
        introText:
            'Direction confirmée : rédaction et gestion documentaire juridique. 📋\n'
            'Ces cinq questions vont confirmer ton profil\n'
            'd\'assistant·e juridique et affiner ta spécialisation.',
        primary: Color(0xFFBF360C),
        secondary: Color(0xFFFFAB91),
      );
    case 'juridique_conseil':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'COLLABORATEUR JURISTE',
        introText:
            'Direction confirmée : conseil et relation client juridique. 🤝\n'
            'Ces cinq questions vont confirmer ton profil\n'
            'de collaborateur·trice juriste notarial·e.',
        primary: Color(0xFFE65100),
        secondary: Color(0xFFFFCC80),
      );
    case 'service_enfance':
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'PETITE ENFANCE',
        introText:
            'Direction confirmée : la petite enfance et les familles. 👶\n'
            'Ces cinq questions vont préciser ton métier\n'
            'parmi les quatre possibles du CAP AEPE.',
        primary: Color(0xFF1A237E),
        secondary: Color(0xFF9FA8DA),
      );
    case 'service_animation':
    default:
      return const _LevelConfig(
        levelName: 'NIVEAU 3',
        subtitle: 'ANIMATION PÉRISCOLAIRE',
        introText:
            'Direction confirmée : animation et accompagnement éducatif. 🎨\n'
            'Ces cinq questions vont préciser ta spécialisation\n'
            'dans le secteur périscolaire et éducatif.',
        primary: Color(0xFF283593),
        secondary: Color(0xFF9FA8DA),
      );
  }
}

// ============================================================
class ScreenQuiz extends StatefulWidget {
  const ScreenQuiz({super.key});
  @override
  State<ScreenQuiz> createState() => _ScreenQuizState();
}

class _ScreenQuizState extends State<ScreenQuiz>
    with SingleTickerProviderStateMixin {

  QuizPhase _phase = QuizPhase.levelIntro;
  int _currentLevel = 1;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final List<AnswerRecord> _allAnswers = [];

  // ── ENTONNOIR : variables de routage dynamique ────────────
  String _dominantPole   = 'info';      // calculé à fin N1
  String _metierGroup    = 'terrain';   // calculé à fin N2
  List<QuizQuestion> _dynamicN2Questions = const [];  // chargé à N1→N2
  List<QuizQuestion> _dynamicN3Questions = const [];  // chargé à N2→N3

  String _displayedText = '';
  bool _isTyping = false;
  Timer? _typingTimer;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const int _totalQuestions = 15;
  int get _totalAnswered => _allAnswers.length;

  // ── Questions du niveau courant ──────────────────────────
  List<QuizQuestion> get _currentQuestions {
    switch (_currentLevel) {
      case 1: return questionsNiveau1;
      case 2: return _dynamicN2Questions.isNotEmpty
                   ? _dynamicN2Questions
                   : getQuestionsNiveau2(_dominantPole);
      case 3: return _dynamicN3Questions.isNotEmpty
                   ? _dynamicN3Questions
                   : getQuestionsNiveau3(_dominantPole, _metierGroup);
      default: return questionsNiveau1;
    }
  }

  QuizQuestion get _currentQuestion =>
      _currentQuestions[_currentQuestionIndex];

  // ── Config visuelle selon niveau + pôle + groupe ─────────
  _LevelConfig get _config {
    switch (_currentLevel) {
      case 1: return _configN1;
      case 2: return _getN2Config(_dominantPole);
      case 3: return _getN3Config(_dominantPole, _metierGroup);
      default: return _configN1;
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15), end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut));
    _startLevelIntro();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  // ============================================================
  // ── ENTONNOIR : calcul et routage ────────────────────────────

  /// Appelé à la fin de N1 → calcule le pôle dominant et charge N2
  void _computeAndRouteToN2() {
    _dominantPole = computeDominantPole(_allAnswers);
    _dynamicN2Questions = getQuestionsNiveau2(_dominantPole);
  }

  /// Appelé à la fin de N2 → calcule le groupe métier et charge N3
  void _computeAndRouteToN3() {
    _metierGroup = computeMetierGroup(_allAnswers, _dominantPole);
    _dynamicN3Questions = getQuestionsNiveau3(_dominantPole, _metierGroup);
  }

  // ============================================================
  // ── Navigation ──────────────────────────────────────────────

  void _startLevelIntro() {
    setState(() { _phase = QuizPhase.levelIntro; _selectedAnswer = null; });
    _fadeController.forward(from: 0);
  }

  void _startQuestion() {
    final question = _currentQuestion;
    if (question.synopsis != null && _currentLevel > 1) {
      setState(() {
        _phase = QuizPhase.synopsis;
        _displayedText = '';
        _isTyping = true;
      });
      _fadeController.forward(from: 0);
      _startTypewriter(question.synopsis!);
    } else {
      _showQuestion();
    }
  }

  void _showQuestion() {
    setState(() {
      _phase = QuizPhase.question;
      _displayedText = '';
      _isTyping = true;
      _selectedAnswer = null;
    });
    _fadeController.forward(from: 0);
    _startTypewriter(_currentQuestion.question);
  }

  void _startTypewriter(String text, {int speedMs = 22}) {
    _typingTimer?.cancel();
    int index = 0;
    _displayedText = '';
    _typingTimer = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (index < text.length) {
        setState(() { _displayedText += text[index]; index++; });
      } else {
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  void _skipTypewriter(String fullText) {
    _typingTimer?.cancel();
    setState(() { _displayedText = fullText; _isTyping = false; });
  }

  void _selectAnswer(String letter) {
    if (_isTyping) return;
    setState(() => _selectedAnswer = letter);
  }

  // ============================================================
  // ── Action principale ─────────────────────────────────────

  void _goNext() {
    if (_phase == QuizPhase.levelIntro) { _startQuestion(); return; }
    if (_phase == QuizPhase.synopsis) {
      if (_isTyping) _skipTypewriter(_currentQuestion.synopsis!);
      else _showQuestion();
      return;
    }
    if (_isTyping) { _skipTypewriter(_currentQuestion.question); return; }

    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: _config.primary.withValues(alpha: 0.92),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(children: [
          Icon(Icons.info_outline, color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text('Sélectionne une réponse d\'abord !',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        duration: const Duration(seconds: 1),
      ));
      return;
    }

    // Enregistrement de la réponse
    final q = _currentQuestion;
    final selected = q.reponses.firstWhere((r) => r.letter == _selectedAnswer);
    _allAnswers.add(AnswerRecord(
      level: _currentLevel,
      questionNumero: q.numero,
      letter: selected.letter,
      profil: selected.profil,
      pole: selected.pole,          // renseigné uniquement N1
    ));

    final isLastQuestion =
        _currentQuestionIndex >= _currentQuestions.length - 1;

    if (!isLastQuestion) {
      // Prochaine question du même niveau
      setState(() { _currentQuestionIndex++; _selectedAnswer = null; });
      _startQuestion();
    } else if (_currentLevel < 3) {
      // ── ENTONNOIR : transition de niveau ──────────────────
      if (_currentLevel == 1) _computeAndRouteToN2();  // N1→N2
      if (_currentLevel == 2) _computeAndRouteToN3();  // N2→N3

      setState(() {
        _currentLevel++;
        _currentQuestionIndex = 0;
        _selectedAnswer = null;
      });
      _startLevelIntro();
    } else {
      // Fin du quiz → résultats
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => ScreenResults(
            answers: _allAnswers,
            dominantPole: _dominantPole,
            metierGroup: _metierGroup,
          ),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  // ============================================================
  // ── BUILD ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoBackground(
        level: _currentLevel,
        primaryColor: _config.primary,
        secondaryColor: _config.secondary,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: _buildPhaseContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent() {
    switch (_phase) {
      case QuizPhase.levelIntro: return _buildLevelIntro();
      case QuizPhase.synopsis:   return _buildSynopsis();
      case QuizPhase.question:   return _buildQuestion();
    }
  }

  // ── Intro niveau ─────────────────────────────────────────────
  Widget _buildLevelIntro() {
    return GestureDetector(
      onTap: _goNext,
      child: Column(children: [
        _buildProgressBar(),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _config.secondary, width: 2),
            color: _config.secondary.withValues(alpha: 0.12),
            boxShadow: [BoxShadow(
                color: _config.secondary.withValues(alpha: 0.25), blurRadius: 12)],
          ),
          child: Text(_config.levelName,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                  color: _config.secondary, letterSpacing: 4)),
        ),
        const SizedBox(height: 20),
        Text(_config.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900,
              color: Colors.white, letterSpacing: 3,
              shadows: [
                Shadow(color: _config.primary.withValues(alpha: 0.9), blurRadius: 24),
                Shadow(color: _config.primary.withValues(alpha: 0.4), blurRadius: 50),
                const Shadow(color: Colors.black87, offset: Offset(2, 2)),
              ]),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: 0.07),
              border: Border.all(color: _config.primary.withValues(alpha: 0.35)),
              boxShadow: [BoxShadow(
                  color: _config.primary.withValues(alpha: 0.12), blurRadius: 20)],
            ),
            child: Text(_config.introText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.8)),
          ),
        ),
        const Spacer(),
        _TapToContinue(color: _config.secondary),
        const SizedBox(height: 40),
      ]),
    );
  }

  // ── Synopsis ─────────────────────────────────────────────────
  Widget _buildSynopsis() {
    final character = getCharacterForScene(_currentLevel, _currentQuestionIndex);
    final hasCharacter = character != null;
    return GestureDetector(
      onTap: () {
        if (_isTyping) _skipTypewriter(_currentQuestion.synopsis!);
        else _goNext();
      },
      child: Column(children: [
        _buildProgressBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _LevelBadge(config: _config, questionIndex: _currentQuestionIndex),
            if (hasCharacter)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    color: _config.primary.withValues(alpha: 0.12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.touch_app, color: _config.primary, size: 12),
                  const SizedBox(width: 4),
                  Text('Touchez le personnage',
                      style: TextStyle(fontSize: 9, color: _config.primary, letterSpacing: 0.5)),
                ]),
              ),
          ]),
        ),
        Expanded(child: hasCharacter
            ? _buildSynopsisWithCharacter(character)
            : _buildSynopsisTextOnly()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
              _isTyping ? 'Appuyez pour passer...' : 'Appuyez pour la question →',
              style: const TextStyle(
                  color: Colors.white54, fontSize: 12, letterSpacing: 1.5)),
        ),
      ]),
    );
  }

  Widget _buildSynopsisWithCharacter(CharacterConfig character) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (character.fromLeft) _buildCharacterColumn(character),
        const SizedBox(width: 10),
        Expanded(child: _buildSynopsisCard()),
        const SizedBox(width: 10),
        if (!character.fromLeft) _buildCharacterColumn(character),
      ]),
    );
  }

  Widget _buildCharacterColumn(CharacterConfig character) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      _ReactionOverlay(
          key: ValueKey('$_currentLevel-$_currentQuestionIndex-reaction'),
          mood: character.mood, color: _config.primary),
      const SizedBox(height: 4),
      QuizCharacter(
          key: ValueKey('char-$_currentLevel-$_currentQuestionIndex'),
          level: _currentLevel, questionIndex: _currentQuestionIndex,
          primaryColor: _config.primary),
      const SizedBox(height: 8),
    ]);
  }

  Widget _buildSynopsisTextOnly() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: _buildSynopsisCard());
  }

  Widget _buildSynopsisCard() {
    return Center(
      child: Container(
        // Taille adaptée au contenu — plus de width:double.infinity
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(color: _config.primary.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [BoxShadow(
              color: _config.primary.withValues(alpha: 0.15), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ← la box colle au texte
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.auto_stories_rounded, color: _config.secondary, size: 16),
              const SizedBox(width: 6),
              Text('HISTOIRE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                  color: _config.secondary, letterSpacing: 2.5)),
            ]),
            Container(margin: const EdgeInsets.symmetric(vertical: 10), height: 1,
                color: _config.primary.withValues(alpha: 0.22)),
            Text(_displayedText,
                style: const TextStyle(
                    fontSize: 13.5, color: Colors.white, height: 1.85)),
            if (_isTyping)
              Text('▌', style: TextStyle(color: _config.secondary, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ── Question ─────────────────────────────────────────────────
  Widget _buildQuestion() {
    final question = _currentQuestion;
    return Column(children: [
      _buildProgressBar(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, children: [
          Transform.rotate(angle: -0.06,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                  colors: [_config.primary, _config.secondary])
                  .createShader(bounds),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_config.levelName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900,
                        color: Colors.white, letterSpacing: 1)),
                Text(_config.subtitle,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                        color: Colors.white, letterSpacing: 0.5)),
              ]),
            ),
          ),
          Text('Question ${_totalAnswered + 1}',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
                  color: Colors.white, letterSpacing: 1, shadows: [
                    Shadow(color: _config.primary.withValues(alpha: 0.8), blurRadius: 14),
                    const Shadow(color: Colors.black87, offset: Offset(1, 1)),
                  ])),
        ]),
      ),
      GestureDetector(
        onTap: () { if (_isTyping) _skipTypewriter(question.question); },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(begin: Alignment.topLeft,
                end: Alignment.bottomRight, colors: [
                  Colors.black.withValues(alpha: 0.45),
                  _config.primary.withValues(alpha: 0.08),
                ]),
            border: Border.all(color: _config.primary.withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            Text(_displayedText, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold,
                    color: Colors.white, height: 1.55,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 3)])),
            if (_isTyping)
              Text('▌', style: TextStyle(color: _config.secondary, fontSize: 17)),
          ]),
        ),
      ),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: _currentLevel == 1
            ? _buildAnswersGrid(question)
            : _buildAnswersList(question),
      )),
      // Logo MEWO en pulsation — remplace l'affichage "Détecte"
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Center(child: _PulsingLogo(color: _config.primary)),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 14, top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          GestureDetector(
            onTap: _goNext,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: _selectedAnswer != null
                        ? _config.secondary : Colors.white30, width: 2),
                color: _selectedAnswer != null
                    ? _config.secondary.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.04),
                boxShadow: _selectedAnswer != null
                    ? [BoxShadow(
                    color: _config.secondary.withValues(alpha: 0.4), blurRadius: 14)]
                    : [],
              ),
              child: Text('Suivant  →',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                      color: _selectedAnswer != null
                          ? _config.secondary : Colors.white30)),
            ),
          ),
        ]),
      ),
    ]);
  }

  // ── Grille 2×2 (N1 — 4 réponses ABCD) ──────────────────────
  Widget _buildAnswersGrid(QuizQuestion question) {
    final r = question.reponses;
    return Column(children: [
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _buildAnswerBox(r[0])),
        const SizedBox(width: 10),
        Expanded(child: _buildAnswerBox(r[1])),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _buildAnswerBox(r[2])),
        const SizedBox(width: 10),
        Expanded(child: _buildAnswerBox(r[3])),
      ]),
      const SizedBox(height: 6),
    ]);
  }

  // ── Liste verticale (N2/N3 — 2 réponses AB) ─────────────────
  Widget _buildAnswersList(QuizQuestion question) {
    return Column(children: question.reponses.map(_buildAnswerBox).toList());
  }

  // ── Boîte de réponse ─────────────────────────────────────────
  Widget _buildAnswerBox(QuizAnswer answer) {
    final isSelected = _selectedAnswer == answer.letter;
    return GestureDetector(
      onTap: () => _selectAnswer(answer.letter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? _config.primary.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.065),
          border: Border.all(
              color: isSelected
                  ? _config.primary : Colors.white.withValues(alpha: 0.22),
              width: isSelected ? 2.5 : 1.5),
          boxShadow: isSelected
              ? [BoxShadow(color: _config.primary.withValues(alpha: 0.35),
              blurRadius: 18, spreadRadius: 1)]
              : [],
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 32, height: 32,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? _config.primary.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                  color: isSelected ? _config.primary : Colors.white38, width: 2),
            ),
            child: Center(child: Text(answer.letter,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                    color: isSelected ? _config.primary : Colors.white60))),
          ),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(answer.text, style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.bold, color: Colors.white, height: 1.4)),
                // Profil intentionnellement masqué côté UI (conservé pour le calcul)
              ])),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: _config.primary, size: 22),
        ]),
      ),
    );
  }

  // ── Barre de progression ─────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('MEWO QUIZ ARENA', style: TextStyle(fontSize: 9,
              fontWeight: FontWeight.bold, color: _config.primary, letterSpacing: 2)),
          Text('$_totalAnswered / $_totalQuestions',
              style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ]),
        const SizedBox(height: 5),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _totalAnswered / _totalQuestions,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_config.primary),
            minHeight: 4,
          )),
      ]),
    );
  }
}

// ============================================================
// ── Widgets utilitaires ───────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  final _LevelConfig config;
  final int questionIndex;
  const _LevelBadge({required this.config, required this.questionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: config.primary.withValues(alpha: 0.18),
        border: Border.all(color: config.primary, width: 1),
      ),
      child: Text('${config.levelName}  ·  Q${questionIndex + 1} / 5',
          style: TextStyle(fontSize: 11, color: config.primary,
              fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }
}

class _TapToContinue extends StatefulWidget {
  final Color color;
  const _TapToContinue({required this.color});
  @override
  State<_TapToContinue> createState() => _TapToContinueState();
}

class _TapToContinueState extends State<_TapToContinue>
    with SingleTickerProviderStateMixin {
  late AnimationController _blink;
  late Animation<double> _opacity;
  @override
  void initState() {
    super.initState();
    _blink = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(_blink);
  }
  @override
  void dispose() { _blink.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.touch_app,
            color: widget.color.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 6),
        Text('Appuyez pour continuer',
            style: TextStyle(color: widget.color.withValues(alpha: 0.7),
                fontSize: 13, letterSpacing: 1.5)),
      ]));
  }
}

class _ReactionOverlay extends StatefulWidget {
  final CharacterMood mood;
  final Color color;
  const _ReactionOverlay({super.key, required this.mood, required this.color});
  @override
  State<_ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<_ReactionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _floatAnim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _floatAnim = Tween<double>(begin: -3, end: 3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
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
    return AnimatedBuilder(animation: _ctrl,
      builder: (_, __) => Transform.translate(offset: Offset(0, _floatAnim.value),
        child: Transform.scale(scale: _scaleAnim.value,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.15),
              border: Border.all(color: widget.color.withValues(alpha: 0.5), width: 1),
              boxShadow: [BoxShadow(
                  color: widget.color.withValues(alpha: 0.25), blurRadius: 8)],
            ),
            child: Text(_emoji, style: const TextStyle(fontSize: 18)),
          ))));
  }
}

// ── Logo MEWO en pulsation — remplace "Détecte" ──────────────
class _PulsingLogo extends StatefulWidget {
  final Color color;
  const _PulsingLogo({required this.color});
  @override
  State<_PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<_PulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: _glow.value * 0.45),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Opacity(
          opacity: 0.55 + _glow.value * 0.45,
          child: Image.asset(
            'assets/images/logo_mewo.png',
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}