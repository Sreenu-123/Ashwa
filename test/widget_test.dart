import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ashwa_app/main.dart';

void main() {
  testWidgets('ASHWA app loads successfully', (WidgetTester tester) async {
    // Build the ASHWA app and trigger a frame.
    await tester.pumpWidget(const AshwaApp(initialThemeMode: ThemeMode.light));

    // Verify that the ASHWA app is loaded.
    expect(find.byType(AshwaApp), findsOneWidget);
  });
}
