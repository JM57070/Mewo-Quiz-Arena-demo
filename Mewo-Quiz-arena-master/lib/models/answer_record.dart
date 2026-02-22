
class AnswerRecord {
  final int level;            // 1, 2, 3
  final int questionNumero;   // question.numero
  final String letter;        // 'A' | 'B' | 'C' | 'D'
  final String profil;        // 'Informatique', 'Juridique', 'Service', 'Santé'

  const AnswerRecord({
    required this.level,
    required this.questionNumero,
    required this.letter,
    required this.profil,
  });
}
