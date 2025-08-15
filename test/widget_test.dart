// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';

void main() {
  testWidgets('Dashboard renders key sections and toggles details', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hydro Monitor'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Results'), findsOneWidget);

    // Initial selected should be Water
    expect(find.text('Water level'), findsOneWidget);
    expect(find.text('72%'), findsOneWidget);

    // Tap Nutrients
    await tester.tap(find.text('Nutrients'));
    await tester.pumpAndSettle();
    expect(find.text('Nutrients level'), findsOneWidget);
    expect(find.text('480 ppm'), findsOneWidget);

    // Tap pH
    await tester.tap(find.text('pH'));
    await tester.pumpAndSettle();
    expect(find.text('pH level'), findsOneWidget);
    expect(find.text('6.5'), findsOneWidget);
  });
}
