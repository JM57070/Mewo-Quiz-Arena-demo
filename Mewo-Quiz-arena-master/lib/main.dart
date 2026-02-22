
//MEWO Quiz Arena architecture simplifiéee pour coller au theme
// Flow : Screen1Welcome → ScreenQuiz → ScreenResults


import 'package:flutter/material.dart';
import 'screens/screen1_welcome.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MewoQuizApp());
}

class MewoQuizApp extends StatelessWidget {
  const MewoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEWO Quiz Arena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
      home: const Screen1Welcome(),
    );
  }
}