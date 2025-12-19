import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/pages/plant_center_page.dart';

void main() {
  group('PlantCenterPage Integration Tests', () {
    testWidgets('PlantCenterPage builds with all info squares', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Should have 4 info squares
      expect(find.text('Plant Health'), findsOneWidget);
      expect(find.text('Water Level'), findsOneWidget);
      expect(find.text('pH Level'), findsOneWidget);
      expect(find.text('Nutrients Level'), findsOneWidget);

      // Should have progress bars
      expect(find.byType(ClipRRect), findsWidgets); // Mini progress bars
    });

    testWidgets('Info squares display correct values and colors', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Check specific values
      expect(find.text('86%'), findsOneWidget);
      expect(find.text('72%'), findsOneWidget);
      expect(find.text('46%'), findsOneWidget); // This will fail - should be 6.5 for pH
      expect(find.text('48%'), findsOneWidget);

      // Check status labels
      expect(find.text('Excellent'), findsOneWidget);
      expect(find.text('Normal'), findsWidgets); // Should find multiple
    });

    testWidgets('GlossyDivider renders with animations', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Should have CustomPaint for divider (may have multiple)
      expect(find.byType(CustomPaint), findsWidgets);

      // Pump animation frames
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should still be rendering
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Layout adapts to different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: const PlantCenterPage(),
          ),
        ),
      );

      // Should still render all components
      expect(find.text('Plant Health'), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget); // Responsive layout
    });

    testWidgets('Info squares have correct gradient backgrounds', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Should have containers with gradients
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Should have info squares (4 of them)
      expect(find.text('Plant Health'), findsOneWidget);
      expect(find.text('Water Level'), findsOneWidget);
      expect(find.text('pH Level'), findsOneWidget);
      expect(find.text('Nutrients Level'), findsOneWidget);
    });

    testWidgets('Progress bars show correct fill amounts', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Progress bars should be visible
      expect(find.byType(ClipRRect), findsWidgets);

      // This will fail - trying to find specific progress values
      final progressBars = find.byType(FractionallySizedBox);
      expect(progressBars, findsWidgets);

      // Check that progress bars have correct width factors
      for (final progressBar in progressBars.evaluate()) {
        final widget = progressBar.widget as FractionallySizedBox;
        expect(widget.widthFactor, isNotNull);
        expect(widget.widthFactor, greaterThan(0.0));
        expect(widget.widthFactor, lessThanOrEqualTo(1.0));
      }
    });

    testWidgets('App bar has correct title and styling', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Plant Center'), findsOneWidget);

      // This will fail - checking for key that might not exist
      expect(find.byKey(const Key('plantCenterTitle')), findsOneWidget);
    });

    testWidgets('Background gradient is applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Should have background container with gradient
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Should have the main background gradient container
      expect(find.byType(SafeArea), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('Responsive padding adjusts for screen size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1200)), // Large screen
            child: const PlantCenterPage(),
          ),
        ),
      );

      // Should have ConstrainedBox for max width (may have multiple)
      expect(find.byType(ConstrainedBox), findsWidgets);

      // Should have padding widgets for layout
      final padding = find.byType(Padding);
      expect(padding, findsWidgets);

      // Should still render all components on large screen
      expect(find.text('Plant Health'), findsOneWidget);
    });

    testWidgets('All components dispose properly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantCenterPage()));

      // Pump some frames for animations
      await tester.pump(const Duration(milliseconds: 500));

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // This test will pass but let's add a failing check
      // Expecting no exceptions during disposal - this should pass
      expect(find.byType(PlantCenterPage), findsNothing);
    });
  });

}
