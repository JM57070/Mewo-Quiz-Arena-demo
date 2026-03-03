import 'answer_record.dart';

// ============================================================
// models/quiz_question.dart — ENTONNOIR FULL DYNAMIQUE v5
// ============================================================
//
//  N1 (8 questions ABCD) → pôle dominant
//     ↓ charge le jeu N2 du pôle
//  N2 (4 questions)
//     · ABCD pour info et sante (4 profils)
//     · AB   pour animal, juridique, service (2 profils)
//     ↓ charge le jeu N3 du pôle
//  N3 (4 questions)
//     · ABCD pour info et sante (confirmation)
//     · AB   pour animal, juridique, service
//     ↓ résultat final : formation + métier
//
//  Niveau d'études collecté APRÈS le quiz, avant affichage résultats.
//
//  Jeux N2 (5) :
//    questionsNiveau2Info / Sante / Animal / Juridique / Service
//
//  Jeux N3 (5) :
//    questionsNiveau3Info / Sante / Animal / Juridique / Service
//
//  Fonctions publiques :
//    computeDominantPole(answers)         → String pole   (après N1)
//    computeMetierGroup(answers, pole)    → String groupe (après N2)
//    computeSpecialisation(answers, pole) → String spec   (après N3 — info/sante seulement)
//    getQuestionsNiveau2(pole)            → List<QuizQuestion>
//    getQuestionsNiveau3(pole, groupe)    → List<QuizQuestion>
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
  final String? pole;   // renseigné uniquement en N1
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
// 8 questions · ABCD · questions indirectes, aucun métier nommé
// A → info  B → sante  C → juridique  D → service/animal
// ============================================================

const List<QuizQuestion> questionsNiveau1 = [

  QuizQuestion(
    numero: 1,
    question: 'Ta série Netflix du moment, c\'est plutôt… ?',
    detecte: 'univers de préférence — indicateur pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Mr. Robot, Black Mirror, Silicon Valley',
        profil: 'Informatique', pole: 'info', tags: ['tech', 'logique', 'numerique']),
      QuizAnswer(letter: 'B', text: 'Grey\'s Anatomy, Urgences, House M.D.',
        profil: 'Santé', pole: 'sante', tags: ['soin', 'medical', 'empathie']),
      QuizAnswer(letter: 'C', text: 'Suits, How to Get Away with Murder, Better Call Saul',
        profil: 'Juridique', pole: 'juridique', tags: ['droit', 'regles', 'defense']),
      QuizAnswer(letter: 'D', text: 'Super Nanny, Instinct Animal, Heartland',
        profil: 'Service / Animal', pole: 'service', tags: ['humain', 'enfance', 'animal']),
    ],
  ),

  QuizQuestion(
    numero: 2,
    question: 'Dans un escape room, tu incarnes naturellement…',
    detecte: 'rôle instinctif dans le groupe — compétences naturelles',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Celui/celle qui déchiffre les codes et cherche la logique cachée du système',
        profil: 'Informatique', pole: 'info', tags: ['logique', 'analyse', 'tech']),
      QuizAnswer(letter: 'B', text: 'Celui/celle qui prend soin du groupe et s\'assure que personne ne panique',
        profil: 'Santé / Animal', pole: 'sante', tags: ['empathie', 'soin', 'ecoute']),
      QuizAnswer(letter: 'C', text: 'Celui/celle qui relit les règles, gère le temps et vérifie les contraintes',
        profil: 'Juridique', pole: 'juridique', tags: ['rigueur', 'organisation', 'regles']),
      QuizAnswer(letter: 'D', text: 'Celui/celle qui motive l\'équipe et gère l\'ambiance du groupe',
        profil: 'Service', pole: 'service', tags: ['animation', 'relation', 'communication']),
    ],
  ),

  QuizQuestion(
    numero: 3,
    question: 'Un(e) candidat(e) dans un jeu TV est éliminé(e) à cause d\'une règle non expliquée. Ta réaction ?',
    detecte: 'réaction face à l\'injustice de procédure — clé pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Tu trouves ça inadmissible — les règles doivent être claires pour tous dès le départ',
        profil: 'Juridique', pole: 'juridique', tags: ['regles', 'equite', 'cadre']),
      QuizAnswer(letter: 'B', text: 'Tu ressens surtout de la peine pour lui/elle — il/elle s\'était tellement investi(e)',
        profil: 'Santé / Service', pole: 'sante', tags: ['empathie', 'soutien', 'emotion']),
      QuizAnswer(letter: 'C', text: 'Tu te demandes comment le format du jeu pourrait être mieux conçu pour éviter ça',
        profil: 'Informatique', pole: 'info', tags: ['systeme', 'conception', 'amelioration']),
      QuizAnswer(letter: 'D', text: 'Tu t\'inquiètes surtout pour son état après le choc — ce genre d\'élimination peut déstabiliser',
        profil: 'Service / Animal', pole: 'service', tags: ['attention', 'presence', 'humain']),
    ],
  ),

  QuizQuestion(
    numero: 4,
    question: 'Dans un RPG en monde ouvert, tu incarnes toujours…',
    detecte: 'archétype de jeu — rôle instinctif indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le hacker — il ouvre les portes verrouillées, coupe les alarmes, pirate les systèmes',
        profil: 'Informatique', pole: 'info', tags: ['tech', 'logique', 'infiltration']),
      QuizAnswer(letter: 'B', text: 'Le/la soigneur(se) — il/elle gère les potions, ramène ses allié(e)s à la vie, aucun(e) ne tombe',
        profil: 'Santé', pole: 'sante', tags: ['soin', 'protection', 'empathie']),
      QuizAnswer(letter: 'C', text: 'Le/la diplomate — il/elle lit les lois du monde, négocie les pactes, fait respecter les règles',
        profil: 'Juridique', pole: 'juridique', tags: ['droit', 'negociation', 'regles']),
      QuizAnswer(letter: 'D', text: 'Le/la protecteur(trice) — il/elle escorte les PNJ vulnérables, s\'occupe des créatures, garde le lien humain',
        profil: 'Service / Animal', pole: 'service', tags: ['protection', 'relation', 'vivant']),
    ],
  ),

  QuizQuestion(
    numero: 5,
    question: 'À une soirée, les autres savent qu\'ils peuvent compter sur toi pour…',
    detecte: 'rôle spontané dans un groupe social — indicateur pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Régler ce qui merde techniquement — son, vidéo, connexion, c\'est pour toi',
        profil: 'Informatique', pole: 'info', tags: ['tech', 'resolution', 'systeme']),
      QuizAnswer(letter: 'B', text: 'Sentir que quelqu\'un ne va pas et aller lui parler en premier',
        profil: 'Santé', pole: 'sante', tags: ['empathie', 'soin', 'ecoute']),
      QuizAnswer(letter: 'C', text: 'Veiller à ce que tout se passe bien — rien ne dérape, tout le monde a ce qu\'il faut',
        profil: 'Juridique', pole: 'juridique', tags: ['organisation', 'cadre', 'rigueur']),
      QuizAnswer(letter: 'D', text: 'Lancer l\'ambiance — jeux, activités, rires — tu embarques tout le monde',
        profil: 'Service / Animal', pole: 'service', tags: ['animation', 'relation', 'energie']),
    ],
  ),

  QuizQuestion(
    numero: 6,
    question: 'Un(e) ami(e) t\'appelle avec un problème grave. Ton premier instinct ?',
    detecte: 'réflexe face à une situation de détresse — clé pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Poser des questions précises pour comprendre exactement ce qui se passe',
        profil: 'Informatique', pole: 'info', tags: ['analyse', 'methode', 'logique']),
      QuizAnswer(letter: 'B', text: 'Rester avec lui/elle — l\'écouter vraiment, sans chercher à tout résoudre de suite',
        profil: 'Santé / Animal', pole: 'sante', tags: ['ecoute', 'presence', 'empathie']),
      QuizAnswer(letter: 'C', text: 'Regarder ses options, ce qu\'il/elle peut faire concrètement, ses droits',
        profil: 'Juridique', pole: 'juridique', tags: ['droits', 'options', 'cadre']),
      QuizAnswer(letter: 'D', text: 'Passer à l\'action : appeler quelqu\'un, t\'occuper de ce qu\'il y a à faire pour lui/elle',
        profil: 'Service / Animal', pole: 'service', tags: ['action', 'aide', 'concret']),
    ],
  ),

  QuizQuestion(
    numero: 7,
    question: 'Ce que les gens retiennent de toi après un projet de groupe…',
    detecte: 'identité perçue par les autres — confirmation pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: '"Impossible de le/la perdre — il/elle avait toujours une solution"',
        profil: 'Informatique', pole: 'info', tags: ['resolution', 'fiabilite', 'tech']),
      QuizAnswer(letter: 'B', text: '"On s\'est senti(e) pris(e) en charge — il/elle veillait sur tout le monde"',
        profil: 'Santé', pole: 'sante', tags: ['soin', 'bienveillance', 'presence']),
      QuizAnswer(letter: 'C', text: '"Rien ne lui échappait — les délais, les règles, les détails"',
        profil: 'Juridique', pole: 'juridique', tags: ['rigueur', 'organisation', 'precision']),
      QuizAnswer(letter: 'D', text: '"L\'ambiance, c\'était lui/elle — tout le monde allait bien"',
        profil: 'Service / Animal', pole: 'service', tags: ['animation', 'lien', 'humain']),
    ],
  ),

  QuizQuestion(
    numero: 8,
    question: 'Ton week-end idéal ressemble à…',
    detecte: 'environnement de prédilection — confirmation pôle indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Bidouiller un projet perso, explorer un truc technique qui t\'intrigue',
        profil: 'Informatique', pole: 'info', tags: ['tech', 'curiosite', 'projet']),
      QuizAnswer(letter: 'B', text: 'Accompagner quelqu\'un, être utile, prendre soin',
        profil: 'Santé', pole: 'sante', tags: ['soin', 'presence', 'aide']),
      QuizAnswer(letter: 'C', text: 'Tout planifier à l\'avance — aucune surprise, que du concret',
        profil: 'Juridique', pole: 'juridique', tags: ['organisation', 'controle', 'methode']),
      QuizAnswer(letter: 'D', text: 'Un endroit plein de vie — enfants, animaux, nature, énergie',
        profil: 'Service / Animal', pole: 'service', tags: ['vivant', 'nature', 'energie']),
    ],
  ),
];

// ============================================================
// NIVEAU 2 — Identification du profil dans le pôle
// 4 questions · ABCD pour info et sante · AB pour les autres
// ============================================================

// ── N2 INFORMATIQUE ──────────────────────────────────────────
// A = Technicien(ne) Infra Opérationnel (Bac N4 / BTS N5)
// B = Expert(e) Infra / Cybersécurité (Licence N6 / Master N7)
// C = Développeur(se) (BTS SIO N5 / Licence Full Stack N6)
// D = Architecte / Lead Tech (Master Expert Dev N7)

const List<QuizQuestion> questionsNiveau2Info = [

  QuizQuestion(
    numero: 9,
    question: 'Une voiture tombe en panne sur le bord de la route. Dans l\'équipe de secours, tu es…',
    detecte: 'réflexe face à un problème — profil IT indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Celui/celle qui ouvre le capot et règle le problème sur place, vite',
        profil: 'Technicien(ne) Infra — Terrain opérationnel',
        tags: ['terrain', 'rapidite', 'depannage', 'operationnel']),
      QuizAnswer(letter: 'B', text: 'Celui/celle qui cherche pourquoi ça a lâché pour que ça n\'arrive plus jamais',
        profil: 'Expert(e) Infra / Cybersécurité',
        tags: ['analyse', 'cause-profonde', 'perenne', 'securite']),
      QuizAnswer(letter: 'C', text: 'Celui/celle qui trouve l\'outil ou l\'appli qui aurait évité la panne — et qui l\'a déjà téléchargé(e)',
        profil: 'Développeur(se)', tags: ['dev', 'outil', 'appli', 'solution']),
      QuizAnswer(letter: 'D', text: 'Celui/celle qui repense tout le système de dépannage pour le rendre plus efficace à grande échelle',
        profil: 'Architecte / Lead Tech', tags: ['architecture', 'systeme', 'scalabilite', 'conception']),
    ],
  ),

  QuizQuestion(
    numero: 10,
    question: 'Dans un jeu vidéo, ton style de jeu naturel…',
    detecte: 'mode de jeu — confirme profil IT',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Les missions concrètes — réparer, déployer, gérer les ressources en temps réel',
        profil: 'Technicien(ne) Infra — Terrain', tags: ['concret', 'deploiement', 'ressources', 'terrain']),
      QuizAnswer(letter: 'B', text: 'Chercher les failles du système — les limites, les exploits, les zones non sécurisées',
        profil: 'Expert(e) Cybersécurité', tags: ['failles', 'securite', 'exploits', 'audit']),
      QuizAnswer(letter: 'C', text: 'Construire et améliorer en continu — un niveau de plus, une upgrade de plus',
        profil: 'Développeur(se)', tags: ['construction', 'amelioration', 'iteration', 'creation']),
      QuizAnswer(letter: 'D', text: 'Tout cartographier et planifier avant de poser la première pierre',
        profil: 'Architecte / Lead Tech', tags: ['cartographie', 'planification', 'strategie', 'vision']),
    ],
  ),

  QuizQuestion(
    numero: 11,
    question: 'Tu découvres un bug dans ton appli préférée. Ta réaction…',
    detecte: 'instinct face à un dysfonctionnement numérique',
    reponses: [
      QuizAnswer(letter: 'A', text: 'J\'espère que quelqu\'un va le corriger rapidement — ça me gêne au quotidien',
        profil: 'Technicien(ne) Infra — Terrain', tags: ['terrain', 'quotidien', 'correction', 'rapidite']),
      QuizAnswer(letter: 'B', text: 'Je veux savoir d\'où ça vient, quelle faille a permis ça, si c\'est exploitable',
        profil: 'Expert(e) Cybersécurité', tags: ['faille', 'exploitable', 'investigation', 'securite']),
      QuizAnswer(letter: 'C', text: 'Je me demande comment ils auraient pu l\'éviter en codant mieux',
        profil: 'Développeur(se)', tags: ['code', 'qualite', 'prevention', 'dev']),
      QuizAnswer(letter: 'D', text: 'Je visualise tout ce qu\'il faudrait revoir dans la structure du système',
        profil: 'Architecte / Lead Tech', tags: ['structure', 'refactoring', 'architecture', 'vision']),
    ],
  ),

  QuizQuestion(
    numero: 12,
    question: 'Tu montes un camp de base avec des ami(e)s. Ton rôle naturel…',
    detecte: 'rôle organisationnel spontané — confirmation profil IT',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Installer les équipements, vérifier que tout fonctionne, gérer les connexions',
        profil: 'Technicien(ne) Infra — Opérationnel', tags: ['installation', 'equipement', 'operationnel', 'terrain']),
      QuizAnswer(letter: 'B', text: 'Sécuriser le périmètre, anticiper les risques, établir les protocoles d\'urgence',
        profil: 'Expert(e) Infra / Cybersécurité', tags: ['securite', 'risques', 'protocoles', 'audit']),
      QuizAnswer(letter: 'C', text: 'Créer le planning des activités pour que tout le monde sache quoi faire et quand',
        profil: 'Développeur(se)', tags: ['planning', 'outil', 'organisation', 'creation']),
      QuizAnswer(letter: 'D', text: 'Concevoir l\'organisation complète avant même d\'arriver sur place',
        profil: 'Architecte / Lead Tech', tags: ['conception', 'architecture', 'anticipation', 'vision']),
    ],
  ),
];

// ── N2 SANTÉ ─────────────────────────────────────────────────
// A = Aide-soignant(e) (Bac N4 — accessible sans diplôme)
// B = Secrétaire médicale (Bac N4 — accessible sans diplôme)
// C = Diététicien(ne) (BTS N5 — Bac requis)
// D = Opticien(ne) lunetier (BTS N5 — CAP/BEP/Bac)

const List<QuizQuestion> questionsNiveau2Sante = [

  QuizQuestion(
    numero: 9,
    question: 'Dans un restaurant avec un groupe, tu es le/la convive qui…',
    detecte: 'comportement de table — indicateur profil santé indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Fait attention à ce que les autres ont dans l\'assiette avant de commander',
        profil: 'Aide-soignant(e)', tags: ['attention', 'soin', 'observation', 'presence']),
      QuizAnswer(letter: 'B', text: 'Gère la logistique — réservation, placement, commande groupée, tout est cadré',
        profil: 'Secrétaire médicale', tags: ['logistique', 'organisation', 'gestion', 'coordination']),
      QuizAnswer(letter: 'C', text: 'Analyse la carte en détail — composition, ingrédients, mode de cuisson',
        profil: 'Diététicien(ne)', tags: ['nutrition', 'analyse', 'ingredients', 'alimentation']),
      QuizAnswer(letter: 'D', text: 'Réclame une autre table dès l\'arrivée — la lumière ici est horrible, ça gâche tout',
        profil: 'Opticien(ne) lunetier', tags: ['lumiere', 'vision', 'confort-visuel', 'detail']),
    ],
  ),

  QuizQuestion(
    numero: 10,
    question: 'Ton/ta proche vient de recevoir des résultats médicaux inquiétants. Il/elle pense à toi en premier parce que tu…',
    detecte: 'rôle spontané face à une situation médicale — profil santé indirect',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Es toujours là physiquement — présent(e), tu restes avec lui/elle, tu t\'occupes de ce qu\'il y a à faire',
        profil: 'Aide-soignant(e)', tags: ['presence', 'physique', 'soutien', 'concret']),
      QuizAnswer(letter: 'B', text: 'Sais exactement qui appeler, quel spécialiste trouver, comment organiser la suite',
        profil: 'Secrétaire médicale', tags: ['organisation', 'coordination', 'specialiste', 'gestion']),
      QuizAnswer(letter: 'C', text: 'Vas lui parler de ce qu\'il/elle mange — tu sais que ça joue sur presque tout',
        profil: 'Diététicien(ne)', tags: ['alimentation', 'nutrition', 'conseil', 'sante']),
      QuizAnswer(letter: 'D', text: 'Vas lui poser des questions sur sa vue, ses maux de tête, sa fatigue visuelle — tu remarques ces choses-là',
        profil: 'Opticien(ne) lunetier', tags: ['vision', 'vue', 'fatigue-visuelle', 'observation']),
    ],
  ),

  QuizQuestion(
    numero: 11,
    question: 'Quelqu\'un dans ton entourage est à plat. Ton réflexe naturel, c\'est…',
    detecte: 'mode d\'aide — confirmation profil santé',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Débarquer et aider concrètement — tu fais ce qu\'il y a à faire, tu es là',
        profil: 'Aide-soignant(e)', tags: ['action', 'presence', 'aide-concrete', 'soin']),
      QuizAnswer(letter: 'B', text: 'Organiser pour lui/elle — rendez-vous, contacts, liste — pour qu\'il/elle n\'ait plus à y penser',
        profil: 'Secrétaire médicale', tags: ['organisation', 'planning', 'coordination', 'gestion']),
      QuizAnswer(letter: 'C', text: 'Lui parler de ce qu\'il/elle mange — tu sais que l\'alimentation change vraiment les choses',
        profil: 'Diététicien(ne)', tags: ['alimentation', 'conseil', 'nutrition', 'bien-etre']),
      QuizAnswer(letter: 'D', text: 'Observer s\'il/elle a l\'air fatigué(e), les yeux tirés — tu repères ces détails que les autres ratent',
        profil: 'Opticien(ne) lunetier', tags: ['observation', 'yeux', 'fatigue', 'detail']),
    ],
  ),

  QuizQuestion(
    numero: 12,
    question: 'Si tu passais une journée dans un hôpital, tu choisirais…',
    detecte: 'environnement santé préféré — confirmation profil',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le service de soins — être au chevet des patient(e)s tout au long de la journée',
        profil: 'Aide-soignant(e)', tags: ['chevet', 'soins', 'quotidien', 'patient']),
      QuizAnswer(letter: 'B', text: 'L\'accueil et l\'administration — gérer le flux, les dossiers, orienter les gens',
        profil: 'Secrétaire médicale', tags: ['accueil', 'dossiers', 'flux', 'administratif']),
      QuizAnswer(letter: 'C', text: 'La consultation spécialisée nutrition — voir comment l\'alimentation influence la guérison',
        profil: 'Diététicien(ne)', tags: ['nutrition', 'consultation', 'guerison', 'specialisation']),
      QuizAnswer(letter: 'D', text: 'L\'unité d\'ophtalmologie — la précision technique des yeux te fascine',
        profil: 'Opticien(ne) lunetier', tags: ['ophtalmologie', 'yeux', 'precision', 'technique']),
    ],
  ),
];

// ── N2 ANIMAL ────────────────────────────────────────────────
// A = Soins cliniques (Auxiliaire vétérinaire — Bac N4)
// B = Gestion animalière (Chargé(e) de gestion — Bac N4)

const List<QuizQuestion> questionsNiveau2Animal = [

  QuizQuestion(
    numero: 9,
    question: 'Dans un zoo, tu passes le plus de temps à observer…',
    detecte: 'centre d\'intérêt animal — soin vs organisation',
    reponses: [
      QuizAnswer(letter: 'A', text: 'La façon dont les soigneurs interagissent physiquement avec les animaux',
        profil: 'Auxiliaire vétérinaire — Soins cliniques', tags: ['soin', 'contact', 'animal', 'technique']),
      QuizAnswer(letter: 'B', text: 'Comment le lieu est organisé — flux, logistique, accueil des visiteurs',
        profil: 'Chargé(e) de gestion animalière', tags: ['gestion', 'logistique', 'accueil', 'organisation']),
    ],
  ),

  QuizQuestion(
    numero: 10,
    question: 'Un animal blessé débarque chez toi. Ton réflexe…',
    detecte: 'réflexe urgence animal — soin direct vs coordination',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Tu t\'en occupes directement — tu examines, tu stabilises, tu surveilles',
        profil: 'Auxiliaire vétérinaire — Clinique', tags: ['examen', 'stabilisation', 'soin', 'direct']),
      QuizAnswer(letter: 'B', text: 'Tu cherches qui appeler, tu coordonnes, tu prends en charge l\'organisation',
        profil: 'Chargé(e) de gestion animalière', tags: ['coordination', 'organisation', 'contact', 'gestion']),
    ],
  ),

  QuizQuestion(
    numero: 11,
    question: 'Dans une série sur des vétérinaires, ce qui te captive le plus…',
    detecte: 'attrait narratif — actes médicaux vs coulisses organisationnelles',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Les scènes de soins, d\'opération, de diagnostic — le lien entre l\'humain et l\'animal',
        profil: 'Auxiliaire vétérinaire', tags: ['soins', 'operation', 'diagnostic', 'lien']),
      QuizAnswer(letter: 'B', text: 'Les coulisses : comment la clinique tourne, comment l\'équipe s\'organise',
        profil: 'Chargé(e) de gestion animalière', tags: ['coulisses', 'organisation', 'equipe', 'structure']),
    ],
  ),

  QuizQuestion(
    numero: 12,
    question: 'Ce qui te touche le plus avec les animaux…',
    detecte: 'source de satisfaction — confirmation profil animal',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le lien direct et physique — les soigner, sentir leur confiance, les voir guérir',
        profil: 'Auxiliaire vétérinaire — Soins', tags: ['lien', 'guerison', 'confiance', 'physique']),
      QuizAnswer(letter: 'B', text: 'Voir une structure bien huilée où chaque animal est suivi et chaque propriétaire rassuré(e)',
        profil: 'Chargé(e) de gestion animalière', tags: ['structure', 'suivi', 'satisfaction', 'organisation']),
    ],
  ),
];

// ── N2 JURIDIQUE ─────────────────────────────────────────────
// A = Rédaction / Actes (Assistant(e) juridique)
// B = Conseil / Relation client (Collaborateur(trice) juriste notarial(e))

const List<QuizQuestion> questionsNiveau2Juridique = [

  QuizQuestion(
    numero: 9,
    question: 'Dans une série judiciaire, ce qui te captive le plus, c\'est…',
    detecte: 'attrait narratif juridique — dossiers vs plaidoiries',
    reponses: [
      QuizAnswer(letter: 'A', text: 'La préparation en coulisses — les dossiers, les preuves, la stratégie construite argument par argument',
        profil: 'Assistant(e) Juridique — Rédaction', tags: ['dossiers', 'preuves', 'strategie', 'precision']),
      QuizAnswer(letter: 'B', text: 'Les plaidoiries — la façon dont un(e) avocat(e) retourne une salle entière avec ses mots',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['plaidoirie', 'oral', 'persuasion', 'relation']),
    ],
  ),

  QuizQuestion(
    numero: 10,
    question: 'Un(e) ami(e) a signé un contrat douteux. Tu…',
    detecte: 'mode d\'aide juridique — analyse textuelle vs accompagnement',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Lis le contrat en détail, repères les clauses problématiques, analyses les options',
        profil: 'Assistant(e) Juridique', tags: ['contrat', 'analyse', 'clauses', 'methode']),
      QuizAnswer(letter: 'B', text: 'L\'écoutes, lui expliques calmement ce qu\'il/elle peut faire, le/la rassures',
        profil: 'Collaborateur(trice) Juriste', tags: ['ecoute', 'explication', 'conseil', 'relation']),
    ],
  ),

  QuizQuestion(
    numero: 11,
    question: 'Dans une équipe, ton rôle naturel c\'est…',
    detecte: 'positionnement naturel — documentation vs interface humaine',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Vérifier que tout est documenté, bien rédigé, rien d\'oublié ou de flou',
        profil: 'Assistant(e) Juridique', tags: ['documentation', 'rigueur', 'redaction', 'controle']),
      QuizAnswer(letter: 'B', text: 'Être l\'interface — expliquer, clarifier, faire le lien entre les parties',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['interface', 'explication', 'lien', 'mediation']),
    ],
  ),

  QuizQuestion(
    numero: 12,
    question: 'Ce qui t\'attire dans les séries juridiques…',
    detecte: 'confirmation profil juridique',
    reponses: [
      QuizAnswer(letter: 'A', text: 'La précision des arguments, la construction des dossiers, la rigueur des textes',
        profil: 'Assistant(e) Juridique', tags: ['precision', 'arguments', 'dossiers', 'textes']),
      QuizAnswer(letter: 'B', text: 'Les face-à-face humains, les client(e)s, les histoires derrière chaque affaire',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['humain', 'client', 'relation', 'histoire']),
    ],
  ),
];

// ── N2 SERVICE ───────────────────────────────────────────────
// A = Petite enfance 0-3 ans
// B = Animation périscolaire 3-12 ans

const List<QuizQuestion> questionsNiveau2Service = [

  QuizQuestion(
    numero: 9,
    question: 'Dans une famille avec des enfants de tous âges, tu gravites naturellement vers…',
    detecte: 'tranche d\'âge préférée — petite enfance vs animation',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Les tout-petits — les tenir, les bercer, observer leurs premières réactions',
        profil: 'Petite enfance 0-3 ans', tags: ['bebe', 'tout-petit', 'eveil', 'douceur']),
      QuizAnswer(letter: 'B', text: 'Les plus grand(e)s — jouer, organiser des activités, débattre avec eux/elles',
        profil: 'Animation périscolaire 3-12 ans', tags: ['jeu', 'activites', 'groupe', 'energie']),
    ],
  ),

  QuizQuestion(
    numero: 10,
    question: 'Ce qui te touche le plus avec les enfants…',
    detecte: 'source d\'émotion — affectif vs collectif',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Un bébé qui sourit en te reconnaissant — ce lien silencieux, ce tout début',
        profil: 'Auxiliaire Petite Enfance', tags: ['bebe', 'lien', 'reconnaissance', 'affectif']),
      QuizAnswer(letter: 'B', text: 'Un groupe qui s\'emballe sur une activité que tu as créée — l\'énergie collective',
        profil: 'Animateur(trice) périscolaire', tags: ['groupe', 'activite', 'energie', 'animation']),
    ],
  ),

  QuizQuestion(
    numero: 11,
    question: 'Une journée difficile dans ce travail, c\'est…',
    detecte: 'situation redoutée — confirmation profil service',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Un tout-petit inconsolable que rien ne calme',
        profil: 'Auxiliaire Petite Enfance', tags: ['bebe', 'pleurs', 'consoler', 'patience']),
      QuizAnswer(letter: 'B', text: 'Une animation qui tombe à plat — les enfants s\'ennuient ou se disputent',
        profil: 'Animateur(trice) périscolaire', tags: ['animation', 'groupe', 'ennui', 'conflit']),
    ],
  ),

  QuizQuestion(
    numero: 12,
    question: 'Ton rôle naturel avec les enfants…',
    detecte: 'identité professionnelle enfance — confirmation',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le/la référent(e) affectif(ve) — sécurisant(e), doux/douce, un repère stable',
        profil: 'AEPE — Petite enfance', tags: ['repere', 'securite', 'affectif', 'douceur']),
      QuizAnswer(letter: 'B', text: 'L\'animateur(trice) — créatif(ve), dynamique, toujours une idée dans la manche',
        profil: 'AEPE — Animation périscolaire', tags: ['animation', 'creativite', 'dynamisme', 'projets']),
    ],
  ),
];

// ============================================================
// NIVEAU 3 — Confirmation et spécialisation
// 4 questions · ABCD pour info et sante · AB pour les autres
// ============================================================

// ── N3 INFORMATIQUE ──────────────────────────────────────────
// A = Technicien(ne) Infra Opérationnel (Bac N4 / BTS N5)
// B = Expert(e) Cybersécurité / Réseau (Licence N6 / Master N7)
// C = Développeur(se) (BTS SIO N5 / Licence Full Stack N6)
// D = Architecte / Expert Dev (Master N7)

const List<QuizQuestion> questionsNiveau3Info = [

  QuizQuestion(
    numero: 13,
    question: 'Un nouveau projet débarque. Ta première pensée…',
    detecte: 'réflexe de départ — confirmation profil IT',
    reponses: [
      QuizAnswer(letter: 'A', text: '"C\'est quoi la tâche concrète ? Je commence maintenant."',
        profil: 'Technicien(ne) Infra — Terrain opérationnel', tags: ['concret', 'action', 'immediat', 'terrain']),
      QuizAnswer(letter: 'B', text: '"Quels sont les risques ? Qu\'est-ce qu\'on protège ici ?"',
        profil: 'Expert(e) Cybersécurité / Réseau', tags: ['risque', 'protection', 'securite', 'audit']),
      QuizAnswer(letter: 'C', text: '"C\'est quoi la fonctionnalité côté utilisateur ? Je veux la livrer vite."',
        profil: 'Développeur(se)', tags: ['fonctionnalite', 'utilisateur', 'livraison', 'dev']),
      QuizAnswer(letter: 'D', text: '"Comment ça s\'intègre dans le reste ? Il faut penser la structure d\'abord."',
        profil: 'Architecte / Lead Tech', tags: ['integration', 'structure', 'conception', 'vision']),
    ],
  ),

  QuizQuestion(
    numero: 14,
    question: 'Dans ton équipe idéale, quel rôle tu joues ?',
    detecte: 'positionnement naturel — confirmation profil IT',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le/la pompier(ière) — réactif(ve), toujours disponible(e) quand ça brûle',
        profil: 'Technicien(ne) Infra — Bac N4 / BTS N5', tags: ['reactivite', 'terrain', 'urgence', 'disponibilite']),
      QuizAnswer(letter: 'B', text: 'Le/la gardien(ne) — je surveille, j\'alerte, rien ne passe sans mon regard',
        profil: 'Administrateur(trice) Réseaux / Expert(e) Cyber — Licence N6 / Master N7', tags: ['surveillance', 'alerte', 'securite', 'vigilance']),
      QuizAnswer(letter: 'C', text: 'Le/la constructeur(trice) — je fabrique, je livre, j\'améliore en continu',
        profil: 'Développeur(se) — BTS SIO N5 / Licence Full Stack N6', tags: ['fabrication', 'livraison', 'amelioration', 'creation']),
      QuizAnswer(letter: 'D', text: 'L\'architecte — je trace les plans avant que quiconque pose une pierre',
        profil: 'Expert(e) Architecture Dev — Master N7', tags: ['plans', 'architecture', 'anticipation', 'conception']),
    ],
  ),

  QuizQuestion(
    numero: 15,
    question: 'Ce qui te satisfait profondément dans un projet réussi…',
    detecte: 'source de fierté IT — confirmation spécialisation',
    reponses: [
      QuizAnswer(letter: 'A', text: 'L\'équipe a tourné sans accroc — rien n\'est tombé, tout le monde a pu travailler',
        profil: 'Technicien(ne) Infra — Opérationnel', tags: ['fiabilite', 'stabilite', 'equipe', 'continuite']),
      QuizAnswer(letter: 'B', text: 'J\'ai détecté une faille que personne d\'autre n\'avait vue',
        profil: 'Expert(e) Cybersécurité', tags: ['detection', 'faille', 'expertise', 'securite']),
      QuizAnswer(letter: 'C', text: 'Des gens utilisent quelque chose que j\'ai construit de mes mains',
        profil: 'Développeur(se)', tags: ['creation', 'utilisateurs', 'produit', 'fierte']),
      QuizAnswer(letter: 'D', text: 'Le système que j\'ai conçu tient même à 100x le volume prévu',
        profil: 'Architecte / Lead Tech', tags: ['scalabilite', 'conception', 'robustesse', 'systeme']),
    ],
  ),

  QuizQuestion(
    numero: 16,
    question: 'Une nouvelle technologie débarque dans ton secteur. Tu fais quoi ?',
    detecte: 'rapport à la nouveauté — vision finale profil IT',
    reponses: [
      QuizAnswer(letter: 'A', text: 'J\'attends de voir comment ça se stabilise, puis je l\'intègre dans mon environnement',
        profil: 'Technicien(ne) Informatique de proximité (Bac N4) / Technicien(ne) Infra & Sécu (BTS N5)',
        tags: ['integration', 'stabilisation', 'terrain', 'pragmatisme']),
      QuizAnswer(letter: 'B', text: 'J\'analyse les risques avant tout — est-ce que c\'est sécurisé, fiable ?',
        profil: 'Administrateur(trice) Système Réseaux & Cybersécurité (Licence N6) / Expert(e) Réseau (Master N7)',
        tags: ['risques', 'securite', 'fiabilite', 'audit']),
      QuizAnswer(letter: 'C', text: 'Je teste directement — je code un prototype pour voir ce que ça donne',
        profil: 'Développeur(se) Informatique (BTS SIO N5) / Concepteur(trice) Dev Web Full Stack (Licence N6)',
        tags: ['prototype', 'test', 'code', 'experimentation']),
      QuizAnswer(letter: 'D', text: 'Je lis toute la documentation d\'architecture avant de toucher quoi que ce soit',
        profil: 'Expert(e) en Architecture et Développement logiciel (Master N7)',
        tags: ['documentation', 'architecture', 'comprehension', 'vision']),
    ],
  ),
];

// ── N3 SANTÉ ─────────────────────────────────────────────────
// A = Aide-soignant(e) (Bac N4 — ASD)
// B = Secrétaire médicale (Bac N4 — ASD)
// C = Diététicien(ne) (BTS Diététique N5 — Bac requis)
// D = Opticien(ne) lunetier (BTS Opticien N5 — CAP/BEP/Bac)

const List<QuizQuestion> questionsNiveau3Sante = [

  QuizQuestion(
    numero: 13,
    question: 'Le moment de ta journée que tu attends le plus…',
    detecte: 'moment préféré — confirmation profil santé',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Être utile physiquement — agir, bouger, aider concrètement quelqu\'un',
        profil: 'Aide-soignant(e)', tags: ['physique', 'action', 'mouvement', 'aide']),
      QuizAnswer(letter: 'B', text: 'Quand tout est bien organisé et que ça tourne sans accroc',
        profil: 'Secrétaire médicale', tags: ['organisation', 'fluidite', 'efficacite', 'gestion']),
      QuizAnswer(letter: 'C', text: 'Comprendre un cas complexe et trouver la solution adaptée à la personne',
        profil: 'Diététicien(ne)', tags: ['analyse', 'cas-complexe', 'solution', 'personnalise']),
      QuizAnswer(letter: 'D', text: 'L\'instant précis où quelqu\'un voit mieux grâce à quelque chose que tu as fait',
        profil: 'Opticien(ne) lunetier', tags: ['vision', 'resultat', 'precision', 'satisfaction']),
    ],
  ),

  QuizQuestion(
    numero: 14,
    question: 'Si tu devais expliquer ton futur métier à un(e) enfant de 8 ans, tu dirais…',
    detecte: 'définition spontanée du métier — confirmation profil santé',
    reponses: [
      QuizAnswer(letter: 'A', text: '"J\'aide les gens à se lever, se laver, manger — je prends soin d\'eux chaque jour"',
        profil: 'Aide-soignant(e)', tags: ['soins', 'quotidien', 'aide', 'gestes']),
      QuizAnswer(letter: 'B', text: '"Je m\'assure que les gens trouvent le bon médecin au bon moment"',
        profil: 'Secrétaire médicale', tags: ['orientation', 'organisation', 'rendez-vous', 'coordination']),
      QuizAnswer(letter: 'C', text: '"J\'aide les gens à manger ce qui les rend plus forts et en meilleure santé"',
        profil: 'Diététicien(ne)', tags: ['alimentation', 'sante', 'conseil', 'bien-etre']),
      QuizAnswer(letter: 'D', text: '"J\'aide les gens à mieux voir le monde"',
        profil: 'Opticien(ne) lunetier', tags: ['vision', 'aide', 'lunettes', 'clarte']),
    ],
  ),

  QuizQuestion(
    numero: 15,
    question: 'Ce qui te touche le plus dans une relation d\'aide…',
    detecte: 'source de satisfaction profonde — confirmation profil santé',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Être là physiquement, dans les gestes du quotidien, présent(e)',
        profil: 'Aide-soignant(e)', tags: ['presence', 'gestes', 'quotidien', 'physique']),
      QuizAnswer(letter: 'B', text: 'Bien organiser le parcours de quelqu\'un pour qu\'il/elle ne se perde pas dans le système',
        profil: 'Secrétaire médicale', tags: ['parcours', 'organisation', 'orientation', 'systeme']),
      QuizAnswer(letter: 'C', text: 'Lui montrer que changer son alimentation peut vraiment tout transformer',
        profil: 'Diététicien(ne)', tags: ['alimentation', 'transformation', 'conseil', 'impact']),
      QuizAnswer(letter: 'D', text: 'Le/la voir découvrir quelque chose qu\'il/elle ne voyait plus clairement',
        profil: 'Opticien(ne) lunetier', tags: ['decouverte', 'vision', 'clarte', 'satisfaction']),
    ],
  ),

  QuizQuestion(
    numero: 16,
    question: 'Ta peur profonde dans ce métier, c\'est de…',
    detecte: 'repoussoir professionnel — vision finale profil santé',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Ne pas réussir à soulager quelqu\'un qui souffre devant toi',
        profil: 'Aide-soignant(e) — Bac N4 (ASD — accessible sans diplôme)',
        tags: ['souffrance', 'soulagement', 'impuissance', 'present']),
      QuizAnswer(letter: 'B', text: 'Faire une erreur d\'organisation qui impacte la prise en charge d\'un(e) patient(e)',
        profil: 'Secrétaire médicale — Bac N4 (ASD — accessible sans diplôme)',
        tags: ['erreur', 'organisation', 'prise-en-charge', 'responsabilite']),
      QuizAnswer(letter: 'C', text: 'Proposer quelque chose d\'inadapté qui n\'aide pas — voire qui aggrave',
        profil: 'Diététicien(ne) — BTS Diététique N5 (Bac requis)',
        tags: ['inadapte', 'aggravation', 'conseil', 'responsabilite']),
      QuizAnswer(letter: 'D', text: 'Rater un détail précis et que quelqu\'un repart sans la bonne correction',
        profil: 'Opticien(ne) lunetier — BTS Opticien N5 (CAP/BEP/Bac)',
        tags: ['detail', 'precision', 'correction', 'erreur']),
    ],
  ),
];

// ── N3 ANIMAL ────────────────────────────────────────────────
// A = Auxiliaire vétérinaire — Soins (Bac N4)
// B = Chargé(e) de gestion en structure animalière (Bac N4)

const List<QuizQuestion> questionsNiveau3Animal = [

  QuizQuestion(
    numero: 13,
    question: 'La satisfaction ultime dans ce secteur pour toi…',
    detecte: 'satisfaction profonde — confirmation métier animal',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Un animal que tu as soigné(e) qui repart guéri, les yeux qui reprennent vie',
        profil: 'Auxiliaire vétérinaire — Soins cliniques', tags: ['guerison', 'soins', 'animal', 'direct']),
      QuizAnswer(letter: 'B', text: 'Une structure qui tourne parfaitement — client(e)s serein(e)s, animaux bien suivi(e)s',
        profil: 'Chargé(e) de gestion animalière', tags: ['structure', 'fluidite', 'satisfaction', 'organisation']),
    ],
  ),

  QuizQuestion(
    numero: 14,
    question: 'En stage, tu te retrouves à aider spontanément là où…',
    detecte: 'positionnement instinctif — confirmation animal',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Il y a un acte à poser — tenir, surveiller, soin à prodiguer',
        profil: 'Auxiliaire vétérinaire', tags: ['acte', 'surveillance', 'soin', 'technique']),
      QuizAnswer(letter: 'B', text: 'Il y a à coordonner — accueil, organisation, gestion des urgences',
        profil: 'Chargé(e) de gestion animalière', tags: ['coordination', 'accueil', 'organisation', 'urgences']),
    ],
  ),

  QuizQuestion(
    numero: 15,
    question: 'Si tu évoluais dans ce secteur, tu viserais…',
    detecte: 'ambition — vision à moyen terme animal',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Être la référence pour les gestes techniques — la confiance totale du vétérinaire',
        profil: 'Auxiliaire vétérinaire spécialisé(e)', tags: ['technique', 'reference', 'confiance', 'precision']),
      QuizAnswer(letter: 'B', text: 'Faire fonctionner une structure entière — équipe, client(e)s, animaux, tout roule',
        profil: 'Responsable de gestion animalière', tags: ['structure', 'management', 'equipe', 'organisation']),
    ],
  ),

  QuizQuestion(
    numero: 16,
    question: 'Ta peur principale dans ce secteur…',
    detecte: 'repoussoir professionnel — vision finale animal',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Rater un geste et mettre un animal en danger',
        profil: 'Auxiliaire vétérinaire — Soins (Bac N4)', tags: ['geste', 'danger', 'responsabilite', 'precision']),
      QuizAnswer(letter: 'B', text: 'Une clinique qui dysfonctionne — délais ratés, client(e)s mécontent(e)s, animaux perdus de vue',
        profil: 'Chargé(e) de gestion en structure animalière (Bac N4)', tags: ['dysfonctionnement', 'delais', 'satisfaction', 'suivi']),
    ],
  ),
];

// ── N3 JURIDIQUE ─────────────────────────────────────────────
// A = Assistant(e) juridique — Rédaction (BTS N5 — Bac requis)
// B = Collaborateur(trice) juriste / notarial(e) (BTS N5 — Bac requis)

const List<QuizQuestion> questionsNiveau3Juridique = [

  QuizQuestion(
    numero: 13,
    question: 'Ta journée de rêve dans un cabinet ressemble à…',
    detecte: 'quotidien idéal — confirmation métier juridique',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Tête dans les dossiers — analyser, rédiger, construire des arguments solides',
        profil: 'Assistant(e) Juridique', tags: ['dossiers', 'redaction', 'analyse', 'rigueur']),
      QuizAnswer(letter: 'B', text: 'Une journée de rendez-vous — écouter, conseiller, accompagner des gens différent(e)s',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['rendez-vous', 'conseil', 'accompagnement', 'relation']),
    ],
  ),

  QuizQuestion(
    numero: 14,
    question: 'Ce que les gens retiennent de ton travail…',
    detecte: 'identité professionnelle perçue — juridique',
    reponses: [
      QuizAnswer(letter: 'A', text: '"Ses dossiers sont béton — rien ne lui échappe jamais"',
        profil: 'Assistant(e) Juridique', tags: ['dossiers', 'rigueur', 'precision', 'fiabilite']),
      QuizAnswer(letter: 'B', text: '"Il/elle m\'a expliqué mes droits clairement — je suis reparti(e) rassuré(e)"',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['explication', 'droits', 'confiance', 'relation']),
    ],
  ),

  QuizQuestion(
    numero: 15,
    question: 'Ta satisfaction profonde dans ce métier…',
    detecte: 'moteur professionnel — confirmation juridique',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Avoir produit un document irréprochable qui protège vraiment quelqu\'un',
        profil: 'Assistant(e) Juridique', tags: ['document', 'protection', 'precision', 'irreprochable']),
      QuizAnswer(letter: 'B', text: 'Avoir fait comprendre une situation complexe à quelqu\'un qui était complètement perdu(e)',
        profil: 'Collaborateur(trice) Juriste / Notarial(e)', tags: ['comprehension', 'complexe', 'pedagogie', 'impact']),
    ],
  ),

  QuizQuestion(
    numero: 16,
    question: 'Ce qui te stresserait le plus dans ce métier…',
    detecte: 'repoussoir professionnel — vision finale juridique',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Laisser passer une erreur dans un texte officiel ou rater un délai critique',
        profil: 'Assistant(e) Juridique (BTS N5 — Bac requis)', tags: ['erreur', 'texte', 'delai', 'rigueur']),
      QuizAnswer(letter: 'B', text: 'Sentir qu\'un(e) client(e) repart sans avoir vraiment compris ou sans avoir confiance en toi',
        profil: 'Collaborateur(trice) Juriste / Notarial(e) (BTS N5 — Bac requis)', tags: ['confiance', 'incomprehension', 'client', 'relation']),
    ],
  ),
];

// ── N3 SERVICE ───────────────────────────────────────────────
// A = AEPE petite enfance (collectif ou domicile — CAP N3)
// B = AEPE animation périscolaire (CAP N3)

const List<QuizQuestion> questionsNiveau3Service = [

  QuizQuestion(
    numero: 13,
    question: 'L\'environnement de travail qui te correspond le mieux…',
    detecte: 'cadre de travail — confirmation service',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Un espace intime — peu d\'enfants, une relation profonde et continue avec chacun(e)',
        profil: 'AEPE — Petite enfance / Assistante maternelle', tags: ['intime', 'relation-profonde', 'petit-groupe', 'douceur']),
      QuizAnswer(letter: 'B', text: 'Un collectif organisé — beaucoup d\'enfants, des projets, de l\'énergie permanente',
        profil: 'AEPE — Animation périscolaire', tags: ['collectif', 'projets', 'energie', 'groupe']),
    ],
  ),

  QuizQuestion(
    numero: 14,
    question: 'La relation avec les familles dans ce travail…',
    detecte: 'type de lien famille — confirmation service',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Un lien quasi familial — on se fait entièrement confiance, on se parle de tout',
        profil: 'Assistante maternelle / Garde d\'enfant', tags: ['familial', 'confiance', 'lien-fort', 'intimite']),
      QuizAnswer(letter: 'B', text: 'Une relation professionnelle bien définie — tu représentes une structure, un cadre',
        profil: 'Animateur(trice) périscolaire / Accompagnant(e) éducatif(ve)', tags: ['professionnel', 'structure', 'institution', 'cadre']),
    ],
  ),

  QuizQuestion(
    numero: 15,
    question: 'Dans quelques années, ta fierté professionnelle c\'est…',
    detecte: 'vision à terme — confirmation métier service',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Une famille qui te confie ses enfants depuis que leur bébé avait quelques semaines',
        profil: 'Assistante maternelle / Garde d\'enfant / AEPE', tags: ['famille', 'confiance', 'continuite', 'bebe']),
      QuizAnswer(letter: 'B', text: 'Des enfants qui réclament tes ateliers et une énergie périscolaire que tu as construite',
        profil: 'Animateur(trice) périscolaire / Accompagnant(e) éducatif(ve)', tags: ['ateliers', 'ambiance', 'construction', 'periscolaire']),
    ],
  ),

  QuizQuestion(
    numero: 16,
    question: 'Ce qui te donnerait envie de recommencer chaque matin…',
    detecte: 'moteur quotidien — vision finale service',
    reponses: [
      QuizAnswer(letter: 'A', text: 'Le câlin d\'un tout-petit qui tend les bras dès que tu arrives',
        profil: 'AEPE — Petite enfance (CAP N3 — ASD ou sur recommandation)', tags: ['calin', 'tout-petit', 'lien', 'affectif']),
      QuizAnswer(letter: 'B', text: 'Un groupe qui s\'illumine quand tu annonces l\'activité du jour',
        profil: 'AEPE — Animation périscolaire (CAP N3 — ASD ou sur recommandation)', tags: ['groupe', 'activite', 'energie', 'animation']),
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

/// Retourne le jeu de questions N3 — un seul jeu par pôle
/// info/sante : ABCD (4 profils confirmés ensemble)
/// autres : AB
List<QuizQuestion> getQuestionsNiveau3(String pole, String metierGroup) {
  switch (pole) {
    case 'info':      return questionsNiveau3Info;
    case 'sante':     return questionsNiveau3Sante;
    case 'animal':    return questionsNiveau3Animal;
    case 'juridique': return questionsNiveau3Juridique;
    case 'service':   return questionsNiveau3Service;
    default:          return questionsNiveau3Info;
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

/// Calcule le groupe métier à partir des réponses N2
/// · ABCD pour info et sante — lettre dominante → nom de groupe
/// · AB   pour animal, juridique, service — majorité A ou B
String computeMetierGroup(List<AnswerRecord> answers, String pole) {
  final n2 = answers.where((a) => a.level == 2).toList();

  if (pole == 'info' || pole == 'sante') {
    final counts = <String, int>{'A': 0, 'B': 0, 'C': 0, 'D': 0};
    for (final a in n2) {
      counts[a.letter] = (counts[a.letter] ?? 0) + 1;
    }
    final dominant = counts.entries
        .reduce((x, y) => x.value >= y.value ? x : y)
        .key;

    if (pole == 'info') {
      switch (dominant) {
        case 'A': return 'infra_ops';
        case 'B': return 'infra_expert';
        case 'C': return 'dev';
        case 'D': return 'architecte';
        default:  return 'infra_ops';
      }
    } else {
      switch (dominant) {
        case 'A': return 'aide_soignant';
        case 'B': return 'secretaire';
        case 'C': return 'dieteticien';
        case 'D': return 'opticien';
        default:  return 'aide_soignant';
      }
    }
  }

  // Pôles AB
  final n2A = n2.where((a) => a.letter == 'A').length;
  final n2B = n2.where((a) => a.letter == 'B').length;
  final goA = n2A >= n2B;
  switch (pole) {
    case 'animal':    return goA ? 'clinique' : 'gestion';
    case 'juridique': return goA ? 'redaction' : 'conseil';
    case 'service':   return goA ? 'enfance' : 'animation';
    default:          return 'terrain';
  }
}

/// Calcule la spécialisation finale à partir des réponses N3 seules.
/// Utilisé uniquement pour info et sante (ABCD en N3).
/// Pour les autres pôles, computeMetierGroup (N2) suffit déjà.
/// Préférer computeFinalProfil pour la page résultats.
String computeSpecialisation(List<AnswerRecord> answers, String pole) {
  if (pole != 'info' && pole != 'sante') return '';
  final n3 = answers.where((a) => a.level == 3).toList();
  final counts = <String, int>{'A': 0, 'B': 0, 'C': 0, 'D': 0};
  for (final a in n3) {
    counts[a.letter] = (counts[a.letter] ?? 0) + 1;
  }
  final dominant = counts.entries
      .reduce((x, y) => x.value >= y.value ? x : y)
      .key;
  return _letterToGroupe(dominant, pole);
}

/// ⭐ Calcule le profil final en combinant les votes N2 + N3 (8 réponses).
///
/// Résout les contradictions entre N2 et N3 :
/// · ABCD (info / sante) : toutes les réponses N2+N3 sont comptées.
///   En cas d'égalité, N3 a le dernier mot (pondération +1 sur N3).
/// · AB (animal / juridique / service) : majorité simple sur N2+N3.
///   En cas d'égalité, N3 tranche.
///
/// C'est cette fonction qui doit alimenter la page résultats.
String computeFinalProfil(List<AnswerRecord> answers, String pole) {
  final n2n3 = answers.where((a) => a.level == 2 || a.level == 3).toList();

  if (pole == 'info' || pole == 'sante') {
    final counts = <String, int>{'A': 0, 'B': 0, 'C': 0, 'D': 0};
    for (final a in n2n3) {
      counts[a.letter] = (counts[a.letter] ?? 0) + 1;
    }
    // Pondération N3 : +1 sur chaque réponse N3 pour trancher les égalités
    for (final a in answers.where((a) => a.level == 3)) {
      counts[a.letter] = (counts[a.letter] ?? 0) + 1;
    }
    final dominant = counts.entries
        .reduce((x, y) => x.value >= y.value ? x : y)
        .key;
    return _letterToGroupe(dominant, pole);
  }

  // Pôles AB : majorité simple N2 + N3
  final countA = n2n3.where((a) => a.letter == 'A').length;
  final countB = n2n3.where((a) => a.letter == 'B').length;
  final bool goA;
  if (countA == countB) {
    // Égalité : N3 tranche
    final n3A = answers.where((a) => a.level == 3 && a.letter == 'A').length;
    final n3B = answers.where((a) => a.level == 3 && a.letter == 'B').length;
    goA = n3A >= n3B;
  } else {
    goA = countA > countB;
  }
  switch (pole) {
    case 'animal':    return goA ? 'clinique'  : 'gestion';
    case 'juridique': return goA ? 'redaction' : 'conseil';
    case 'service':   return goA ? 'enfance'   : 'animation';
    default:          return 'clinique';
  }
}

/// Convertit une lettre dominante en nom de groupe selon le pôle.
/// Usage interne — appelé par computeSpecialisation et computeFinalProfil.
String _letterToGroupe(String letter, String pole) {
  if (pole == 'info') {
    switch (letter) {
      case 'A': return 'infra_ops';
      case 'B': return 'infra_expert';
      case 'C': return 'dev';
      case 'D': return 'architecte';
      default:  return 'infra_ops';
    }
  } else {
    switch (letter) {
      case 'A': return 'aide_soignant';
      case 'B': return 'secretaire';
      case 'C': return 'dieteticien';
      case 'D': return 'opticien';
      default:  return 'aide_soignant';
    }
  }
}