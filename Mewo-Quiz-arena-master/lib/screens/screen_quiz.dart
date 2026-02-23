
// QUIZ INTERACTIF 
// 15 questions  •  3 niveaux  •  Animations engageantes
// Flow : Level Intro → (Synopsis) → Question → ... → Results


import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/futuristic_background.dart';
import '../widgets/quiz_character.dart';
import '../models/quiz_question.dart';
import '../models/answer_record.dart';
import 'screen_results.dart';

//  Phases du quiz 
enum QuizPhase { levelIntro, synopsis, question }

//  Config visuelle par niveau 
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

const Map<int, _LevelConfig> _levelConfigs = {
  1: _LevelConfig(
    levelName: 'NIVEAU 1',
    subtitle: 'DÉCOUVERTE',
    introText:
        'Cinq questions pour révéler votre profil naturel.\n'
        'Soyez spontané — il n\'y a pas de bonne ou mauvaise réponse.',
    primary: Color(0xFF00BCD4),
    secondary: Color(0xFF80DEEA),
  ),
  2: _LevelConfig(
    levelName: 'NIVEAU 2',
    subtitle: 'LE SILENCE',
    introText:
        'Une cyberattaque paralyse une entreprise.\n'
        'Chaque décision que vous prenez révèle votre profil professionnel.',
    primary: Color(0xFF259AB3),
    secondary: Color(0xFF8ac1d0),
  ),
  3: _LevelConfig(
    levelName: 'NIVEAU 3',
    subtitle: 'PHASE FINALE',
    introText:
        'JUSTICE.EXE n\'était que le premier acte.\n'
        'Cinq incidents simultanés vous attendent.\n'
        'Votre approche finale définira votre orientation.',
    primary: Color(0xFF5E35B1),
    secondary: Color(0xFF9575CD),
  ),
};


class ScreenQuiz extends StatefulWidget {
  const ScreenQuiz({super.key});

  @override
  State<ScreenQuiz> createState() => _ScreenQuizState();
}

class _ScreenQuizState extends State<ScreenQuiz>
    with SingleTickerProviderStateMixin {
  //  État du quiz 
  QuizPhase _phase = QuizPhase.levelIntro;
  int _currentLevel = 1;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final List<AnswerRecord> _allAnswers = [];

  //  Typewriter 
  String _displayedText = '';
  bool _isTyping = false;
  Timer? _typingTimer;

  //  Animation d'apparition 
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  //  Constantes 
  static const int _totalQuestions = 15;
  int get _totalAnswered => _allAnswers.length;

  List<QuizQuestion> get _currentQuestions {
    switch (_currentLevel) {
      case 1: return questionsNiveau1;
      case 2: return questionsNiveau2;
      case 3: return questionsNiveau3;
      default: return questionsNiveau1;
    }
  }

  QuizQuestion get _currentQuestion =>
      _currentQuestions[_currentQuestionIndex];
  _LevelConfig get _config => _levelConfigs[_currentLevel]!;

  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _startLevelIntro();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  
  //  Navigation entre phases 

  void _startLevelIntro() {
    setState(() {
      _phase = QuizPhase.levelIntro;
      _selectedAnswer = null;
    });
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

  //  Typewriter effect 
  void _startTypewriter(String text, {int speedMs = 22}) {
    _typingTimer?.cancel();
    int index = 0;
    _displayedText = '';

    _typingTimer = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (index < text.length) {
        setState(() {
          _displayedText += text[index];
          index++;
        });
      } else {
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  void _skipTypewriter(String fullText) {
    _typingTimer?.cancel();
    setState(() {
      _displayedText = fullText;
      _isTyping = false;
    });
  }

  //  Sélectionner une réponse 
  void _selectAnswer(String letter) {
    if (_isTyping) return;
    setState(() => _selectedAnswer = letter);
  }

  //  Action principale : avancer 
  void _goNext() {
    //  Intro niveau → démarrer la 1ère question 
    if (_phase == QuizPhase.levelIntro) {
      _startQuestion();
      return;
    }

    //  Synopsis → afficher la question 
    if (_phase == QuizPhase.synopsis) {
      if (_isTyping) {
        _skipTypewriter(_currentQuestion.synopsis!);
      } else {
        _showQuestion();
      }
      return;
    }

    //  Question : skip typewriter 
    if (_isTyping) {
      _skipTypewriter(_currentQuestion.question);
      return;
    }

    //  Question : valider la réponse 
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _config.primary.withValues(alpha: 0.92),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'Sélectionne une réponse d\'abord !',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    //  Enregistrer la réponse 
    final q = _currentQuestion;
    final selected = q.reponses.firstWhere((r) => r.letter == _selectedAnswer);
    _allAnswers.add(AnswerRecord(
      level: _currentLevel,
      questionNumero: q.numero,
      letter: selected.letter,
      profil: selected.profil,
    ));

    final isLastQuestion =
        _currentQuestionIndex >= _currentQuestions.length - 1;

    if (!isLastQuestion) {
      //  Prochaine question du même niveau 
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
      _startQuestion();
    } else if (_currentLevel < 3) {
      //  Passer au niveau suivant 
      setState(() {
        _currentLevel++;
        _currentQuestionIndex = 0;
        _selectedAnswer = null;
      });
      _startLevelIntro();
    } else {
      //  Fin du quiz → écran résultats 
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, secondAnim) => ScreenResults(answers: _allAnswers),
          transitionsBuilder: (ctx, anim, secondAnim, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  
  //  BUILD 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FuturisticBackground(
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

  
  //  ÉCRAN : INTRO NIVEAU 

  Widget _buildLevelIntro() {
    return GestureDetector(
      onTap: _goNext,
      child: Column(
        children: [
          _buildProgressBar(),
          const Spacer(),

          // Badge niveau
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: _config.secondary, width: 2),
              color: _config.secondary.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(color: _config.secondary.withValues(alpha: 0.25), blurRadius: 12),
              ],
            ),
            child: Text(
              _config.levelName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _config.secondary,
                letterSpacing: 4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Grand titre
          Text(
            _config.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
              shadows: [
                Shadow(color: _config.primary.withValues(alpha: 0.9), blurRadius: 24),
                Shadow(color: _config.primary.withValues(alpha: 0.4), blurRadius: 50),
                const Shadow(color: Colors.black87, offset: Offset(2, 2)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Boîte de description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.07),
                border: Border.all(color: _config.primary.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: _config.primary.withValues(alpha: 0.12),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Text(
                _config.introText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.8,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Tap to continue
          _TapToContinue(color: _config.secondary),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  
  //  ÉCRAN : SYNOPSIS 

  Widget _buildSynopsis() {
    return GestureDetector(
      onTap: () {
        if (_isTyping) {
          _skipTypewriter(_currentQuestion.synopsis!);
        } else {
          _goNext();
        }
      },
      child: Column(
        children: [
          _buildProgressBar(),

          // Badge niveau + Q
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _LevelBadge(config: _config, questionIndex: _currentQuestionIndex),
              ],
            ),
          ),

          // Carte synopsis + personnage animé
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Personnage animé (niveaux 2 & 3)
                  QuizCharacter(
                    level: _currentLevel,
                    questionIndex: _currentQuestionIndex,
                    primaryColor: _config.primary,
                  ),
                  // Carte synopsis
                  Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withValues(alpha: 0.07),
                  border: Border.all(
                    color: _config.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _config.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête Histoire
                    Row(
                      children: [
                        Icon(
                          Icons.auto_stories_rounded,
                          color: _config.secondary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'HISTOIRE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _config.secondary,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 1,
                      color: _config.primary.withValues(alpha: 0.25),
                    ),

                    // Texte animé
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayedText,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                height: 1.85,
                              ),
                            ),
                            if (_isTyping)
                              Text(
                                '▌',
                                style: TextStyle(
                                  color: _config.secondary,
                                  fontSize: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                ],
              ),
            ),
          ),

          // Hint bas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              _isTyping
                  ? 'Appuyez pour passer...'
                  : 'Appuyez pour la question →',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  //  ÉCRAN : QUESTION 

  Widget _buildQuestion() {
    final question = _currentQuestion;

    return Column(
      children: [
        _buildProgressBar(),

        //  En-tête 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Niveau incliné avec dégradé
              Transform.rotate(
                angle: -0.06,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [_config.primary, _config.secondary],
                  ).createShader(bounds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _config.levelName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        _config.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Numéro global de question
              Text(
                'Question ${_totalAnswered + 1}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                        color: _config.primary.withValues(alpha: 0.8), blurRadius: 14),
                    const Shadow(color: Colors.black87, offset: Offset(1, 1)),
                  ],
                ),
              ),
            ],
          ),
        ),

        //  Texte de la question 
        GestureDetector(
          onTap: () {
            if (_isTyping) _skipTypewriter(question.question);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  _config.primary.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(color: _config.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  _displayedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.55,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
                  ),
                ),
                if (_isTyping)
                  Text(
                    '▌',
                    style: TextStyle(color: _config.secondary, fontSize: 17),
                  ),
              ],
            ),
          ),
        ),

        //  Réponses 
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: question.reponses.map(_buildAnswerBox).toList(),
            ),
          ),
        ),

        //  Footer : détecter + bouton 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Détecte : ${question.detecte}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Colors.white38,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 14, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: _goNext,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _selectedAnswer != null
                            ? _config.secondary
                            : Colors.white30,
                        width: 2,
                      ),
                      color: _selectedAnswer != null
                          ? _config.secondary.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.04),
                      boxShadow: _selectedAnswer != null
                          ? [
                              BoxShadow(
                                color: _config.secondary.withValues(alpha: 0.4),
                                blurRadius: 14,
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      'Suivant  →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _selectedAnswer != null
                            ? _config.secondary
                            : Colors.white30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  
  //  Boîte de réponse 

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
                ? _config.primary
                : Colors.white.withValues(alpha: 0.22),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _config.primary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Pastille lettre
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? _config.primary.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: isSelected ? _config.primary : Colors.white38,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  answer.letter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? _config.primary : Colors.white60,
                  ),
                ),
              ),
            ),

            // Texte de la réponse
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    answer.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.45,
                    ),
                  ),
                  // Profil révélé discrètement si sélectionné
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '→ ${answer.profil}',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: _config.secondary.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Icône check si sélectionné
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  color: _config.primary, size: 22),
          ],
        ),
      ),
    );
  }

  
  //  Barre de progression 

  Widget _buildProgressBar() {
    final progress = _totalAnswered / _totalQuestions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MEWO QUIZ ARENA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: _config.primary,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '$_totalAnswered / $_totalQuestions',
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_config.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}


//  Widgets utilitaires 

/// Badge "NIVEAU X · Q Y/5"
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
      child: Text(
        '${config.levelName}  ·  Q${questionIndex + 1} / 5',
        style: TextStyle(
          fontSize: 11,
          color: config.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// "Appuyez pour continuer" avec animation de point clignotant
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
    _blink = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(_blink);
  }

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app, color: widget.color.withValues(alpha: 0.7), size: 16),
          const SizedBox(width: 6),
          Text(
            'Appuyez pour continuer',
            style: TextStyle(
              color: widget.color.withValues(alpha: 0.7),
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}