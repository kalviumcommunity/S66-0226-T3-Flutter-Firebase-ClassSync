import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:classsync/main.dart';

void main() {
  testWidgets('HomeScreen shows all 4 demo cards', (WidgetTester tester) async {
    await tester.pumpWidget(const ClassSyncApp());

    expect(find.text('Flutter Architecture'), findsOneWidget);
    expect(find.text('Hello Flutter'), findsOneWidget);
    expect(find.text('Counter App'), findsOneWidget);
    expect(find.text('Dart Basics'), findsOneWidget);
  });

  testWidgets('Counter starts at 0 and increments', (WidgetTester tester) async {
    await tester.pumpWidget(const ClassSyncApp());

    await tester.tap(find.text('Counter App'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}
