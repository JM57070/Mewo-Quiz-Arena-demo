# 🎮 MEWO Quiz Arena — Guide Débutant Flutter

> Réalisé dans le cadre d'un stage BTS SIO SLAM 1ère année

---

## 📁 Structure du projet

```
mewo_quiz/
├── pubspec.yaml                  ← Configuration + dépendances
└── lib/
    ├── main.dart                 ← Point d'entrée de l'app
    ├── models/
    │   └── player_data.dart      ← Données du joueur (nom, prénom, etc.)
    ├── widgets/
    │   ├── animated_background.dart  ← Arrière-plan animé (nuages, herbe)
    │   └── mewo_widgets.dart         ← Logo, boutons réutilisables
    └── screens/
        ├── screen1_welcome.dart      ← Écran 1 : Accueil
        ├── screen2_presentation.dart ← Écrans 2-5 : Présentation (réutilisé x4)
        ├── screen6_character.dart    ← Écran 6 : Choix personnage
        ├── screen7_info.dart         ← Écran 7 : Formulaire joueur
        └── screen8_universe.dart     ← Écran 8 : Choix de filière
```

---

## 🚀 Installation — Étape par étape

### 1. Installe Flutter
Télécharge Flutter sur : https://docs.flutter.dev/get-started/install

### 2. Crée le projet
```bash
flutter create mewo_quiz
cd mewo_quiz
```

### 3. Remplace les fichiers
Copie tous les fichiers `.dart` fournis dans les bons dossiers :
- `lib/main.dart` → remplace le fichier existant
- Crée les dossiers `lib/models/`, `lib/widgets/`, `lib/screens/`
- Colle chaque fichier `.dart` dedans

### 4. Crée le dossier assets
```
mewo_quiz/
└── assets/
    ├── images/
    │   ├── logo_mewo.png        ← Ton logo MEWO
    │   ├── bg_campus.png        ← Image de fond campus
    │   ├── perso_directeur.png  ← Personnage directeur (écrans 2-5)
    │   ├── perso_garcon.png     ← Personnage garçon (face)
    │   ├── perso_fille.png      ← Personnage fille (face)
    │   ├── perso_garcon_dos.png ← Personnage garçon (de dos, écran 8)
    │   └── perso_fille_dos.png  ← Personnage fille (de dos, écran 8)
    └── fonts/
        ├── Poppins-Regular.ttf  ← Télécharge sur Google Fonts
        ├── Poppins-Bold.ttf
        └── Poppins-Black.ttf
```

> **💡 Astuce :** Pour tester sans les vraies images, le code affiche des 
> formes colorées de remplacement automatiquement. Tu peux ajouter les 
> images plus tard !

### 5. Installe les dépendances
```bash
flutter pub get
```

### 6. Lance l'app
```bash
flutter run
```

---

## 🔗 Navigation entre les écrans

```
Écran 1 (Welcome)
    ↓ bouton BIENVENUE
Écran 2 (Présentation 1)  ← pageIndex: 0
    ↓ bouton Suivant
Écran 3 (Présentation 2)  ← pageIndex: 1
    ↓ bouton Suivant
Écran 4 (Explication 1)   ← pageIndex: 2
    ↓ bouton Suivant
Écran 5 (C'est parti !)   ← pageIndex: 3
    ↓ bouton Suivant
Écran 6 (Choix personnage)
    ↓ bouton Garçon ou Fille
Écran 7 (Formulaire)
    ↓ bouton VALIDER
Écran 8 (Choix filière)
    ↓ clic sur une porte
→ Quiz (à développer après)
```

---

## 📦 Données collectées (PlayerData)

Toutes les infos du joueur sont stockées dans `PlayerData` :

| Champ          | Renseigné à l'écran |
|----------------|---------------------|
| personnage     | Écran 6             |
| nom            | Écran 7             |
| prenom         | Écran 7             |
| dateNaissance  | Écran 7             |
| filiere        | Écran 8             |

Pour sauvegarder les données (base de données, Firebase, CSV...) :
```dart
// Dans screen8_universe.dart, remplace la boîte de dialogue par :
final map = player.toMap();
// Envoie map vers Firebase, SQLite, un fichier CSV, etc.
```

---

## 🎨 Comment personnaliser

### Changer les textes des écrans 2-5
Dans `screen2_presentation.dart`, modifie la liste `_pages` :
```dart
const List<Map<String, String>> _pages = [
  { 'subtitle': 'Présentation', 'text': 'Ton texte ici...' },
  // ...
];
```

### Changer les couleurs des portes (écran 8)
Dans `screen8_universe.dart`, modifie `_univers` :
```dart
const List<Map<String, dynamic>> _univers = [
  {'nom': 'MEWO\nANIMAL', 'couleur': Color(0xFFE91E63), 'icone': '🐾'},
  // ...
];
```

---

## 🧩 Utilisation de Flame (pour le quiz plus tard)

Flame sera utilisé pour :
- Effets d'animation lors d'une bonne/mauvaise réponse
- Personnage qui réagit (saute, tombe, etc.)
- Compteur de score animé
- Effets de particules (confettis, étoiles)

Pour créer un composant Flame :
```dart
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class QuizGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Charge tes sprites, sons, etc.
  }
}
```

---

## ❓ FAQ Débutant

**Q : Mon app plante sur `Image.asset()` ?**
→ C'est normal si les images ne sont pas encore dans `assets/`. Le code
affiche automatiquement une version de secours colorée.

**Q : Comment tester sur téléphone ?**
→ Active le mode développeur sur Android, connecte en USB, puis :
```bash
flutter run
```

**Q : Comment exporter en APK ?**
```bash
flutter build apk --release
```
Le fichier est dans `build/app/outputs/flutter-apk/app-release.apk`

**Q : Où sauvegarder les données des joueurs pour les analyser ?**
→ Ajoute le package `csv` ou `firebase_core` dans `pubspec.yaml` et
utilise `player.toMap()` pour exporter.

---

## 📚 Ressources utiles

- Documentation Flutter : https://docs.flutter.dev
- Documentation Flame : https://docs.flame-engine.org
- Google Fonts (Poppins) : https://fonts.google.com/specimen/Poppins
- Flutter Pub (packages) : https://pub.dev

---

*Bon courage pour ton stage ! 🎓*
