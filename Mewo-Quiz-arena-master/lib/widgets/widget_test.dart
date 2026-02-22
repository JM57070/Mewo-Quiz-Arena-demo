// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:mewo_quiz_arena/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MewoQuizApp());
    expect(find.text('QUIZ ARENA'), findsOneWidget);
  });
}