// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:mewo_quiz_arena/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MewoQuizApp());
    expect(find.text('QUIZ ARENA'), findsOneWidget);
  });
}