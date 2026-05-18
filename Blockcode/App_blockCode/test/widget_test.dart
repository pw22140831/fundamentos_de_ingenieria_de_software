

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blockcode/main.dart';

void main() {
  testWidgets('Login screen renders smoke test', (WidgetTester tester) async {
    
    await tester.pumpWidget(const MyApp());

    
    expect(find.text('blockcode'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
