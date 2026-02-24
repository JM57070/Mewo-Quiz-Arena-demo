
class AnswerRecord {
  final int level;            // 1, 2, 3
  final int questionNumero;   // question.numero
  final String letter;        // 'A' | 'B' | 'C' | 'D'
  final String profil;        // 'Informatique', 'Juridique', 'Service', 'Santé'
  final String? pole;        // 'Pole1', 'Pole2', 'Pole3', 'Pole4'

  const AnswerRecord({
    required this.level,
    required this.questionNumero,
    required this.letter,
    required this.profil,
    this.pole,
  });
}
