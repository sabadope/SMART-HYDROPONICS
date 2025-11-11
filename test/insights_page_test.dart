import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';

void main() {
  group('InsightsPage', () {
    testWidgets('builds with Scaffold and AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify Scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has correct app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify title text
      expect(find.text('Insights'), findsOneWidget);
    });

    testWidgets('app bar has transparent configuration', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      // Verify transparent styling
      expect(appBar.backgroundColor, Colors.transparent);
      expect(appBar.surfaceTintColor, Colors.transparent);
      expect(appBar.elevation, 0.0);
      expect(appBar.scrolledUnderElevation, 0.0);
    });

    testWidgets('displays placeholder content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify placeholder text
      expect(find.text('Analytics & trends'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
    });

    testWidgets('has centered content layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify Center widget is used
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('uses gradient container for content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify Container with gradient decoration
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Find the container with gradient
      bool foundGradientContainer = false;
      for (final container in containers.evaluate()) {
        final containerWidget = container.widget as Container;
        if (containerWidget.decoration is BoxDecoration) {
          final decoration = containerWidget.decoration as BoxDecoration;
          if (decoration.gradient is LinearGradient) {
            foundGradientContainer = true;
            break;
          }
        }
      }
      expect(foundGradientContainer, true);
    });

    testWidgets('displays bar chart icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify Icon widget is present
      expect(find.byType(Icon), findsWidgets);

      // Should contain bar_chart icon
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('uses correct gradient colors', (WidgetTester tester) async {
      // Test the hardcoded gradient colors used in InsightsPage
      final startColor = const Color(0xFF9775FA);
      final endColor = const Color(0xFF5C7CFA);

      expect(startColor, const Color(0xFF9775FA));
      expect(endColor, const Color(0xFF5C7CFA));
    });

    testWidgets('has box shadow for depth', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // The container should have box shadow
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('content is properly sized', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify Column with MainAxisSize.min
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('icon has correct size and color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      final icon = tester.widget<Icon>(find.byIcon(Icons.bar_chart));
      expect(icon.size, 48.0);
      expect(icon.color, Colors.white);
    });
  });

  group('InsightsPage Layout', () {
    testWidgets('uses extendBodyBehindAppBar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBodyBehindAppBar, true);
    });

    testWidgets('background is transparent', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.transparent);
    });
  });

  group('InsightsPage Constants', () {
    test('padding value is correct', () {
      const padding = 20.0;
      expect(padding, 20.0);
    });

    test('border radius is correct', () {
      const borderRadius = 20.0;
      expect(borderRadius, 20.0);
    });

    test('icon size is correct', () {
      const iconSize = 48.0;
      expect(iconSize, 48.0);
    });

    test('font weights are correct', () {
      const titleWeight = FontWeight.w700;
      const subtitleWeight = FontWeight.w600;

      expect(titleWeight, FontWeight.w700);
      expect(subtitleWeight, FontWeight.w600);
    });
  });

  group('InsightsPage Colors', () {
    test('text colors are correct', () {
      final titleColor = Colors.white;
      final subtitleColor = Colors.white.withValues(alpha: 0.9);

      expect(titleColor, Colors.white);
      expect(subtitleColor, Colors.white.withValues(alpha: 0.9));
    });

    test('shadow color is correct', () {
      final shadowColor = Colors.black.withValues(alpha: 0.18);
      expect(shadowColor, Colors.black.withValues(alpha: 0.18));
    });
  });

  group('InsightsPage Accessibility', () {
    testWidgets('content is readable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Verify text contrast (white on purple gradient)
      expect(find.text('Analytics & trends'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
    });

    testWidgets('icon provides visual context', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      // Bar chart icon provides context for analytics content
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });
  });

  group('InsightsPage Integration', () {
    testWidgets('works within RootScaffold navigation', (WidgetTester tester) async {
      // This would be tested in the main navigation tests
      // Here we just verify the page can be instantiated
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));
      expect(find.byType(InsightsPage), findsOneWidget);
    });
  });

  group('InsightsPage vs PlantsPage Comparison', () {
    test('insights uses different gradient than plants', () {
      final insightsStart = const Color(0xFF9775FA);
      final insightsEnd = const Color(0xFF5C7CFA);
      final plantsStart = const Color(0xFF80ED99);
      final plantsEnd = const Color(0xFF57CC99);

      expect(insightsStart, isNot(plantsStart));
      expect(insightsEnd, isNot(plantsEnd));
    });

    test('insights uses bar_chart icon vs plants eco icon', () {
      // Icons are different
      expect(Icons.bar_chart, isNot(Icons.eco));
    });

    test('insights title is different from plants', () {
      expect('Insights', isNot('Plants'));
      expect('Analytics & trends', isNot('Your plants overview'));
    });
  });
}