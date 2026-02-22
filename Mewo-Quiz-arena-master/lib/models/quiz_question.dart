// Base de données des 3 niveaux de quiz
// NIVEAU 1 : Découverte générale (5 questions)
// NIVEAU 2 : "Le Silence" - Cyberattaque (5 questions) 
// NIVEAU 3 : "Phase Finale" - Intrusion Profonde (5 questions)


class QuizQuestion {
  final int numero;
  final String question;
  final String? synopsis; 
  final List<QuizAnswer> reponses;
  final String detecte;

  const QuizQuestion({
    required this.numero,
    required this.question,
    this.synopsis, //     Optionnel pour niveau 1
    required this.reponses,
    required this.detecte,
  });
}

class QuizAnswer {
  final String letter;
  final String text;
  final String profil;
  final List<String> tags; // Pour le scoring final

  const QuizAnswer({
    required this.letter,
    required this.text,
    required this.profil,
    required this.tags,
  });
}


// NIVEAU 1 : Découverte générale (pas de synopsis)


const List<QuizQuestion> questionsNiveau1 = [
  QuizQuestion(
    numero: 1,
    question: 'Tu te réveilles pour une mission spéciale. Quel est ton premier réflexe ?',
    detecte: 'organisation, rigueur, mode d\'apprentissage.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Vérifier ton équipement, tout doit être prêt.',
        profil: 'profil technique → informatique / santé',
        tags: ['technique', 'organisation', 'informatique', 'sante'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Observer ton environnement et t\'assurer que tout le monde va bien.',
        profil: 'profil empathique → santé / service',
        tags: ['empathique', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Noter les objectifs de ta journée dans ton carnet.',
        profil: 'profil rigoureux → juridique',
        tags: ['rigoureux', 'organisation', 'juridique'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Sortir directement, tu préfères apprendre en faisant.',
        profil: 'profil manuel → animalier / service',
        tags: ['manuel', 'pratique', 'animal', 'service'],
      ),
    ],
  ),
  
  QuizQuestion(
    numero: 2,
    question: 'Dans une équipe de jeu, tu préfères incarner…',
    detecte: 'rôle préféré, compétences naturelles.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Le stratège qui analyse et prend des décisions.',
        profil: 'profil analytique → informatique / juridique',
        tags: ['analytique', 'strategie', 'informatique', 'juridique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Le soigneur qui s\'occupe des autres.',
        profil: 'profil empathique → santé',
        tags: ['empathique', 'soin', 'sante'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Le dresseur/éleveur qui s\'occupe des créatures.',
        profil: 'profil animalier → animal',
        tags: ['animal', 'soin', 'patience'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Le multitâche qui aide partout selon les besoins.',
        profil: 'profil polyvalent → service',
        tags: ['polyvalent', 'service', 'adaptabilite'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 3,
    question: 'Tu dois résoudre un problème en 10 secondes. Comment t\'y prends-tu ?',
    detecte: 'méthode de résolution, gestion du stress.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je respire, je réfléchis étape par étape.',
        profil: 'profil méthodique → informatique / juridique',
        tags: ['methodique', 'reflexion', 'informatique', 'juridique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je fonce et je teste directement.',
        profil: 'profil action → service / animal',
        tags: ['action', 'pratique', 'service', 'animal'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'J\'écoute les indices autour de moi avant d\'agir.',
        profil: 'profil observateur → santé / service',
        tags: ['observation', 'empathie', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Je cherche un modèle ou une règle pour répondre vite.',
        profil: 'profil structuré → juridique',
        tags: ['structure', 'regles', 'juridique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 4,
    question: 'Si ton lieu idéal existait dans un jeu, il ressemblerait à…',
    detecte: 'environnement préféré, centres d\'intérêt.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Un laboratoire high-tech rempli d\'écrans.',
        profil: 'profil technologique → informatique',
        tags: ['technologie', 'informatique', 'innovation'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Une forêt vivante pleine d\'animaux.',
        profil: 'profil nature → animal',
        tags: ['nature', 'animal', 'biodiversite'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Une grande salle d\'étude calme et ordonnée.',
        profil: 'profil studieux → juridique',
        tags: ['etude', 'calme', 'juridique', 'organisation'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Une base où l\'on soigne les alliés blessés.',
        profil: 'profil soignant → santé',
        tags: ['soin', 'aide', 'sante', 'empathie'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 5,
    question: 'Choisis la mission qui te motive le plus.',
    detecte: 'motivation profonde, projet de carrière.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Régler un problème technique complexe.',
        profil: 'profil technique → informatique',
        tags: ['technique', 'resolution', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Apporter du soutien ou du réconfort à quelqu\'un.',
        profil: 'profil empathique → santé / service',
        tags: ['empathie', 'soutien', 'sante', 'service'],
      ),
      QuizAnswer(
        letter: 'C',
        text: 'Comprendre et appliquer des règles précises.',
        profil: 'profil juridique → juridique',
        tags: ['regles', 'precision', 'juridique'],
      ),
      QuizAnswer(
        letter: 'D',
        text: 'Prendre soin d\'êtres vivants.',
        profil: 'profil animalier → animal / santé',
        tags: ['soin', 'vivant', 'animal', 'sante'],
      ),
    ],
  ),
];


// NIVEAU 2 : "Le Silence" - Cyberattaque en entreprise


const List<QuizQuestion> questionsNiveau2 = [
  QuizQuestion(
    numero: 1,
    synopsis: '''8h17. L'entreprise se réveille. Les employés arrivent peu à peu.

Mais un silence étrange règne : aucune machine ne s'allume.

Des regards confus. Des respirations retenues. Puis, sans prévenir, toutes les lumières clignotent.

Sur chaque écran : "ACCÈS REFUSÉ – FICHIER CORROMPU"

Personne ne bouge.''',
    question: 'La première minute : Vous êtes parmi les premiers à réagir.',
    detecte: 'approche face à une crise, réflexe professionnel.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je vais voir un poste en panne. J\'essaie de comprendre ce qui ne fonctionne plus.',
        profil: 'Technique & Opérationnel',
        tags: ['technique', 'operationnel', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je prends quelques secondes, j\'analyse la salle, les réactions, la situation globale avant d\'agir.',
        profil: 'Conception & Stratégie',
        tags: ['strategie', 'analyse', 'conception', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 2,
    synopsis: '''Alors que vous vérifiez un poste ou observez la salle, un nouvel élément frappe : des fichiers ouvrent puis se ferment tout seuls, comme manipulés à distance.

Soudain, un cri à l'étage supérieur. En montant, vous découvrez une collaboratrice en larmes : son dossier médical personnel est affiché sur l'écran d'un collègue.

Un transfert involontaire ? Ou quelqu'un joue avec les permissions internes ?''',
    question: 'Les Premiers Dérèglements : Votre réaction ?',
    detecte: 'gestion de la confidentialité, priorités.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je me dirige vers elle, je sécurise son poste et j\'analyse ce qui s\'y passe.',
        profil: 'Technique & Opérationnel',
        tags: ['technique', 'operationnel', 'securite', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je cherche immédiatement la logique : "Quel type de compromission permet ça ? Qui peut manipuler les droits utilisateurs ?"',
        profil: 'Conception & Stratégie',
        tags: ['strategie', 'analyse', 'securite', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 3,
    synopsis: '''En revenant vers le service IT, vous entendez une dispute. Un cadre pointe du doigt un technicien :

"C'est TOI qui as planté le serveur ! Tu es le seul qui y touche !"

Le technicien nie, paniqué. Le cadre insiste.

Mais quelque chose cloche… Les événements semblent trop coordonnés pour être une simple erreur humaine.''',
    question: 'Les Accusations : Comment gérez-vous la situation ?',
    detecte: 'gestion de conflit, méthode d\'investigation.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je vérifie immédiatement son poste et le serveur associé. Les machines diront la vérité.',
        profil: 'Technique & Opérationnel',
        tags: ['technique', 'verification', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je prends du recul : une accusation aussi rapide est suspecte. Je veux comprendre qui avait accès à quoi, et pourquoi au bon moment.',
        profil: 'Conception & Stratégie',
        tags: ['strategie', 'analyse', 'management', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 4,
    synopsis: '''D'un coup, tout bascule.

• Le wifi disparaît
• La téléphonie interne s'éteint
• Les boîtes mail deviennent inaccessibles

Des gens crient dans les open spaces : "ON EST COUPÉS DU MONDE !"

Une coupure totale… Comme si quelqu'un voulait isoler l'entreprise avant de frapper plus fort.''',
    question: 'L\'Enfermement Numérique : Où concentrez-vous votre action ?',
    detecte: 'priorisation en urgence, expertise réseau.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je me dirige vers les équipements réseau : switch, routeurs, câbles. Quelque chose a été coupé physiquement ou via une attaque locale.',
        profil: 'Technique & Opérationnel',
        tags: ['technique', 'reseau', 'infrastructure', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je me plonge dans ce qu\'il reste des journaux systèmes : quel service est tombé le premier ? Quelle séquence d\'arrêt ? Cela pourrait révéler l\'intention de l\'attaquant.',
        profil: 'Conception & Stratégie',
        tags: ['analyse', 'strategie', 'investigation', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 5,
    synopsis: '''Dans la salle serveur, une mystérieuse clé USB apparaît sur une table, comme déposée volontairement.

Personne ne l'a vue arriver.

Dessus : un seul fichier "JUSTICE.EXE"

Quand on tente de le supprimer, il réapparaît instantanément. Comme si quelqu'un voulait que vous le voyiez.

Est-ce un leurre ? Une menace ? Un message personnel ?''',
    question: 'Le Fichier Fantôme : Votre décision ?',
    detecte: 'gestion des menaces, esprit critique.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je l\'isole immédiatement : déconnexion physique, analyse hors réseau, neutralisation des processus liés.',
        profil: 'Technique & Opérationnel',
        tags: ['technique', 'securite', 'operationnel', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je veux comprendre la symbolique : "JUSTICE". Ça ressemble à une revendication. Qui ici aurait un sentiment d\'injustice assez fort pour attaquer l\'entreprise ?',
        profil: 'Conception & Stratégie',
        tags: ['analyse', 'strategie', 'psychologie', 'investigation'],
      ),
    ],
  ),
];


// NIVEAU 3 : "Phase Finale" - L'Intrusion Profonde


const String synopsisNiveau3Global = '''Tu as réussi à isoler JUSTICE.EXE… mais l'attaque n'est pas terminée.

En creusant davantage, tu découvres que plusieurs anomalies continuent d'apparaître un peu partout dans le système. Comme si l'attaquant avait laissé derrière lui une série de pièges, de scripts et de comportements inattendus.

Chaque nouvelle anomalie semble liée à la précédente. Un fil rouge, une suite logique, un plan bien plus complexe que ce que tu imaginais au départ.

Les équipes sont débordées. Les alarmes se multiplient. Tu es l'une des seules personnes encore en mesure d'agir.

Cinq incidents viennent d'être signalés simultanément. Si tu veux remonter à la source du problème et stopper définitivement cette attaque, tu vas devoir décider comment réagir à chacun d'eux.

Ta progression dépend maintenant des choix que tu vas faire.

JUSTICE.EXE n'était que le premier acte.''';

const List<QuizQuestion> questionsNiveau3 = [
  QuizQuestion(
    numero: 1,
    synopsis: '''Alors que tu analyses le poste isolé, un nouveau processus apparaît dès que JUSTICE.EXE est stoppé. Il porte un nom générique, comme s'il tentait de se cacher.''',
    question: 'Le Processus Fantôme (activation automatique) : Que fais-tu ?',
    detecte: 'réactivité technique, méthodologie.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je désactive les services concernés et supprime les tâches automatiques liées.',
        profil: 'Support & Exploitation Technique',
        tags: ['support', 'exploitation', 'technique', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'J\'analyse la chaîne de processus pour comprendre comment il se relance.',
        profil: 'Analyse & Sécurité Technique',
        tags: ['analyse', 'securite', 'expert', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 2,
    synopsis: '''Une autre machine du réseau commence à afficher les mêmes symptômes, alors qu'elle n'a jamais été en contact avec la clé USB. La propagation semble interne.''',
    question: 'La Machine Miroir (réplication silencieuse) : Comment réagis-tu ?',
    detecte: 'compréhension de la propagation, isolation.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'J\'isole immédiatement la deuxième machine et vérifie si un partage réseau est en cause.',
        profil: 'Support & Exploitation Technique',
        tags: ['support', 'infrastructure', 'reseau', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je compare le comportement des deux machines pour voir si l\'attaque utilise une réplication furtive.',
        profil: 'Analyse & Sécurité Technique',
        tags: ['analyse', 'securite', 'expert', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 3,
    synopsis: '''Sur le poste analysé, l'activité disque explose soudainement : Écriture constante, suppression, réécriture… comme si l'attaque préparait quelque chose.''',
    question: 'Le Disque Rouge (activité anormale) : Quelle approche choisis-tu ?',
    detecte: 'stabilisation système, anticipation.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'J\'arrête les services suspects et stabilise la machine pour éviter la corruption.',
        profil: 'Support & Exploitation Technique',
        tags: ['support', 'technique', 'stabilisation', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je surveille les fichiers créés pour identifier ce que le script tente de générer.',
        profil: 'Analyse & Sécurité Technique',
        tags: ['analyse', 'securite', 'investigation', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 4,
    synopsis: '''Un compte utilisateur inconnu apparaît dans les sessions actives du serveur. Nom étrange, aucun historique clair, mais il possède des permissions élevées.''',
    question: 'L\'Alias Inconnu (compte caché) : Ta décision ?',
    detecte: 'gestion des accès, forensic.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je désactive ce compte, force sa déconnexion et sécurise les accès sensibles.',
        profil: 'Support & Exploitation Technique',
        tags: ['support', 'securite', 'infrastructure', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'J\'étudie l\'origine du compte pour comprendre comment il a été créé et utilisé.',
        profil: 'Analyse & Sécurité Technique',
        tags: ['analyse', 'securite', 'expert', 'forensic', 'informatique'],
      ),
    ],
  ),

  QuizQuestion(
    numero: 5,
    synopsis: '''Au fond d'un répertoire système caché, tu trouves un script plus ancien que JUSTICE.EXE. Il contient une date… celle d'un ancien incident jamais résolu.''',
    question: 'Le Déclencheur Final (script maître trouvé) : Dernière action, que fais-tu ?',
    detecte: 'approche finale, orientation carrière.',
    reponses: [
      QuizAnswer(
        letter: 'A',
        text: 'Je supprime le script, rétablis les accès légitimes et relance les services propres.',
        profil: 'Support & Exploitation Technique',
        tags: ['support', 'exploitation', 'infrastructure', 'informatique'],
      ),
      QuizAnswer(
        letter: 'B',
        text: 'Je documente la méthode utilisée, identifie la faille initiale et propose une contremesure durable.',
        profil: 'Analyse & Sécurité Technique',
        tags: ['analyse', 'securite', 'expert', 'documentation', 'prevention', 'informatique'],
      ),
    ],
  ),
];