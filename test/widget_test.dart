import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Use the package import that matches how your project imports main.
// This matches logs you shared earlier.
import 'package:water_dashboard/main.dart';
import 'package:water_dashboard/pages/plant_center_page.dart';

// If your project uses a different package name or structure, uncomment & adjust:
// import 'package:your_project_name/main.dart';
// import 'package:your_project_name/pages/plant_center_page.dart';

void main() {
  testWidgets('CTA navigates to PlantCenterPage and shows expected content',
          (WidgetTester tester) async {
        // Build the app
        await tester.pumpWidget(const MyApp());

        // Give the app a frame to build initial widgets
        await tester.pump();

        // Tap the center CTA button (uses the key you added in the app code)
        // warnIfMissed: false avoids a test failure if the widget is not hit-testable
        await tester.tap(find.byKey(const Key('plantsCTA')), warnIfMissed: false);

        // Wait a bit for the navigation animation to complete (using fixed pump avoids pumpAndSettle hang)
        await tester.pump(const Duration(milliseconds: 800));
        await tester.pump(const Duration(milliseconds: 200)); // extra frame to ensure build

        // Verify that the PlantCenterPage was pushed
        expect(find.byType(PlantCenterPage), findsOneWidget);

        // Verify the AppBar title (you added this key in PlantCenterPage)
        expect(find.byKey(const Key('plantCenterTitle')), findsOneWidget);

        // Verify at least one info square is present (text that actually exists in PlantCenterPage)
        expect(find.text('Plant Health'), findsOneWidget);
      });
}
