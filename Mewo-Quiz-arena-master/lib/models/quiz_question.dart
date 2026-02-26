import 'answer_record.dart';

// ============================================================
// models/quiz_question.dart — ENTONNOIR FULL DYNAMIQUE v4
// ============================================================
//
//  N1 (5 questions ABCD) → pôle dominant
//     ↓ charge le jeu N2 du pôle
//  N2 (5 questions AB, par pôle) → groupe métier
//     ↓ charge le jeu N3 du pôle + groupe
//  N3 (5 questions AB, par pôle+groupe) → spécialisation
//     ↓ résultat final : formation + métier + spécialisation
//
//  5 jeux N2 (un par pôle) :
//    questionsNiveau2Info / Sante / Animal / Juridique / Service
//
//  7 jeux N3 (un par branche pole+groupe) :
//    questionsNiveau3InfoTerrain / InfoDev
//    questionsNiveau3SanteContact / SanteExpertise
//    questionsNiveau3Animal
//    questionsNiveau3Juridique
//    questionsNiveau3Service
//
//  Fonctions publiques :
//    computeDominantPole(answers)  → String pole  (après N1)
//    computeMetierGroup(answers, pole) → String groupe (après N2)
//    getQuestionsNiveau2(pole)   → List<QuizQuestion>
//    getQuestionsNiveau3(pole, groupe) → List<QuizQuestion>
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
  final String? pole;    // tag pôle court — renseigné uniquement en N1
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
// NIVEAU 1 — Identification du pôle dominant
// 5 questions · 4 réponses A/B/C/D · pas de synopsis
// ============================================================

const List<QuizQuestion> questionsNiveau1 = [

  QuizQuestion(
    numero: 1,
    question: 'Ta série Netflix du moment, c\'est plutôt… ?',
    detecte: 'univers de préférence — indicateur pôle indirect',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Mr. Robot, Black Mirror, Silicon Valley',
        profil: 'Informatique', pole: 'info',
        tags: ['tech', 'logique', 'numerique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Grey\'s Anatomy, Urgences, Scrubs',
        profil: 'Santé', pole: 'sante',
        tags: ['soin', 'medical', 'empathie'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Suits, How to Get Away with Murder',
        profil: 'Juridique', pole: 'juridique',
        tags: ['droit', 'regles', 'defense'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Call the Midwife, Instinct Animal, Super Nanny',
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
        text: 'Celui/celle qui déchiffre les codes et cherche la logique des systèmes',
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
        text: 'Celui/celle qui motive l\'équipe, anime et gère les relations',
        profil: 'Service', pole: 'service',
        tags: ['animation', 'relation', 'communication'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 3,
    question: 'Tu vois quelqu\'un s\'effondrer dans la rue. Ton premier mouvement ?',
    detecte: 'réflexe instinctif face à une urgence — clé pôle Santé',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu t\'agenouilles directement et tu fais ce que tu peux avec tes mains\n— le reste, on verra après',
        profil: 'Santé', pole: 'sante',
        tags: ['soin', 'contact', 'direct', 'terrain'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu prends du recul une seconde, tu évalues la situation\net tu donnes des instructions claires aux gens autour',
        profil: 'Informatique', pole: 'info',
        tags: ['analyse', 'organisation', 'coordination', 'methode'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Tu identifies qui fait quoi, tu notes les éléments importants\net tu t\'assures que rien ne soit oublié',
        profil: 'Juridique', pole: 'juridique',
        tags: ['observation', 'documentation', 'ordre', 'rigueur'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Tu prends la main de la personne et tu restes là, calme,\nsans la lâcher — les autres s\'occupent du reste',
        profil: 'Service / Animal', pole: 'service',
        tags: ['presence', 'soutien', 'emotion', 'contact-humain'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 4,
    question: 'Tu regardes un jeu télévisé. Un candidat est éliminé\nà cause d\'une règle que personne ne lui avait expliquée. Ta réaction ?',
    detecte: 'réaction face à l\'injustice de procédure — clé pôle Juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu trouves ça inadmissible — les règles doivent être\nclaires et connues de tous avant de commencer',
        profil: 'Juridique', pole: 'juridique',
        tags: ['regles', 'equite', 'cadre', 'droit'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu ressens surtout de la peine pour lui\n— il s\'était tellement investi, c\'est cruel',
        profil: 'Santé / Service', pole: 'sante',
        tags: ['empathie', 'soutien', 'emotion', 'bienveillance'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Tu te demandes comment le format du jeu pourrait être\nmieux conçu pour que ce genre de situation n\'arrive plus',
        profil: 'Informatique', pole: 'info',
        tags: ['systeme', 'conception', 'amelioration', 'methode'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Tu t\'inquiètes surtout pour son état après le choc\n— ce genre d\'élimination peut vraiment déstabiliser quelqu\'un',
        profil: 'Service / Animal', pole: 'service',
        tags: ['attention', 'soin', 'presence', 'humain'],
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
        text: 'Un labo tech avec plusieurs écrans, du matériel, des lignes de code',
        profil: 'Informatique', pole: 'info',
        tags: ['tech', 'numerique', 'outil'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une clinique, un cabinet ou une salle de soin — calme et bienveillant',
        profil: 'Santé / Animal', pole: 'sante',
        tags: ['soin', 'medical', 'vivant'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Un open space vivant — familles, enfants, gens à aider au quotidien',
        profil: 'Service', pole: 'service',
        tags: ['relation', 'humain', 'animation'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Un bureau sobre et ordonné, des dossiers, des règles claires',
        profil: 'Juridique', pole: 'juridique',
        tags: ['rigueur', 'organisation', 'droit'],
      ),
    ],
  ),
];

// ============================================================
// NIVEAU 2 — Identification du métier / groupe
// 5 questions AB · adapté au pôle détecté en N1
// A = première direction  |  B = deuxième direction
// ============================================================

// ── N2 INFORMATIQUE ──────────────────────────────────────────
// A = Terrain / Infra / Réseau / Sécurité
// B = Dev / Conception / Architecture logicielle

const List<QuizQuestion> questionsNiveau2Info = [
  QuizQuestion(
    numero: 6,
    synopsis:
        'Premier jour de stage dans une boîte tech.\n'
        'Le responsable IT t\'accueille et te dit :\n'
        '"On a deux équipes qui vivent dans des mondes très différents.\n'
        'L\'une s\'assure que tout tourne — sans accroc, 24h/24.\n'
        'L\'autre construit les outils que les salariés ouvrent chaque matin.\n'
        'Tu as la journée pour observer. Par laquelle tu commences ?"',
    question: 'Tu choisis d\'aller voir…',
    detecte: 'préférence opérationnelle IT — infra/réseau vs dev/conception',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'L\'équipe qui veille à ce que rien ne s\'effondre\n— les serveurs, les connexions, ce qui tient tout en place',
        profil: 'Technicien Infra & Sécurité',
        tags: ['infra', 'stabilite', 'reseau', 'terrain'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'L\'équipe qui fabrique et améliore les outils\n— ce que tout le monde utilise pour faire son travail',
        profil: 'Développeur / Concepteur logiciel',
        tags: ['dev', 'creation', 'usagers', 'produit'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 7,
    synopsis: null,
    question: 'L\'appli interne rame depuis ce matin, tout le monde se plaint.\nOn te demande de regarder. Ton réflexe, c\'est de commencer par…',
    detecte: 'instinct de diagnostic IT — infra vs code',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Regarder du côté des machines et des connexions\n— si la tuyauterie est bouchée, l\'eau ne coule plus',
        profil: 'Technicien Infrastructure',
        tags: ['infra', 'diagnostic', 'equipement', 'reseau'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Ouvrir ce que l\'appli fait dans les coulisses\n— quelque chose dans sa logique interne fait probablement ramer',
        profil: 'Développeur / DBA',
        tags: ['code', 'logiciel', 'optimisation', 'debug'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 8,
    synopsis: null,
    question: 'Ton projet libre pour la semaine, ce serait…',
    detecte: 'appétence projet libre — infra vs développement',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Sécuriser le réseau, configurer des pare-feux, tester la résistance aux intrusions',
        profil: 'Technicien Cybersécurité',
        tags: ['securite', 'parefeu', 'intrusion', 'reseau'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Développer un outil interne ou une appli pour automatiser une tâche répétitive',
        profil: 'Développeur full stack',
        tags: ['dev', 'automatisation', 'outil', 'code'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 9,
    synopsis: null,
    question: 'Dans 3 ans, tu te vois…',
    detecte: 'projection professionnelle IT — terrain vs conception',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Gérer l\'infrastructure d\'une entreprise, ses serveurs et sa sécurité réseau',
        profil: 'Administrateur Infrastructure',
        tags: ['admin', 'infrastructure', 'serveur', 'securite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Créer des applications utilisées par des milliers de personnes chaque jour',
        profil: 'Développeur confirmé',
        tags: ['dev', 'application', 'creation', 'logiciel'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 10,
    synopsis: null,
    question: 'Ce qui te motive le plus dans l\'informatique, c\'est…',
    detecte: 'motivation IT — fiabilité systèmes vs création logicielle',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La fiabilité des systèmes, la sécurité, éviter les pannes — que tout tourne parfaitement',
        profil: 'Administrateur / Technicien Infra',
        tags: ['fiabilite', 'stabilite', 'securite', 'systeme'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Créer quelque chose de nouveau, coder, voir son projet prendre vie progressivement',
        profil: 'Développeur / Architecte logiciel',
        tags: ['creation', 'code', 'innovation', 'projet'],
      ),
    ],
  ),
];

// ── N2 SANTÉ ─────────────────────────────────────────────────
// A = Contact direct / Terrain / Présence quotidienne
// B = Expertise médicale / Consultation / Analyse

const List<QuizQuestion> questionsNiveau2Sante = [
  QuizQuestion(
    numero: 6,
    synopsis:
        'Tu es observateur(trice) dans un établissement de santé pour une journée.\n'
        'Un infirmier t\'accueille : "Deux univers coexistent ici.\n'
        'L\'équipe soignante au chevet des patients,\n'
        'et les experts en consultation spécialisée.\n'
        'Lequel t\'attire ?"',
    question: 'Tu as le choix entre deux missions pour la matinée…',
    detecte: 'préférence quotidien santé — présence terrain vs expertise consultation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Accompagner l\'aide-soignante au chevet des patients tout au long de la matinée',
        profil: 'Aide soignant·e / Secrétaire médicale',
        tags: ['presence', 'quotidien', 'patient', 'soin'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Assister un professionnel de santé lors de consultations spécialisées',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['consultation', 'specialise', 'expertise', 'analyse'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 7,
    synopsis: null,
    question: 'Ce qui t\'attire dans la santé, c\'est avant tout…',
    detecte: 'motivation santé — humanité vs expertise scientifique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être présent(e) au quotidien pour les patients — les soutenir dans les moments difficiles',
        profil: 'Aide soignant·e / Soignant terrain',
        tags: ['presence', 'soutien', 'humanite', 'quotidien'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Comprendre les pathologies, analyser, proposer des solutions précises et personnalisées',
        profil: 'Expert médical / Technicien santé',
        tags: ['analyse', 'pathologie', 'expertise', 'precision'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 8,
    synopsis: null,
    question: 'Une personne âgée a du mal à s\'alimenter correctement. Tu…',
    detecte: 'approche patient — relation humaine vs prescription médicale',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Prends le temps de t\'asseoir avec elle, de la rassurer et de l\'aider concrètement',
        profil: 'Aide soignant·e',
        tags: ['ecoute', 'soutien', 'relation', 'presence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Analyses ses habitudes alimentaires et proposes un plan nutritionnel adapté à sa situation',
        profil: 'Diététicien·ne',
        tags: ['analyse', 'nutrition', 'plan', 'expertise'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 9,
    synopsis: null,
    question: 'Le regard que tu veux que les autres portent sur toi dans 3 ans…',
    detecte: 'identité professionnelle santé — présence affective vs expertise',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: '"Il/elle est toujours là pour nous — on peut compter sur lui/elle"',
        profil: 'Aide soignant·e / Secrétaire médicale',
        tags: ['confiance', 'fiabilite', 'soutien', 'presence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: '"Son expertise est précieuse — il/elle sait exactement quoi faire"',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['expertise', 'competence', 'savoir', 'reference'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 10,
    synopsis: null,
    question: 'Dans ton travail idéal, tu passes tes journées à…',
    detecte: 'quotidien idéal santé — confirmation direction',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être aux côtés des patients dans les actes du quotidien — ou gérer l\'accueil et les dossiers',
        profil: 'Aide soignant·e / Secrétaire médicale',
        tags: ['quotidien', 'actes', 'presence', 'gestion'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Recevoir, analyser des cas, proposer des solutions thérapeutiques ou techniques personnalisées',
        profil: 'Diététicien·ne / Opticien·ne',
        tags: ['consultation', 'analyse', 'solution', 'specialite'],
      ),
    ],
  ),
];

// ── N2 ANIMAL ────────────────────────────────────────────────
// A = Soins cliniques / Assistance vétérinaire
// B = Gestion / Management en structure animalière

const List<QuizQuestion> questionsNiveau2Animal = [
  QuizQuestion(
    numero: 6,
    synopsis:
        'Tu passes une journée dans une clinique vétérinaire.\n'
        'Le responsable t\'accueille : "Deux équipes coexistent ici :\n'
        'l\'équipe soin — consultation, chirurgie, post-op —\n'
        'et l\'équipe gestion — accueil, planning, dossiers.\n'
        'Lequel te correspond ?"',
    question: 'Le vétérinaire te propose de choisir ton pôle pour la journée…',
    detecte: 'rôle instinctif structure animalière — soin clinique vs gestion',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'L\'équipe soin : consultation, assistance chirurgie, soins post-opératoires',
        profil: 'Auxiliaire vétérinaire — Soins cliniques',
        tags: ['soin', 'clinique', 'chirurgie', 'assistance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'L\'équipe gestion : accueil propriétaires, agenda, dossiers des animaux',
        profil: 'Chargé·e de gestion animalière',
        tags: ['gestion', 'accueil', 'organisation', 'planning'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 7,
    synopsis: null,
    question: 'Un animal arrive en urgence. Tu veux naturellement…',
    detecte: 'réflexe urgence vétérinaire — technique vs coordination',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Aider à stabiliser l\'animal, préparer le matériel et assister le vétérinaire',
        profil: 'Auxiliaire vétérinaire — Soins',
        tags: ['technique', 'soin', 'assistance', 'urgence'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Accueillir le propriétaire angoissé et coordonner la prise en charge',
        profil: 'Chargé·e d\'accueil / Gestion',
        tags: ['accueil', 'propriétaire', 'coordination', 'relation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 8,
    synopsis: null,
    question: 'Ta journée idéale dans ce secteur, c\'est…',
    detecte: 'quotidien préféré milieu animal',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Au bloc ou en salle de soin — au plus près des animaux en convalescence',
        profil: 'Auxiliaire vétérinaire — Clinique',
        tags: ['clinique', 'soins', 'bloc', 'animal'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'À l\'accueil, au téléphone ou à gérer les plannings et les dossiers des animaux',
        profil: 'Chargé·e de gestion animalière',
        tags: ['accueil', 'telephone', 'planning', 'dossiers'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 9,
    synopsis: null,
    question: 'Ce que tu veux maîtriser dans 2 ans…',
    detecte: 'compétence cible milieu animal',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Les gestes techniques : contention, prise de sang, préparation anesthésie',
        profil: 'Auxiliaire vétérinaire — Technique',
        tags: ['contention', 'technique', 'prelevement', 'chirurgie'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La gestion d\'une structure : planning, stock, facturation, équipe',
        profil: 'Chargé·e de gestion / Management',
        tags: ['gestion', 'facturation', 'planning', 'management'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 10,
    synopsis: null,
    question: 'Ta fierté dans ce secteur serait d\'avoir…',
    detecte: 'vision finale milieu animal — confirmation direction',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Été le bras droit du vétérinaire — reconnu(e) pour tes gestes techniques précis',
        profil: 'Auxiliaire vétérinaire Spécialisé',
        tags: ['technique', 'precision', 'veterinaire', 'specialisation'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Fait tourner une clinique ou un refuge comme une horloge — animaux et clients satisfaits',
        profil: 'Responsable de gestion animalière',
        tags: ['organisation', 'management', 'structure', 'satisfaction'],
      ),
    ],
  ),
];

// ── N2 JURIDIQUE ─────────────────────────────────────────────
// A = Rédaction / Constitution de dossiers / Actes
// B = Conseil / Relation client / Accompagnement

const List<QuizQuestion> questionsNiveau2Juridique = [
  QuizQuestion(
    numero: 6,
    synopsis:
        'Premier jour en cabinet juridique.\n'
        'L\'associé principal t\'explique : "Deux types de missions coexistent ici.\n'
        'Le travail documentaire — rédiger, archiver, constituer les dossiers.\n'
        'Et la relation client — accueillir, conseiller, accompagner.\n'
        'Tu as une journée pour découvrir."',
    question: 'Tu choisis ta première tâche de la matinée…',
    detecte: 'préférence tâche juridique — rédaction vs relation client',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Rédiger des courriers, constituer un dossier, rechercher de la jurisprudence',
        profil: 'Assistant·e Juridique — Rédaction',
        tags: ['redaction', 'dossier', 'jurisprudence', 'analyse'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Accueillir un client, recueillir ses informations et lui expliquer ses droits',
        profil: 'Collaborateur·trice Juriste / Notarial·e',
        tags: ['accueil', 'client', 'conseil', 'explication'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 7,
    synopsis: null,
    question: 'Ce qui t\'attire le plus dans le droit, c\'est…',
    detecte: 'motivation juridique — texte/procédure vs relation humaine',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La précision des textes, les procédures rigoureuses, l\'analyse de cas complexes',
        profil: 'Assistant·e Juridique',
        tags: ['precision', 'texte', 'procedure', 'analyse'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'L\'accompagnement des personnes — expliquer leurs droits, les conseiller dans leurs démarches',
        profil: 'Collaborateur·trice Juriste / Notarial·e',
        tags: ['accompagnement', 'conseil', 'droits', 'relation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 8,
    synopsis: null,
    question: 'Un dossier complexe est sur ton bureau. Ta réaction…',
    detecte: 'mode de travail juridique — méthode documentaire vs sens humain',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Tu plonges dedans avec méthode : tu analyses, tu structures et tu rédiges',
        profil: 'Assistant·e Juridique',
        tags: ['methode', 'analyse', 'structuration', 'redaction'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Tu cherches à comprendre la situation humaine derrière pour mieux conseiller',
        profil: 'Collaborateur·trice Juriste',
        tags: ['humain', 'contexte', 'conseil', 'empathie'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 9,
    synopsis: null,
    question: 'Dans 3 ans, on te reconnaît pour…',
    detecte: 'identité professionnelle juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Ta rigueur documentaire — tes dossiers sont irréprochables et tes délais toujours respectés',
        profil: 'Assistant·e Juridique Senior',
        tags: ['rigueur', 'documentation', 'delais', 'fiabilite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Ta relation client — tu expliques simplement des choses complexes et inspires confiance',
        profil: 'Collaborateur·trice Notarial·e',
        tags: ['relation', 'pedagogie', 'confiance', 'client'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 10,
    synopsis: null,
    question: 'Ta peur professionnelle dans le droit, c\'est de…',
    detecte: 'repoussoir professionnel juridique — confirmation direction',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Faire une erreur dans un acte, manquer un délai ou laisser passer une coquille critique',
        profil: 'Assistant·e Juridique',
        tags: ['erreur', 'delai', 'acte', 'rigueur'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Ne pas réussir à rassurer un client stressé ou ne pas mériter sa confiance',
        profil: 'Collaborateur·trice Juriste',
        tags: ['client', 'confiance', 'relation', 'soutien'],
      ),
    ],
  ),
];

// ── N2 SERVICE ───────────────────────────────────────────────
// A = Petite enfance / Très jeunes enfants / Famille
// B = Animation périscolaire / Groupes d'enfants plus grands

const List<QuizQuestion> questionsNiveau2Service = [
  QuizQuestion(
    numero: 6,
    synopsis:
        'Tu visites deux structures du secteur social et éducatif.\n'
        'La première accueille des bébés et tout-petits (0-3 ans).\n'
        'La seconde anime des groupes d\'enfants de 3 à 12 ans.\n'
        '"Deux métiers, deux univers. Lequel est vraiment toi ?"',
    question: 'Le lieu qui t\'attire le plus naturellement, c\'est…',
    detecte: 'tranche d\'âge et univers préféré — petite enfance vs animation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La crèche ou la halte-garderie — bébés, éveil, douceur, sécurité affective',
        profil: 'CAP AEPE — Petite enfance',
        tags: ['bebe', 'creche', 'eveil', 'affectif'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Le centre de loisirs ou l\'école — activités, groupes, projets, énergie',
        profil: 'CAP AEPE — Animation périscolaire',
        tags: ['animation', 'groupes', 'activites', 'creativite'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 7,
    synopsis: null,
    question: 'Ce qui te donne de l\'énergie dans ton travail, c\'est…',
    detecte: 'source d\'énergie professionnelle — sécurité affective vs animation collective',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Les câlins, le regard d\'un bébé qui te reconnaît, les premiers mots, les premiers pas',
        profil: 'Auxiliaire Petite Enfance / Assistante maternelle',
        tags: ['bebe', 'premiers-pas', 'attachement', 'eveil'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Organiser des activités, voir les enfants s\'amuser et progresser en groupe',
        profil: 'Animateur·trice périscolaire',
        tags: ['activites', 'groupe', 'animation', 'creativite'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 8,
    synopsis: null,
    question: 'Une journée difficile pour toi, c\'est…',
    detecte: 'situation redoutée — bébé inconsolable vs groupe désordonné',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un tout-petit qui pleure sans arrêt et que tu n\'arrives pas à consoler',
        profil: 'Auxiliaire Petite Enfance',
        tags: ['bebe', 'pleurs', 'consoler', 'patience'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une animation qui ne fonctionne pas et des enfants qui s\'ennuient ou se disputent',
        profil: 'Animateur·trice / Accompagnant éducatif',
        tags: ['animation', 'groupe', 'ennui', 'gestion'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 9,
    synopsis: null,
    question: 'Ton rôle idéal auprès des enfants…',
    detecte: 'rôle professionnel préféré — repère affectif vs animateur',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être un repère affectif stable et sécurisant pour de très jeunes enfants',
        profil: 'Auxiliaire Petite Enfance / Assistante maternelle',
        tags: ['repere', 'securite', 'affectif', 'stabilite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Créer et animer des activités éducatives et ludiques pour des groupes',
        profil: 'Animateur·trice périscolaire / Accompagnant éducatif',
        tags: ['creation', 'animation', 'education', 'groupe'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 10,
    synopsis: null,
    question: 'Ce que tu veux apporter à l\'enfant dans ton travail…',
    detecte: 'valeur transmise — confirmation direction service',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Sécurité, douceur, éveil sensoriel et affectif dans un cadre bienveillant',
        profil: 'AEPE — Petite enfance',
        tags: ['securite', 'douceur', 'eveil', 'bienveillance'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Découverte, jeu, socialisation et activités créatives en groupe',
        profil: 'AEPE — Animation périscolaire',
        tags: ['decouverte', 'jeu', 'social', 'creativite'],
      ),
    ],
  ),
];

// ============================================================
// NIVEAU 3 — Spécialisation précise
// 5 questions AB · adapté au pôle + groupe identifié en N2
// ============================================================

// ── N3 INFO TERRAIN ──────────────────────────────────────────
// Pôle info + groupe terrain identifié en N2
// A = Opérationnel / Bac-BTS (Technicien proximité, Technicien infra BTS)
// B = Expert / Licence-Master (Administrateur Réseaux Licence, Expert Réseau Master)

const List<QuizQuestion> questionsNiveau3InfoTerrain = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'L\'informatique infrastructure et réseau, c\'est ta voie.\n'
        'Il reste une question clé : quel niveau d\'expertise vises-tu ?\n'
        'Opérationnel sur le terrain rapidement —\n'
        'ou expert reconnu après une spécialisation plus longue ?',
    question: 'Face à une panne réseau critique, ton réflexe c\'est de…',
    detecte: 'approche panne — réactivité terrain vs analyse expert',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Dépanner immédiatement sur place, trouver la solution la plus rapide',
        profil: 'Technicien informatique de proximité / Technicien infra BTS',
        tags: ['terrain', 'rapidite', 'depannage', 'operationnel'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Analyser la cause profonde et créer une solution pérenne et documentée',
        profil: 'Administrateur Réseau / Expert Cyber Sécurité',
        tags: ['analyse', 'expertise', 'perenne', 'documentation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Après ta formation, tu veux avant tout…',
    detecte: 'priorité post-formation — emploi rapide vs montée en expertise',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Être opérationnel(le) rapidement et travailler en entreprise dès le BTS ou le Bac',
        profil: 'Technicien informatique Bac / Technicien infra BTS',
        tags: ['emploi', 'rapidite', 'bac', 'bts'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Continuer à te spécialiser (licence ou master) pour accéder à des responsabilités plus larges',
        profil: 'Administrateur Réseaux Licence / Expert Réseau Master',
        tags: ['specialisation', 'licence', 'master', 'expertise'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'La mission qui te fait vibrer le plus dans l\'infra IT, c\'est…',
    detecte: 'type de mission préférée infra — helpdesk/terrain vs architecture',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Interventions terrain, maintenance, helpdesk, déploiement de postes',
        profil: 'Technicien informatique de proximité / Technicien infra',
        tags: ['terrain', 'helpdesk', 'maintenance', 'deploiement'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Architecture réseau, audit de sécurité, tests d\'intrusion, gestion de la politique RSSI',
        profil: 'Administrateur Systèmes / Expert Cybersécurité',
        tags: ['architecture', 'audit', 'securite', 'rssi'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Dans 5 ans, tu veux être reconnu(e) comme…',
    detecte: 'identité professionnelle infra — technicien fiable vs expert référent',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un(e) technicien(ne) fiable et polyvalent(e), pilier de l\'équipe IT',
        profil: 'Technicien informatique de proximité (Bac) / Technicien infra BTS',
        tags: ['technicien', 'fiable', 'polyvalence', 'equipe'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Un(e) expert(e) en cybersécurité ou en architecture réseau, consulté(e) sur les choix stratégiques',
        profil: 'Administrateur Réseaux Cyber Sécurité (Licence) / Expert Réseau (Master)',
        tags: ['expert', 'securite', 'architecture', 'strategie'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ce qui te correspond le mieux au quotidien, c\'est…',
    detecte: 'vision finale infra — confirmation niveau ambition',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La polyvalence et la réactivité — gérer plusieurs incidents à la fois avec efficacité',
        profil: 'Technicien informatique de proximité (Bac N4) / Technicien infra & sécurité (BTS N5)',
        tags: ['polyvalence', 'reactivite', 'incidents', 'efficacite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La spécialisation poussée — devenir la référence incontestée sur ton domaine de sécurité',
        profil: 'Administrateur Système Réseaux Cyber Sécurité (Licence N6) / Expert réseau (Master N7)',
        tags: ['specialisation', 'reference', 'expert', 'securite'],
      ),
    ],
  ),
];

// ── N3 INFO DEV ──────────────────────────────────────────────
// Pôle info + groupe dev identifié en N2
// A = Développeur / BTS SIO / Licence Full Stack
// B = Architecte expert / Master Expert Architecture & Dev logiciel

const List<QuizQuestion> questionsNiveau3InfoDev = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'Le développement logiciel, c\'est ta voie.\n'
        'Il reste une question clé : quel niveau d\'ambition ?\n'
        'Développeur(se) opérationnel(le) qui livre du code —\n'
        'ou expert(e) en architecture qui conçoit les systèmes complexes ?',
    question: 'Sur un projet, ton approche naturelle, c\'est de…',
    detecte: 'approche projet dev — livrer du code vs concevoir l\'architecture',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Coder des fonctionnalités rapidement, itérer, livrer et améliorer en continu',
        profil: 'Développeur BTS SIO / Développeur Full Stack Licence',
        tags: ['code', 'livraison', 'iteration', 'fullstack'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Concevoir l\'architecture et les patterns avant de coder — penser la scalabilité dès le début',
        profil: 'Expert Architecture Dev Logiciel (Master)',
        tags: ['architecture', 'patterns', 'scalabilite', 'conception'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'La formation qui te correspond le mieux…',
    detecte: 'niveau ambition dev — BTS/Licence vs Master',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un BTS SIO ou une licence pour entrer rapidement dans le développement professionnel',
        profil: 'Développeur Informatique (BTS N5) / Développeur Full Stack (Licence N6)',
        tags: ['bts', 'licence', 'emploi', 'dev'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Un master pour maîtriser la conception de systèmes complexes et accéder aux postes de lead tech',
        profil: 'Expert Architecture & Dev Logiciel (Master N7)',
        tags: ['master', 'complexite', 'lead', 'expertise'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ton rôle idéal dans une équipe de développement…',
    detecte: 'rôle préféré équipe dev — développeur vs lead/architecte',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Développeur full stack qui livre des fonctionnalités propres et testées',
        profil: 'Développeur Informatique BTS SIO / Concepteur Dev Full Stack Licence',
        tags: ['fullstack', 'livraison', 'tests', 'fonctionnalites'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Lead tech ou architecte logiciel qui définit les choix techniques et structure la codebase',
        profil: 'Expert Architecture & Dev Logiciel (Master)',
        tags: ['lead', 'architecte', 'choix-techniques', 'structure'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Le projet qui te passionne le plus, c\'est…',
    detecte: 'type projet dev — application utilisable vs système complexe',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Une application web ou mobile utile, utilisée par des gens au quotidien',
        profil: 'Développeur BTS SIO / Concepteur Dev Web Full Stack Licence',
        tags: ['web', 'mobile', 'utilisateurs', 'pratique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Un système distribué, une API scalable ou une architecture microservices',
        profil: 'Expert Architecture & Dev Logiciel (Master)',
        tags: ['systeme-distribue', 'api', 'microservices', 'architecture'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 5 ans, tu te vois…',
    detecte: 'vision finale dev — confirmation niveau ambition',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Développeur(se) confirmé(e), freelance ou en entreprise — autonome et reconnu(e)',
        profil: 'Développeur Informatique (BTS SIO N5) / Concepteur Dev Web Full Stack (Licence N6)',
        tags: ['confirmé', 'freelance', 'autonome', 'dev'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Expert(e) logiciel ou futur CTO — celui/celle qui définit la vision technique d\'un produit',
        profil: 'Expert en Architecture et Développement logiciel (Master N7)',
        tags: ['expert', 'cto', 'vision', 'produit'],
      ),
    ],
  ),
];

// ── N3 SANTÉ CONTACT ─────────────────────────────────────────
// Pôle santé + groupe contact/terrain identifié en N2
// A = Aide-soignant (Bac N4) — soins directs au quotidien
// B = Secrétaire médicale (Bac N4) — accueil et gestion administrative

const List<QuizQuestion> questionsNiveau3SanteContact = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'Le contact avec les patients est au cœur de ta vocation.\n'
        'Mais deux métiers très différents s\'offrent à toi :\n'
        'les soins directs au chevet des patients —\n'
        'ou l\'accueil et la gestion administrative de la structure médicale.',
    question: 'En arrivant le matin dans une structure de santé, ta première envie c\'est de…',
    detecte: 'réflexe quotidien santé contact — soins directs vs accueil administratif',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Aller directement aider aux soins d\'hygiène et de confort des patients',
        profil: 'Aide-soignant·e',
        tags: ['soins', 'hygiene', 'confort', 'patient'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Ouvrir les dossiers, préparer les rendez-vous du jour et accueillir les premiers patients',
        profil: 'Secrétaire médicale',
        tags: ['dossiers', 'rendez-vous', 'accueil', 'administratif'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ce qui te valorise vraiment dans ton travail, c\'est…',
    detecte: 'source de fierté — soin physique vs organisation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Quand un patient te dit "merci" après une aide directe dans ses gestes du quotidien',
        profil: 'Aide-soignant·e',
        tags: ['gratitude', 'aide', 'gestes', 'quotidien'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Quand la salle d\'attente tourne comme une horloge et que les patients sont bien orientés',
        profil: 'Secrétaire médicale',
        tags: ['organisation', 'orientation', 'fluidite', 'efficacite'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Une situation difficile typique de ton futur quotidien…',
    detecte: 'gestion difficulté — soin physique vs urgence administrative',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un patient qui souffre physiquement — tu restes à ses côtés, tu soutiens, tu soulages',
        profil: 'Aide-soignant·e',
        tags: ['douleur', 'presence', 'soutien', 'soulagement'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une double réservation ou un patient très stressé à l\'accueil — tu géres, tu rassures',
        profil: 'Secrétaire médicale',
        tags: ['erreur', 'stress', 'accueil', 'gestion'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Ton ambiance de travail préférée, c\'est…',
    detecte: 'cadre de travail santé contact — mouvement vs poste',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'En mouvement permanent — chambre, couloir, salle de bains, toujours utile',
        profil: 'Aide-soignant·e',
        tags: ['mouvement', 'dynamisme', 'varié', 'physique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'À ton poste avec téléphone et ordinateur, les patients viennent à toi',
        profil: 'Secrétaire médicale',
        tags: ['poste-fixe', 'telephone', 'ordinateur', 'accueil'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ce que tu veux maîtriser dans 2 ans…',
    detecte: 'compétence cible santé contact — gestes soins vs outils administratifs',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Les gestes de soins : toilette, mobilisation, prévention des escarres, prise de constantes',
        profil: 'Aide-soignant·e (Bac N4)',
        tags: ['toilette', 'mobilisation', 'constantes', 'soins'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Les logiciels médicaux, la gestion des dossiers patients et la facturation',
        profil: 'Secrétaire médicale (Bac N4)',
        tags: ['logiciel', 'dossiers', 'facturation', 'administratif'],
      ),
    ],
  ),
];

// ── N3 SANTÉ EXPERTISE ───────────────────────────────────────
// Pôle santé + groupe expertise/analyse identifié en N2
// A = BTS Diététique et Nutrition (BTS N5)
// B = BTS Opticien Lunettier (BTS N5)

const List<QuizQuestion> questionsNiveau3SanteExpertise = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'L\'expertise médicale spécialisée t\'attire.\n'
        'Deux domaines de consultation s\'offrent à toi :\n'
        'l\'alimentation, la nutrition et la santé digestive —\n'
        'ou la vision, les yeux et l\'optique correctrice.',
    question: 'Le domaine qui te passionne vraiment, c\'est…',
    detecte: 'domaine expertise médicale — nutrition vs optique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'La nutrition, les régimes thérapeutiques, les maladies liées à l\'alimentation',
        profil: 'Diététicien·ne (BTS Diététique)',
        tags: ['nutrition', 'regime', 'alimentation', 'sante'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La vision, les yeux, les troubles de la réfraction et les solutions optiques',
        profil: 'Opticien·ne Lunettier (BTS Opticien)',
        tags: ['vision', 'optique', 'refraction', 'yeux'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Le type de consultation qui te correspond le plus…',
    detecte: 'type de consultation santé expertise',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Bilan nutritionnel, plan alimentaire personnalisé, suivi sur plusieurs semaines',
        profil: 'Diététicien·ne',
        tags: ['bilan', 'plan', 'nutritionnel', 'suivi'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Examen de vue, mesure de la réfraction, conseil et adaptation lunettes/lentilles',
        profil: 'Opticien·ne Lunettier',
        tags: ['examen-vue', 'refraction', 'lunettes', 'lentilles'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Le contexte professionnel qui t\'attire le plus…',
    detecte: 'environnement préféré santé expertise',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un hôpital ou cabinet diété — accompagner des patients diabétiques, obèses ou convalescents',
        profil: 'Diététicien·ne hospitalier / libéral',
        tags: ['hopital', 'diete', 'diabete', 'obesite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Un magasin d\'optique ou cabinet — conseiller, équiper, fidéliser des clients',
        profil: 'Opticien·ne Lunettier en boutique ou cabinet',
        tags: ['boutique', 'optique', 'conseil', 'commercial'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Ce qui te plaît particulièrement dans ce métier, c\'est de…',
    detecte: 'satisfaction professionnelle santé expertise',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Voir quelqu\'un perdre du poids, retrouver de l\'énergie et reprendre confiance grâce à toi',
        profil: 'Diététicien·ne',
        tags: ['poids', 'energie', 'confiance', 'sante'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Voir quelqu\'un mettre ses lunettes pour la première fois et découvrir la clarté du monde',
        profil: 'Opticien·ne Lunettier',
        tags: ['lunettes', 'vision', 'clarté', 'decouverte'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ce que tu veux approfondir dans ta formation…',
    detecte: 'compétence clé formation santé expertise — confirmation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Biochimie nutritionnelle, microbiote, alimentation thérapeutique et maladies métaboliques',
        profil: 'Diététicien·ne — BTS Diététique et Nutrition (BTS N5)',
        tags: ['biochimie', 'microbiote', 'therapeutique', 'metabolisme'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Anatomie oculaire, optique physique, géométrie des verres et technologie des lentilles',
        profil: 'Opticien·ne Lunettier — BTS Opticien Lunettier (BTS N5)',
        tags: ['anatomie-oculaire', 'optique', 'verres', 'lentilles'],
      ),
    ],
  ),
];

// ── N3 ANIMAL ────────────────────────────────────────────────
// Pôle animal — utilisé pour les deux groupes (clinique et gestion)
// Le groupe détecté en N2 est déjà précis (1 seule formation : Auxiliaire vét Bac N4)
// N3 confirme la spécialisation dans le métier choisi

const List<QuizQuestion> questionsNiveau3Animal = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'Ton univers animal est confirmé — Auxiliaire spécialité vétérinaire.\n'
        'Cette formation mène à deux métiers distincts :\n'
        'l\'auxiliaire vétérinaire dans les soins cliniques,\n'
        'ou le chargé de gestion en structure animalière.\n'
        'Ces questions vont affiner ton profil précis.',
    question: 'Ton quotidien idéal dans une structure animalière, c\'est…',
    detecte: 'spécialisation métier animal — clinique vs gestion',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'En salle de soin ou au bloc — soigner, surveiller, assister lors des actes médicaux',
        profil: 'Auxiliaire vétérinaire — Soins cliniques',
        tags: ['soin', 'clinique', 'bloc', 'actes'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'À l\'accueil, au bureau ou au téléphone — organiser, gérer, coordonner',
        profil: 'Chargé·e de gestion en structure animalière',
        tags: ['accueil', 'gestion', 'organisation', 'coordination'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ce que tu veux vraiment apprendre dans cette formation…',
    detecte: 'compétence cible formation animal',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Les gestes techniques : contention, prise de sang, préparation chirurgie, soins post-op',
        profil: 'Auxiliaire vétérinaire — Technique clinique',
        tags: ['contention', 'prise-sang', 'chirurgie', 'post-op'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'La gestion d\'une structure : planning, stock, facturation, accueil et relation client',
        profil: 'Chargé·e de gestion animalière',
        tags: ['planning', 'stock', 'facturation', 'relation-client'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'La situation qui t\'excite le plus dans ce secteur, c\'est…',
    detecte: 'situation motivante — soin urgent vs structure bien gérée',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Une urgence vétérinaire — tu es en salle avec le vét, chaque geste compte',
        profil: 'Auxiliaire vétérinaire — Urgences cliniques',
        tags: ['urgence', 'veterinaire', 'gestes', 'intervention'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Faire tourner une clinique ou un refuge avec fluidité — clients sereins, animaux bien pris en charge',
        profil: 'Responsable de gestion animalière',
        tags: ['fluidite', 'organisation', 'clients', 'refuge'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'Dans 3 ans, on te reconnaît pour…',
    detecte: 'identité professionnelle animal',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Ta précision dans les gestes techniques et la confiance que le vétérinaire te fait',
        profil: 'Auxiliaire vétérinaire Spécialisé·e',
        tags: ['precision', 'technique', 'confiance', 'specialisation'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Ta capacité à gérer une structure — propriétaires satisfaits, équipe bien organisée',
        profil: 'Chargé·e de gestion et management animalière',
        tags: ['gestion', 'management', 'satisfaction', 'organisation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Ce qui te donne le plus de satisfaction dans ce secteur…',
    detecte: 'satisfaction finale — confirmation métier animal',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un animal qui guérit grâce à des soins que tu as prodigués directement',
        profil: 'Auxiliaire vétérinaire — Soins (Bac N4)',
        tags: ['guerison', 'soins', 'direct', 'animal'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une structure bien organisée où chaque animal est suivi et chaque client satisfait',
        profil: 'Chargé·e de gestion en structure animalière (Bac N4)',
        tags: ['organisation', 'suivi', 'satisfaction', 'structure'],
      ),
    ],
  ),
];

// ── N3 JURIDIQUE ─────────────────────────────────────────────
// Pôle juridique — 1 seule formation (BTS Assistant Juridique N5)
// N3 confirme le métier : Assistant juridique vs Collaborateur juriste notarial

const List<QuizQuestion> questionsNiveau3Juridique = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'Ta voie : le droit. La formation est la même pour les deux métiers —\n'
        'BTS Assistant Juridique (BTS N5).\n'
        'Mais deux métiers très différents t\'attendent :\n'
        'l\'assistant juridique expert en dossiers et actes,\n'
        'ou le collaborateur juriste notarial expert en conseil.',
    question: 'La tâche qui t\'épanouit vraiment en cabinet, c\'est…',
    detecte: 'tâche préférée juridique — rédaction vs conseil',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Rédiger, archiver, préparer les actes — la précision documentaire est ta fierté',
        profil: 'Assistant·e Juridique — Rédaction et gestion documentaire',
        tags: ['redaction', 'archives', 'actes', 'precision'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Recevoir les clients, expliquer leurs droits et les accompagner dans leurs démarches',
        profil: 'Collaborateur·trice Juriste Notarial·e',
        tags: ['conseil', 'client', 'droits', 'accompagnement'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'Ta compétence clé dans le monde juridique, c\'est…',
    detecte: 'compétence distinctive juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Maîtriser les procédures, les délais et la terminologie juridique avec précision',
        profil: 'Assistant·e Juridique',
        tags: ['procedure', 'delais', 'terminologie', 'maitrise'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Créer de la confiance, expliquer simplement le droit à des non-juristes',
        profil: 'Collaborateur·trice Juriste Notarial·e',
        tags: ['confiance', 'pedagogie', 'simplification', 'relation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ta journée idéale en cabinet, c\'est…',
    detecte: 'quotidien préféré juridique — rédaction vs rendez-vous',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Journée de rédaction : courriers, mémoires, recherches juridiques dans les textes',
        profil: 'Assistant·e Juridique',
        tags: ['redaction', 'memoires', 'recherches', 'textes'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Journée de rendez-vous : clients variés, situations humaines différentes, conseil personnalisé',
        profil: 'Collaborateur·trice Juriste Notarial·e',
        tags: ['rendez-vous', 'clients', 'conseil', 'situations'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'La reconnaissance que tu veux dans ce métier…',
    detecte: 'identité professionnelle juridique',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Les avocats et notaires te font confiance pour les dossiers les plus complexes',
        profil: 'Assistant·e Juridique Senior',
        tags: ['confiance', 'avocats', 'dossiers', 'complexite'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Les clients te recommandent à leurs proches et reviennent te voir en priorité',
        profil: 'Collaborateur·trice Juriste / Notarial·e',
        tags: ['recommandation', 'fidelite', 'clients', 'relation'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 3 ans, tu te vois…',
    detecte: 'vision finale juridique — confirmation métier',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Expert(e) en gestion documentaire et actes juridiques — référence incontestée du cabinet',
        profil: 'Assistant·e Juridique (BTS N5)',
        tags: ['expertise', 'documentaire', 'actes', 'reference'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Collaborateur·trice juriste ou notarial·e reconnu(e) pour la qualité de ton conseil client',
        profil: 'Collaborateur·trice Juriste Notarial·e (BTS N5)',
        tags: ['juriste', 'notarial', 'conseil', 'qualite'],
      ),
    ],
  ),
];

// ── N3 SERVICE ───────────────────────────────────────────────
// Pôle service — 1 seule formation (CAP AEPE N3)
// N3 affine le métier parmi les 4 possibles

const List<QuizQuestion> questionsNiveau3Service = [
  QuizQuestion(
    numero: 11,
    synopsis:
        'Ton univers : les enfants et les familles — CAP Petite Enfance AEPE.\n'
        'Cette formation ouvre sur plusieurs métiers :\n'
        'accompagnement éducatif, animateur périscolaire,\n'
        'assistante maternelle ou garde d\'enfant.\n'
        'Ces questions vont préciser lequel est vraiment toi.',
    question: 'L\'environnement de travail qui te correspond le mieux…',
    detecte: 'cadre de travail service — structure collective vs domicile individuel',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Une crèche, une école ou un centre de loisirs — en collectivité organisée',
        profil: 'Accompagnant éducatif Petite Enfance / Animateur périscolaire',
        tags: ['creche', 'ecole', 'collectivite', 'structure'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Le domicile des enfants ou le mien — un cadre intime et personnalisé',
        profil: 'Assistante maternelle / Garde d\'enfant',
        tags: ['domicile', 'intime', 'personnalise', 'famille'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 12,
    synopsis: null,
    question: 'La tranche d\'âge que tu préfères…',
    detecte: 'âge préféré — confirmation métier service',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Bébés et enfants de 0 à 6 ans — l\'éveil, les premiers apprentissages',
        profil: 'Auxiliaire Petite Enfance / Assistante maternelle',
        tags: ['bebe', 'eveil', 'premiers-apprentissages', 'toutpetits'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Enfants de 3 à 12 ans — les activités, le groupe, les projets éducatifs',
        profil: 'Animateur périscolaire / Accompagnant éducatif',
        tags: ['activites', 'groupe', 'projets', 'education'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 13,
    synopsis: null,
    question: 'Ce qui te donne le plus d\'énergie dans ce travail, c\'est…',
    detecte: 'source d\'énergie service — affectif vs animation',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Le lien affectif fort, les routines rassurantes, les progrès dans le développement de l\'enfant',
        profil: 'AEPE / Assistante maternelle / Garde d\'enfant',
        tags: ['lien', 'affectif', 'routines', 'developpement'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Créer des activités, animer un groupe, voir les enfants s\'épanouir ensemble',
        profil: 'Animateur périscolaire / Accompagnant éducatif Petite Enfance',
        tags: ['activites', 'animation', 'epanouissement', 'groupe'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 14,
    synopsis: null,
    question: 'La relation avec les familles dans ton travail…',
    detecte: 'relation familles — partenariat quotidien vs cadre professionnel',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un lien fort et continu avec les parents — tu es un pilier de confiance pour la famille',
        profil: 'Assistante maternelle / Garde d\'enfant',
        tags: ['parents', 'confiance', 'pilier', 'continu'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Un contact régulier mais dans un cadre structuré — tu représentes l\'institution',
        profil: 'Animateur périscolaire / Accompagnant éducatif',
        tags: ['structure', 'institution', 'professionnel', 'regulier'],
      ),
    ],
  ),
  QuizQuestion(
    numero: 15,
    synopsis: null,
    question: 'Dans 5 ans, ta plus grande fierté professionnelle…',
    detecte: 'vision finale service — confirmation métier CAP AEPE',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Une famille qui te confie ses enfants depuis la naissance — tu es leur deuxième maison',
        profil: 'Assistante maternelle / Garde d\'enfant / AEPE (CAP N3)',
        tags: ['famille', 'confiance', 'naissance', 'quotidien'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Des enfants qui réclament tes activités et une ambiance périscolaire que tu as construite',
        profil: 'Animateur périscolaire / Accompagnant éducatif Petite Enfance (CAP N3)',
        tags: ['activites', 'periscolaire', 'ambiance', 'construction'],
      ),
    ],
  ),
];

// ============================================================
// FONCTIONS DE SÉLECTION DYNAMIQUE
// ============================================================

/// Retourne le jeu de questions N2 adapté au pôle dominant détecté en N1
List<QuizQuestion> getQuestionsNiveau2(String pole) {
  switch (pole) {
    case 'info':      return questionsNiveau2Info;
    case 'sante':     return questionsNiveau2Sante;
    case 'animal':    return questionsNiveau2Animal;
    case 'juridique': return questionsNiveau2Juridique;
    case 'service':   return questionsNiveau2Service;
    default:          return questionsNiveau2Info;
  }
}

/// Retourne le jeu de questions N3 adapté au pôle + groupe détectés en N1+N2
List<QuizQuestion> getQuestionsNiveau3(String pole, String metierGroup) {
  final key = '${pole}_$metierGroup';
  switch (key) {
    case 'info_terrain':        return questionsNiveau3InfoTerrain;
    case 'info_dev':            return questionsNiveau3InfoDev;
    case 'sante_contact':       return questionsNiveau3SanteContact;
    case 'sante_expertise':     return questionsNiveau3SanteExpertise;
    case 'animal_clinique':
    case 'animal_gestion':      return questionsNiveau3Animal;
    case 'juridique_redaction':
    case 'juridique_conseil':   return questionsNiveau3Juridique;
    case 'service_enfance':
    case 'service_animation':   return questionsNiveau3Service;
    default:                    return questionsNiveau3InfoTerrain;
  }
}

// ============================================================
// FONCTIONS DE CALCUL D'ORIENTATION
// ============================================================

/// Calcule le pôle dominant à partir des réponses N1 (champ pole renseigné)
String computeDominantPole(List<AnswerRecord> answers) {
  final poleCount = <String, int>{};
  for (final a in answers) {
    if (a.level == 1 && a.pole != null) {
      poleCount[a.pole!] = (poleCount[a.pole!] ?? 0) + 1;
    }
  }
  if (poleCount.isEmpty) return 'info';
  final sorted = poleCount.entries.toList()
    ..sort((x, y) => y.value.compareTo(x.value));
  return sorted.first.key;
}

/// Calcule le groupe métier à partir des réponses N2 (majorité A ou B)
String computeMetierGroup(List<AnswerRecord> answers, String pole) {
  final n2 = answers.where((a) => a.level == 2).toList();
  final n2A = n2.where((a) => a.letter == 'A').length;
  final n2B = n2.where((a) => a.letter == 'B').length;
  final goA = n2A >= n2B;
  switch (pole) {
    case 'info':      return goA ? 'terrain' : 'dev';
    case 'sante':     return goA ? 'contact' : 'expertise';
    case 'animal':    return goA ? 'clinique' : 'gestion';
    case 'juridique': return goA ? 'redaction' : 'conseil';
    case 'service':   return goA ? 'enfance' : 'animation';
    default:          return 'terrain';
  }
}