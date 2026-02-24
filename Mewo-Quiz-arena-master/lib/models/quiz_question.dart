// ============================================================
// models/quiz_question.dart — QUESTIONNAIRE ENTONNOIR v3
// ============================================================
//
// ARCHITECTURE ENTONNOIR DYNAMIQUE :
//
//   N1 (5 questions ABCD) → identifie le PÔLE DOMINANT (5 pôles)
//   N2 (5 questions AB)   → confirme la DIRECTION (tech/humain)
//   N3 (5 questions AB)   → adapté au pôle détecté en N1+N2
//                           → aboutit à FORMATION + MÉTIER précis
//
//   Chaque pôle dispose de son propre jeu de questions N3 :
//   • questionsNiveau3Info      (A=Infra/Opérationnel  B=Dev/Expert)
//   • questionsNiveau3Sante     (A=Soin terrain        B=Expertise médicale)
//   • questionsNiveau3Animal    (A=Soins clinique      B=Gestion animalière)
//   • questionsNiveau3Juridique (A=Rédaction/dossier   B=Conseil/notarial)
//   • questionsNiveau3Service   (A=Petite enfance      B=Relation client)
//
//   Sélection dynamique via : getQuestionsNiveau3(String pole)
//
// ============================================================

class QuizQuestion {
  final int numero;
  final String question;
  final String? synopsis;
  final List<QuizAnswer> reponses;
  final String detecte;

  const QuizQuestion({
    required this.numero,
    required this.question,
    this.synopsis,
    required this.reponses,
    required this.detecte,
  });
}

class QuizAnswer {
  final String letter;
  final String text;
  final String profil;
  final String? pole;       // tag court — renseigné uniquement en N1
  final List<String> tags;

  const QuizAnswer({
    required this.letter,
    required this.text,
    required this.profil,
    this.pole,
    required this.tags,
  });
}

// ============================================================
// NIVEAU 1 — Habitudes & méthodes (fun, indirect)
// 5 questions · 4 réponses A/B/C/D · pas de synopsis
// Objectif : identifier le pôle parmi 5
// ============================================================

const List<QuizQuestion> questionsNiveau1 = [

  QuizQuestion(
    numero: 1,
    question: 'Ta série Netflix du moment, c\'est plutôt… ?',
    detecte: 'univers de préférence — indicateur pôle indirect',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Mr. Robot, Black Mirror, Silicon Valley\n→ hackers, IA, technologie 🖥️',
        profil: 'Informatique', pole: 'info',
        tags: ['tech', 'logique', 'numerique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Grey\'s Anatomy, Urgences, Scrubs\n→ médecine, soins, urgences 🏥',
        profil: 'Santé', pole: 'sante',
        tags: ['soin', 'medical', 'empathie'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Suits, How to Get Away with Murder\n→ justice, droit, plaidoiries ⚖️',
        profil: 'Juridique', pole: 'juridique',
        tags: ['droit', 'regles', 'defense'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Call the Midwife, Instinct Animal, Super Nanny\n→ enfants, animaux, familles 😄',
        profil: 'Service / Animal', pole: 'service',
        tags: ['humain', 'enfance', 'animal', 'relation'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 2,
    question: 'Dans un escape room, tu incarnes naturellement…',
    detecte: 'rôle instinctif dans le groupe — compétences naturelles',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Celui/celle qui déchiffre les codes, les systèmes, cherche la logique',
        profil: 'Informatique', pole: 'info',
        tags: ['logique', 'analyse', 'tech'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Celui/celle qui prend soin du groupe, s\'assure que personne ne panique',
        profil: 'Santé / Animal', pole: 'sante',
        tags: ['empathie', 'soin', 'ecoute'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Celui/celle qui relit les règles, gère le temps, vérifie les contraintes',
        profil: 'Juridique', pole: 'juridique',
        tags: ['rigueur', 'organisation', 'regles'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Celui/celle qui motive l\'équipe, anime, gère les relations',
        profil: 'Service', pole: 'service',
        tags: ['animation', 'relation', 'communication'],
      ),
    ],
  ),

  // ---- Question obligatoire : réaction face au sang ----
  QuizQuestion(
    numero: 3,
    question: 'Tu vois quelqu\'un tomber dans la rue et saigner abondamment. Ton réflexe ?',
    detecte: 'confort face au milieu médical — clé pôle Santé',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu t\'approches et appliques les gestes de premiers secours\n→ le sang ne te dérange pas 🩹',
        profil: 'Santé', pole: 'sante',
        tags: ['soin', 'medical', 'urgence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu appelles le 15 et guides à voix haute depuis une certaine distance\n→ efficace sans contact direct',
        profil: 'Informatique', pole: 'info',
        tags: ['distance', 'tech', 'organisation'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Tu organises les témoins autour et coordonnes l\'intervention\n→ tu gères sans contact direct',
        profil: 'Juridique / Service', pole: 'juridique',
        tags: ['coordination', 'gestion', 'organisation'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Tu restes pour soutenir émotionnellement en attendant les secours\n→ le sang te met mal à l\'aise mais tu ne pars pas',
        profil: 'Service / Animal', pole: 'service',
        tags: ['soutien', 'emotion', 'presence'],
      ),
    ],
  ),

  // ---- Question obligatoire : défendre les autres ----
  QuizQuestion(
    numero: 4,
    question: 'Tu vois quelqu\'un se faire traiter injustement devant toi. Ta réaction ?',
    detecte: 'attrait pour la défense et le droit — clé pôle Juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu cites le règlement ou la loi — les droits de cette personne doivent être respectés ⚖️',
        profil: 'Juridique', pole: 'juridique',
        tags: ['droit', 'defense', 'regles'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu prends la parole directement pour défendre la personne, sans attendre',
        profil: 'Juridique / Service', pole: 'juridique',
        tags: ['defense', 'expression', 'courage'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Tu cherches une solution pratique ou technique pour régler le problème',
        profil: 'Informatique', pole: 'info',
        tags: ['resolution', 'pratique', 'tech'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Tu restes aux côtés de la personne pour la soutenir émotionnellement',
        profil: 'Santé / Service', pole: 'sante',
        tags: ['empathie', 'soutien', 'presence'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 5,
    question: 'Ton lieu de travail idéal ressemble à…',
    detecte: 'environnement de prédilection — confirmation pôle',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un labo tech avec plusieurs écrans, du matériel, des lignes de code 🖥️',
        profil: 'Informatique', pole: 'info',
        tags: ['tech', 'numerique', 'outil'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une clinique, un cabinet ou une salle de soin — calme et bienveillant 🏥',
        profil: 'Santé / Animal', pole: 'sante',
        tags: ['soin', 'medical', 'vivant'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Un open space vivant — familles, enfants, gens à aider au quotidien 👥',
        profil: 'Service', pole: 'service',
        tags: ['relation', 'humain', 'animation'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Un bureau sobre et ordonné, des dossiers, des règles claires 📋',
        profil: 'Juridique', pole: 'juridique',
        tags: ['rigueur', 'organisation', 'droit'],
      ),
    ],
  ),
];

// ============================================================
// NIVEAU 2 — Pôles de formation
// 5 questions · 2 réponses A/B · synopsis immersif
// A = Tech/Règles  |  B = Humain/Vivant
// ============================================================

const List<QuizQuestion> questionsNiveau2 = [

  QuizQuestion(
    numero: 6,
    synopsis:
        '8h30. Premier jour de stage.\n'
        'Tu pousses la porte d\'une structure inconnue.\n'
        'L\'équipe t\'observe.\n'
        '"Une demi-journée pour observer. Deux univers coexistent ici.\n'
        'Lequel va t\'attirer ?"',
    question: 'On te propose de choisir ta première mission. Tu prends…',
    detecte: 'préférence opérationnelle — Tech/Règles vs Humain/Vivant',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Analyser une panne, préparer un dossier, résoudre un problème technique ou administratif',
        profil: 'Informatique / Juridique',
        tags: ['tech', 'regles', 'analyse'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Accueillir une famille, soigner un animal, accompagner un enfant ou une personne',
        profil: 'Santé / Animal / Service',
        tags: ['humain', 'vivant', 'soin', 'relation'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 7,
    synopsis:
        'Midi. Tu déjeunes avec deux membres de l\'équipe.\n'
        'Ils parlent de leur métier avec passion.\n'
        'L\'un deux ressemble exactement à ce que tu imagines pour toi dans 5 ans.',
    question: 'Ce collègue idéal, il travaille dans…',
    detecte: 'domaine de projection — Tech/Règles vs Humain/Vivant',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'L\'informatique, la cybersécurité, ou le droit — précis, technique, expert',
        profil: 'Informatique / Juridique',
        tags: ['expertise', 'tech', 'droit'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La médecine, le soin animal, la petite enfance ou le service — humain, vivant',
        profil: 'Santé / Animal / Service',
        tags: ['vivant', 'humain', 'soin'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 8,
    synopsis:
        '14h. Un incident se produit dans la structure.\n'
        'Deux réactions s\'opposent dans la pièce.\n'
        'Le responsable t\'observe pour voir vers laquelle tu te tournes.',
    question: 'En fin de journée, ce qui t\'a rendu fier(e), c\'est d\'avoir…',
    detecte: 'source de satisfaction — résoudre vs accompagner',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Résolu un problème complexe, maîtrisé un outil ou défendu un dossier avec succès',
        profil: 'Informatique / Juridique',
        tags: ['resolution', 'maitrise', 'expertise'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Vu quelqu\'un aller mieux, s\'épanouir ou progresser grâce à ton aide directe',
        profil: 'Santé / Animal / Service',
        tags: ['impact', 'soin', 'presence'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 9,
    synopsis:
        '17h. La journée se termine.\n'
        'Le responsable te demande de te projeter :\n'
        '"Dans 10 ans, tu te vois comment ?"',
    question: 'Ta réponse spontanée…',
    detecte: 'projection professionnelle — expert vs présence',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Reconnu(e) comme expert(e) dans mon domaine — les gens viennent me consulter',
        profil: 'Informatique / Juridique',
        tags: ['expertise', 'reference', 'competence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Entouré(e) de personnes ou d\'êtres vivants — ma présence fait une vraie différence',
        profil: 'Santé / Animal / Service',
        tags: ['presence', 'impact', 'vivant'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 10,
    synopsis:
        'Fin de stage.\n'
        '"Qu\'est-ce qui te ferait vraiment détester ton travail ?"',
    question: 'Ta grande peur professionnelle, c\'est de…',
    detecte: 'repoussoir professionnel — confirmation direction N2',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Stagner, ne pas progresser, ne pas devenir une référence dans mon domaine',
        profil: 'Informatique / Juridique',
        tags: ['evolution', 'expertise', 'progression'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Travailler seul(e) toute la journée sans contact humain ni possibilité d\'aider',
        profil: 'Santé / Animal / Service',
        tags: ['contact', 'relation', 'aide'],
      ),
    ],
  ),
];

// ============================================================
// NIVEAU 3 — DYNAMIQUE par pôle (5 jeux de questions)
// Sélectionné automatiquement selon pôle dominant N1+N2
// ============================================================

// ── N3 INFORMATIQUE ──────────────────────────────────────────
// A = Technicien Infra & Sécurité  |  B = Dev / Expert conception

const List<QuizQuestion> questionsNiveau3Info = [

  QuizQuestion(
    numero: 11,
    synopsis:
        'Tu es en stage IT.\n'
        'Il est 23h. Le serveur de production vient de tomber.\n'
        'Tu es le seul disponible. Deux options s\'offrent à toi.',
    question: 'Que fais-tu en premier ?',
    detecte: 'réflexe urgence IT — terrain vs analyse',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu te connectes, analyses les logs serveur et remets le service en ligne le plus vite possible',
        profil: 'Technicien Infrastructure & Sécurité',
        tags: ['infra', 'terrain', 'operationnel'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu identifies la ligne de code ou la configuration fautive et prépares un correctif documenté',
        profil: 'Développeur / Expert conception',
        tags: ['dev', 'analyse', 'conception'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ton responsable te confie un projet libre pour la semaine. Tu choisis…',
    detecte: 'appétence projet — infra vs développement',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Sécuriser le réseau, configurer des pare-feux, tester la résistance aux intrusions',
        profil: 'Technicien Infrastructure & Sécurité',
        tags: ['reseau', 'securite', 'infra'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Développer un petit outil interne ou une appli pour automatiser une tâche répétitive',
        profil: 'Développeur / Expert logiciel',
        tags: ['dev', 'automatisation', 'code'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Un utilisateur est bloqué et ne peut plus accéder à son poste. Tu…',
    detecte: 'mode d\'intervention — assistance directe vs solution systémique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Prends la main à distance ou te déplaces immédiatement pour dépanner',
        profil: 'Technicien Assistance Informatique',
        tags: ['assistance', 'terrain', 'support'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Règles le problème ET crées une procédure pour éviter que ça se reproduise',
        profil: 'Administrateur Systèmes / Développeur',
        tags: ['process', 'systeme', 'amelioration'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Dans l\'équipe IT, le rôle qui t\'attire le plus est…',
    detecte: 'rôle cible — tech opérationnel vs expert développement',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Administrateur réseaux — gérer les serveurs, la sécurité, les accès et les équipements',
        profil: 'Technicien Infrastructure & Sécurité',
        tags: ['admin', 'reseau', 'infra'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Développeur ou architecte — concevoir des applications, des APIs, des systèmes scalables',
        profil: 'Développeur Full Stack / Expert Logiciel',
        tags: ['dev', 'architecture', 'logiciel'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ta réussite professionnelle dans 5 ans, c\'est d\'avoir…',
    detecte: 'vision finale — confirmation formation informatique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Protégé l\'infrastructure d\'une entreprise contre une vraie cyberattaque',
        profil: 'Technicien Infrastructure / Expert Cybersécurité',
        tags: ['securite', 'infra', 'protection'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Livré une application ou un système utilisé par des centaines de personnes chaque jour',
        profil: 'Développeur / Expert Architecture Logiciel',
        tags: ['dev', 'livraison', 'impact'],
      ),
    ],
  ),
];

// ── N3 SANTÉ ─────────────────────────────────────────────────
// A = Soin direct / Terrain  |  B = Expertise médicale / Analyse

const List<QuizQuestion> questionsNiveau3Sante = [

  QuizQuestion(
    numero: 11,
    synopsis:
        'Tu es en stage dans un établissement de santé.\n'
        'Ce matin, une patiente âgée arrive aux urgences — pâle, essoufflée.\n'
        'L\'équipe se mobilise.',
    question: 'Quelle est ta place naturelle dans cette situation ?',
    detecte: 'mode d\'intervention santé — soin direct vs évaluation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu l\'installes, prends ses constantes, la rassures — le geste direct et la présence physique',
        profil: 'Aide soignant·e / Soignant terrain',
        tags: ['soin', 'terrain', 'geste'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu collectes ses antécédents, poses des questions précises pour aider au bilan — l\'analyse avant le geste',
        profil: 'Diététicien·ne / Opticien·ne / Expertise médicale',
        tags: ['analyse', 'bilan', 'expertise'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ta journée idéale dans la santé, c\'est…',
    detecte: 'quotidien préféré — contact vs consultation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être au chevet des patients toute la journée — toilettes, repas, mobilisation, présence',
        profil: 'Aide soignant·e',
        tags: ['soin', 'presence', 'quotidien'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Recevoir des consultations, établir des bilans personnalisés, ajuster des protocoles',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['consultation', 'bilan', 'protocole'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ce qui t\'intéresse dans la santé, c\'est surtout…',
    detecte: 'motivation santé — présence vs savoir',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Le contact humain, la présence quotidienne, accompagner les gens dans les moments difficiles',
        profil: 'Aide soignant·e / Soignant terrain',
        tags: ['contact', 'accompagnement', 'humanite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La science, les données médicales, comprendre le corps pour proposer la meilleure solution',
        profil: 'Diététicien·ne / Opticien·ne / Expert médical',
        tags: ['science', 'donnees', 'analyse'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Un patient difficile, qui refuse de suivre les recommandations. Tu…',
    detecte: 'gestion du patient — relation vs protocole',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Prends le temps d\'écouter ses peurs, de créer la confiance, d\'adapter ton approche humaine',
        profil: 'Aide soignant·e / Secrétaire médicale',
        tags: ['ecoute', 'confiance', 'relation'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Reformules les données de façon claire et objective pour qu\'il comprenne les enjeux médicaux',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['pedagogie', 'donnees', 'objectif'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ta fierté professionnelle dans la santé, dans 5 ans, c\'est d\'avoir…',
    detecte: 'vision finale — confirmation formation santé',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Accompagné des dizaines de patients dans leurs moments les plus vulnérables avec bienveillance',
        profil: 'Aide soignant·e',
        tags: ['accompagnement', 'soin', 'bienveillance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Aidé des patients à retrouver une meilleure santé grâce à ton expertise et tes bilans précis',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['expertise', 'bilan', 'amelioration'],
      ),
    ],
  ),
];

// ── N3 ANIMAL ────────────────────────────────────────────────
// A = Soins cliniques / assistance vétérinaire
// B = Gestion et management en structure animalière

const List<QuizQuestion> questionsNiveau3Animal = [

  QuizQuestion(
    numero: 11,
    synopsis:
        'Tu es en stage dans une clinique vétérinaire.\n'
        'Un chien arrive en urgence après un accident.\n'
        'Le vétérinaire a besoin de toi.',
    question: 'Quelle place tu prends naturellement ?',
    detecte: 'rôle instinctif — soin clinique vs organisation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu assistes le vétérinaire : tu tiens l\'animal, prépares le matériel, surveilles les constantes',
        profil: 'Auxiliaire vétérinaire — Soins cliniques',
        tags: ['soin', 'clinique', 'assistance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu gères l\'accueil, rassures les propriétaires et coordonnes la logistique de la prise en charge',
        profil: 'Chargé·e de gestion en structure animalière',
        tags: ['gestion', 'accueil', 'coordination'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ta journée idéale dans le milieu animal, c\'est…',
    detecte: 'quotidien préféré — soin vs gestion',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Stériliser le matériel, assister aux opérations, surveiller les animaux en post-op',
        profil: 'Auxiliaire vétérinaire — Soins',
        tags: ['clinique', 'operation', 'surveillance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Gérer les rendez-vous, tenir les dossiers des animaux, accueillir et conseiller les propriétaires',
        profil: 'Gestion animalière / Accueil',
        tags: ['gestion', 'conseil', 'organisation'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ce que tu trouves le plus passionnant dans le travail avec les animaux, c\'est…',
    detecte: 'motivation principale — médical vs relationnel',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Comprendre les signes cliniques, les pathologies, participer aux soins médicaux',
        profil: 'Auxiliaire vétérinaire — Spécialité médicale',
        tags: ['medical', 'clinique', 'pathologie'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La relation avec les propriétaires, les conseils, la gestion du bien-être animal au quotidien',
        profil: 'Gestion et management animalier',
        tags: ['relation', 'conseil', 'bien-etre'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Un animal est stressé et mordant. Comment tu réagis ?',
    detecte: 'gestion animal difficile — technique vs approche',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu utilises les techniques de contention apprises, restes calme et procèdes méthodiquement',
        profil: 'Auxiliaire vétérinaire — Technique',
        tags: ['contention', 'technique', 'methode'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu prends le temps de le calmer, d\'observer son comportement, d\'adapter ton approche',
        profil: 'Comportement animal / Gestion',
        tags: ['comportement', 'patience', 'adaptation'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 5 ans, tu te vois…',
    detecte: 'vision finale — confirmation formation animale',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Auxiliaire vétérinaire spécialisé(e), reconnu(e) pour ta compétence technique en clinique',
        profil: 'Auxiliaire vétérinaire spécialité',
        tags: ['specialisation', 'technique', 'clinique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Responsable d\'une structure animalière, gérant une équipe et garantissant le bien-être animal',
        profil: 'Responsable structure animalière',
        tags: ['management', 'responsable', 'structure'],
      ),
    ],
  ),
];

// ── N3 JURIDIQUE ─────────────────────────────────────────────
// A = Assistant·e juridique (rédaction, dossiers)
// B = Collaborateur·trice notarial·e (conseil, actes)

const List<QuizQuestion> questionsNiveau3Juridique = [

  QuizQuestion(
    numero: 11,
    synopsis:
        'Tu es en stage dans un cabinet juridique.\n'
        'Un dossier urgent arrive ce matin.\n'
        'Le responsable te demande de prendre en charge une partie.',
    question: 'Tu préfères prendre en charge…',
    detecte: 'préférence tâche juridique — rédaction vs conseil',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La rédaction des courriers, la constitution du dossier, la recherche de jurisprudence',
        profil: 'Assistant·e Juridique — Rédaction',
        tags: ['redaction', 'dossier', 'recherche'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'L\'accueil du client, l\'explication de la procédure, la collecte des informations',
        profil: 'Collaborateur·trice Juriste / Notarial·e',
        tags: ['conseil', 'client', 'explication'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Dans un cabinet, la tâche que tu trouves la plus valorisante, c\'est…',
    detecte: 'source de satisfaction juridique — analyse vs contact',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Classer, archiver, rédiger des actes bien structurés — la rigueur documentaire',
        profil: 'Assistant·e Juridique',
        tags: ['rigueur', 'archives', 'actes'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Conseiller un client, expliquer ses droits, l\'accompagner dans ses démarches',
        profil: 'Collaborateur·trice Notarial·e',
        tags: ['conseil', 'droits', 'accompagnement'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ce qui t\'intéresse le plus dans le domaine juridique, c\'est…',
    detecte: 'motivation juridique — texte vs relation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La précision des textes, les procédures, les délais à respecter — la technicité du droit',
        profil: 'Assistant·e Juridique',
        tags: ['precision', 'procedure', 'technique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La relation humaine, comprendre les situations des gens, les aider à défendre leurs droits',
        profil: 'Collaborateur·trice Juriste / Notarial·e',
        tags: ['humain', 'defense', 'relation'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Un client arrive stressé, son dossier est incomplet. Tu…',
    detecte: 'gestion client juridique — organisation vs accompagnement',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Listes immédiatement les documents manquants et lui expliques la procédure à suivre',
        profil: 'Assistant·e Juridique',
        tags: ['organisation', 'procedure', 'liste'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Prends le temps de le calmer, de comprendre sa situation avant d\'organiser le dossier',
        profil: 'Collaborateur·trice — Conseil client',
        tags: ['ecoute', 'calme', 'empathie'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 5 ans, tu te vois…',
    detecte: 'vision finale — confirmation formation juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Expert(e) en gestion de dossiers juridiques, référent(e) de la rigueur documentaire du cabinet',
        profil: 'Assistant·e Juridique Senior',
        tags: ['expertise', 'dossier', 'rigueur'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Collaborateur·trice notarial·e ou juriste reconnu(e) pour ta relation client et tes conseils',
        profil: 'Collaborateur·trice Juriste Notarial',
        tags: ['notariat', 'conseil', 'client'],
      ),
    ],
  ),
];

// ── N3 SERVICE ───────────────────────────────────────────────
// A = Petite enfance / Accompagnement AEPE
// B = Relation client à distance

const List<QuizQuestion> questionsNiveau3Service = [

  QuizQuestion(
    numero: 11,
    synopsis:
        'Tu fais face à deux propositions de stage.\n'
        'L\'une dans une crèche avec des enfants de 0 à 3 ans.\n'
        'L\'autre dans un centre d\'appels pour conseiller des clients à distance.',
    question: 'Sans hésiter, tu choisis…',
    detecte: 'direction service — enfance vs relation client',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La crèche — le contact avec les enfants, les activités, l\'accompagnement au quotidien',
        profil: 'Petite enfance / AEPE',
        tags: ['enfance', 'creche', 'contact'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Le centre d\'appels — aider des gens à résoudre leurs problèmes, la relation à distance',
        profil: 'Conseiller·e Relation Client',
        tags: ['client', 'telephone', 'solution'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ce qui t\'énergise vraiment dans le travail, c\'est…',
    detecte: 'source d\'énergie — spontanéité vs résolution',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'L\'imprévisibilité et l\'énergie des enfants — chaque journée est différente et vivante',
        profil: 'Accompagnant·e Petite Enfance / Animateur·trice',
        tags: ['energie', 'enfants', 'vivant'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La satisfaction de résoudre le problème d\'un client et d\'entendre "merci, c\'est réglé"',
        profil: 'Conseiller·e Clientèle à Distance',
        tags: ['resolution', 'satisfaction', 'efficacite'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Une situation difficile au travail : un enfant pleure sans raison apparente / un client est agressif. Tu…',
    detecte: 'gestion de la tension — patience créative vs sang-froid',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Cherches à comprendre ce que ressent l\'enfant, tu t\'agenouilles à sa hauteur et tu l\'écoutes',
        profil: 'Accompagnant·e Petite Enfance',
        tags: ['empathie', 'patience', 'enfance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Gardes ton calme, reformules le problème avec professionnalisme et proposes une solution',
        profil: 'Conseiller·e Relation Client',
        tags: ['calme', 'professionnel', 'solution'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Ce qui t\'épanouit le plus dans la relation aux autres, c\'est…',
    detecte: 'type de relation — soutien émotionnel vs aide pratique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être une présence rassurante, participer au développement et à l\'éveil de quelqu\'un',
        profil: 'AEPE / Auxiliaire Petite Enfance',
        tags: ['eveil', 'developpement', 'presence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Être utile rapidement, donner la bonne information au bon moment, fidéliser la confiance',
        profil: 'Conseiller·e Clientèle',
        tags: ['utilite', 'rapidite', 'confiance'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 5 ans, ta plus grande fierté professionnelle, c\'est…',
    detecte: 'vision finale — confirmation formation service',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Avoir accompagné l\'éveil de dizaines d\'enfants et être un repère pour les familles',
        profil: 'AEPE / Animateur·trice périscolaire',
        tags: ['enfance', 'families', 'repere'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Être reconnu(e) pour la qualité de ta relation client et avoir fidélisé des centaines de personnes',
        profil: 'Conseiller·e Relation Client confirmé(e)',
        tags: ['relation', 'fidelisation', 'qualite'],
      ),
    ],
  ),
];

// ============================================================
// SÉLECTION DYNAMIQUE DU JEU N3
// Appelée par screen_quiz après calcul du pôle dominant
// ============================================================

List<QuizQuestion> getQuestionsNiveau3(String pole) {
  switch (pole) {
    case 'info':      return questionsNiveau3Info;
    case 'sante':     return questionsNiveau3Sante;
    case 'animal':    return questionsNiveau3Animal;
    case 'juridique': return questionsNiveau3Juridique;
    case 'service':   return questionsNiveau3Service;
    default:          return questionsNiveau3Info;
  }
}

// ── Calcul du pôle dominant après N1+N2 ──────────────────────
// Appelé par screen_quiz à la transition N2 → N3

String computeDominantPole(List answers) {
  // Comptage tags pôle N1
  final poleCount = <String, int>{};
  for (final a in answers) {
    if (a.level == 1 && a.pole != null) {
      poleCount[a.pole] = (poleCount[a.pole] ?? 0) + 1;
    }
  }

  final sortedPoles = poleCount.entries.toList()
    ..sort((x, y) => y.value.compareTo(x.value));
  String pole = sortedPoles.isNotEmpty ? sortedPoles[0].key : 'info';

  // Vérification cohérence avec direction N2
  final n2 = answers.where((a) => a.level == 2).toList();
  final n2A = n2.where((a) => a.letter == 'A').length;
  final n2B = n2.where((a) => a.letter == 'B').length;
  final dirN2 = n2A > n2B ? 'A' : 'B';

  // Si N2 contredit le pôle N1 → recalibrage sur 2e pôle
  if (pole == 'info' && dirN2 == 'B') {
    pole = sortedPoles.length > 1 ? sortedPoles[1].key : 'sante';
  }
  if ((pole == 'sante' || pole == 'animal' || pole == 'service') && dirN2 == 'A') {
    pole = sortedPoles.length > 1 ? sortedPoles[1].key : 'info';
  }

  return pole;
}