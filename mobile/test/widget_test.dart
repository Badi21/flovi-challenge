import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flovi_driver/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen shows title, subtitle and Google button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Flovi Driver'), findsOneWidget);
    expect(find.text('Find and book vehicle relocations'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
