// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';

void main() {
  testWidgets('FAB navigates to Plants and bottom app bar switches tabs', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Starts on Home (Dashboard) - check a unique body label
    expect(find.text('Hydro Monitor'), findsOneWidget);

    // Tap the floating Plants button
    await tester.tap(find.byIcon(Icons.eco));
    await tester.pumpAndSettle();
    expect(find.text('Your plants overview'), findsOneWidget);

    // Tap Insights icon in bottom app bar
    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();
    expect(find.text('Analytics & trends'), findsOneWidget);

    // Tap Home icon in bottom app bar
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Hydro Monitor'), findsOneWidget);
  });
}