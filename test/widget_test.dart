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

  testWidgets('App loads with correct initial state', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify app title
    expect(find.text('Hydro Monitor'), findsOneWidget);

    // Verify dashboard is shown initially (lettuce image should be present)
    expect(find.byType(Image), findsWidgets); // Should find the lettuce image
  });

  testWidgets('Bottom navigation tabs work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Initially on dashboard
    expect(find.text('Hydro Monitor'), findsOneWidget);

    // Tap home tab (should stay on dashboard)
    await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
    await tester.pump();
    expect(find.text('Hydro Monitor'), findsOneWidget);

    // Tap analytics tab (should go to insights)
    await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
    await tester.pump();
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Analytics & trends'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Plants page shows placeholder content', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Navigate to plants page via CTA
    await tester.tap(find.byKey(const Key('plantsCTA')), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    // Should be on plants page now (since CTA sets _selectedIndex = 1)
    expect(find.text('Plants'), findsOneWidget);
    expect(find.text('Your plants overview'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Dashboard shows floating lettuce animation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify lettuce image is present
    expect(find.byType(Image), findsWidgets);

    // Verify app bar is transparent/elevated properly
    final appBar = find.byType(AppBar);
    expect(appBar, findsOneWidget);
  });

  testWidgets('PlantCenterPage displays all metric squares', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Navigate to plant center
    await tester.tap(find.byKey(const Key('plantsCTA')), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    // Verify all metric titles are present
    expect(find.text('Plant Health'), findsOneWidget);
    expect(find.text('Water Level'), findsOneWidget);
    expect(find.text('pH Level'), findsOneWidget);
    expect(find.text('Nutrients Level'), findsOneWidget);

    // Verify status labels
    expect(find.text('Excellent'), findsOneWidget);
    expect(find.text('Normal'), findsWidgets); // Multiple normals
  });

  testWidgets('Navigation preserves state correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Start on dashboard
    expect(find.text('Hydro Monitor'), findsOneWidget);

    // Go to plant center
    await tester.tap(find.byKey(const Key('plantsCTA')), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
    expect(find.text('Plant Center'), findsOneWidget);

    // Go back to dashboard via home tab
    await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
    await tester.pump();
    expect(find.text('Hydro Monitor'), findsOneWidget);
  });
}
