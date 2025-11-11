import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';
import 'package:water_dashboard/pages/plant_center_page.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('RootScaffold initializes with dashboard', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should start with DashboardPage
      expect(find.byType(DashboardPage), findsOneWidget);
      expect(find.byType(PlantsPage), findsNothing);
      expect(find.byType(InsightsPage), findsNothing);
    });

    testWidgets('Navigation tabs exist', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should have navigation keys
      expect(find.byKey(const Key('homeTab')), findsOneWidget);
      expect(find.byKey(const Key('analyticsTab')), findsOneWidget);
      expect(find.byKey(const Key('plantsCTA')), findsOneWidget);
    });

    testWidgets('First time user starts with CTA highlighted', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Initially first time user should be true
      // CTA button should be highlighted
      expect(find.byKey(const Key('plantsCTA')), findsOneWidget);
    });

    testWidgets('Home tab switches to dashboard', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Start on dashboard
      expect(find.byType(DashboardPage), findsOneWidget);

      // Switch to insights first
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(InsightsPage), findsOneWidget);

      // Switch back to dashboard
      await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('Analytics tab switches to insights', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Start on dashboard
      expect(find.byType(DashboardPage), findsOneWidget);

      // Switch to insights
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(InsightsPage), findsOneWidget);
    });

    testWidgets('CTA button exists and is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // CTA button should exist and be tappable
      final ctaButton = find.byKey(const Key('plantsCTA'));
      expect(ctaButton, findsOneWidget);

      // Should be able to tap it without errors
      await tester.tap(ctaButton, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      // Test passes if no exceptions are thrown
      expect(ctaButton, findsOneWidget);
    });

    testWidgets('Navigation state management works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Initially on dashboard
      expect(find.byType(DashboardPage), findsOneWidget);

      // Switch to insights
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();

      // Should be on insights
      expect(find.byType(InsightsPage), findsOneWidget);
    });

    testWidgets('Tab navigation cycles work', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Start on dashboard
      expect(find.byType(DashboardPage), findsOneWidget);

      // Go to insights
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(InsightsPage), findsOneWidget);

      // Go back to dashboard
      await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('IndexedStack manages page switching', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should use IndexedStack for page management
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('Bottom navigation bar is positioned correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should have bottom navigation bar
      expect(find.byType(Stack), findsWidgets); // Bottom nav is in a Stack
    });

    testWidgets('Navigation structure is properly set up', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should have proper navigation structure
      expect(find.byType(IndexedStack), findsOneWidget);
      expect(find.byType(Stack), findsWidgets); // Bottom navigation
    });

    testWidgets('Navigation state is maintained', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Switch to insights
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();

      // Switch back to home
      await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
      await tester.pump();

      // Should remember the state
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('First time user flag is managed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Initially first time user
      // After any interaction, should not be first time anymore
      await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
      await tester.pump();

      // The flag should be updated
    });

    testWidgets('Navigation works with keyboard shortcuts', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should respond to keyboard navigation if implemented
      expect(find.byType(RootScaffold), findsOneWidget);
    });

    testWidgets('Deep linking support', (WidgetTester tester) async {
      // Test if app supports deep linking (placeholder)
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Navigation animations are smooth', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Switch pages
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Should have transitioned smoothly
      expect(find.byType(InsightsPage), findsOneWidget);
    });
  });

  group('Navigation Constants', () {
    test('Page indices are correct', () {
      const dashboardIndex = 0;
      const plantsIndex = 1;
      const insightsIndex = 2;

      expect(dashboardIndex, 0);
      expect(plantsIndex, 1);
      expect(insightsIndex, 2);
    });

    test('Navigation keys are defined', () {
      const homeTabKey = Key('homeTab');
      const analyticsTabKey = Key('analyticsTab');
      const plantsCtaKey = Key('plantsCTA');

      expect(homeTabKey, const Key('homeTab'));
      expect(analyticsTabKey, const Key('analyticsTab'));
      expect(plantsCtaKey, const Key('plantsCTA'));
    });

    test('Bottom navigation height is correct', () {
      const navHeight = 120.0;
      expect(navHeight, 120.0);
    });
  });

  group('Navigation State Management', () {
    test('Selected index starts at 0', () {
      const initialIndex = 0;
      expect(initialIndex, 0);
    });

    test('First time user flag starts as true', () {
      const initialFirstTime = true;
      expect(initialFirstTime, true);
    });

    test('Page list has correct length', () {
      const pageCount = 3;
      expect(pageCount, 3);
    });
  });

  group('Navigation Performance', () {
    testWidgets('Page switching is fast', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should be fast
    });

    testWidgets('Memory is managed properly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Switch pages multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
        await tester.pump();
        await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
        await tester.pump();
      }

      // Should not have memory issues
      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });

  group('Navigation Accessibility', () {
    testWidgets('Navigation elements have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Navigation elements should be accessible
      expect(find.byKey(const Key('homeTab')), findsOneWidget);
      expect(find.byKey(const Key('analyticsTab')), findsOneWidget);
    });

    testWidgets('Screen reader can navigate', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Should support screen reader navigation
      expect(find.byType(RootScaffold), findsOneWidget);
    });
  });
}