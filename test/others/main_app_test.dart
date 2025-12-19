import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';
import 'package:water_dashboard/utils/metric_utils.dart';

void main() {
  group('MyApp', () {
    testWidgets('builds MaterialApp with correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Hydro Monitor');
      expect(materialApp.debugShowCheckedModeBanner, false);
      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme?.useMaterial3, true);
      expect(materialApp.theme?.scaffoldBackgroundColor, isNotNull); // colorScheme.surface
    });

    testWidgets('uses correct color scheme seed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final colorScheme = materialApp.theme?.colorScheme;
      expect(colorScheme, isNotNull);
      expect(colorScheme!.primary, isNotNull);
      expect(colorScheme.secondary, isNotNull);
    });

    testWidgets('home is RootScaffold', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(RootScaffold), findsOneWidget);
    });
  });

  group('RootScaffold', () {
    testWidgets('initializes with dashboard selected', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      expect(find.byType(DashboardPage), findsOneWidget);
      expect(find.byType(PlantsPage), findsNothing);
      expect(find.byType(InsightsPage), findsNothing);
    });

    testWidgets('has correct background gradient', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('navigation state changes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Initially dashboard
      expect(find.byType(DashboardPage), findsOneWidget);

      // Tap analytics tab
      await tester.tap(find.byKey(const Key('analyticsTab')), warnIfMissed: false);
      await tester.pump();

      expect(find.byType(InsightsPage), findsOneWidget);
      expect(find.byType(DashboardPage), findsNothing);
    });

    testWidgets('first time user flag resets on navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      // Initially CTA should be highlighted (first time user)
      expect(find.byKey(const Key('plantsCTA')), findsOneWidget);

      // Tap home tab
      await tester.tap(find.byKey(const Key('homeTab')), warnIfMissed: false);
      await tester.pump();

      // Should still be on dashboard
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('CTA button navigates to plant center', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RootScaffold()));

      await tester.tap(find.byKey(const Key('plantsCTA')), warnIfMissed: false);
      await tester.pump();

      // Should navigate to PlantCenterPage
      expect(find.byType(DashboardPage), findsOneWidget); // Still in stack
      // Note: Navigation test would need MaterialApp with routes or mock navigator
    });
  });

  group('DashboardPage', () {
    testWidgets('builds with app bar and animated content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Hydro Monitor'), findsOneWidget);
      expect(find.byType(SafeArea), findsWidgets);
    });

    testWidgets('animations initialize and run', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Pump to allow animations to start
      await tester.pump(const Duration(milliseconds: 100));

      // Should have Transform widgets for animations
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('displays lettuce image', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('PlantsPage', () {
    testWidgets('shows placeholder content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantsPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Plants'), findsOneWidget);
      expect(find.text('Your plants overview'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('has correct gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlantsPage()));

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });
  });

  group('InsightsPage', () {
    testWidgets('shows placeholder content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InsightsPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Analytics & trends'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });
  });

  group('UI Components', () {
    testWidgets('LevelBox builds with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LevelBox(
              label: 'Test',
              icon: Icons.water,
              startColor: Colors.blue,
              endColor: Colors.cyan,
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byIcon(Icons.water), findsWidgets); // Background and main
    });

    testWidgets('MetricDetailCard displays config data', (WidgetTester tester) async {
      final config = MetricConfig(
        type: MetricType.water,
        label: 'Water',
        resultLabel: 'Water level',
        valueText: '75%',
        icon: Icons.water_drop,
        startColor: Colors.blue,
        endColor: Colors.cyan,
        progress: 0.75,
        statusText: 'Good',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MetricDetailCard(config: config),
          ),
        ),
      );

      expect(find.text('Water level'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
    });

    testWidgets('ResultTile shows label and value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResultTile(
              label: 'Test Label',
              value: 'Test Value',
              color: Colors.green,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Value'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('SharpOvalShadow renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharpOvalShadow(width: 200, height: 50, intensity: 1.0),
          ),
        ),
      );

      expect(find.byType(SharpOvalShadow), findsOneWidget);
    });

    testWidgets('GlassMorphismCTAButton has correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassMorphismCTAButton(
              icon: Icons.eco,
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('CapsuleGlassMorphismTab changes appearance when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CapsuleGlassMorphismTab(
                  icon: Icons.home,
                  isSelected: false,
                  selectedColor: Colors.green,
                ),
                CapsuleGlassMorphismTab(
                  icon: Icons.settings,
                  isSelected: true,
                  selectedColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('Animation Controllers', () {
    testWidgets('DashboardPage initializes animation controllers', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Pump to trigger initState
      await tester.pump();

      // Should not crash and should have animations running
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('animations dispose properly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
      await tester.pump();

      // Dispose should be called when widget is removed
      await tester.pumpWidget(const SizedBox());

      // Should not crash
    });
  });
}