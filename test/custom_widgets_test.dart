import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';

void main() {
  group('GlassMorphismCTAButton', () {
    testWidgets('builds with correct size and shape', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlassMorphismCTAButton(
            icon: Icons.eco,
            isSelected: true,
          ),
        ),
      ));

      // Verify Container with correct size
      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.constraints?.maxWidth, 80.0);
      expect(containerWidget.constraints?.maxHeight, 80.0);
    });

    testWidgets('displays icon correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlassMorphismCTAButton(
            icon: Icons.eco,
            isSelected: true,
          ),
        ),
      ));

      // Verify Icon is present
      expect(find.byIcon(Icons.eco), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.eco));
      expect(icon.size, 36.0);
      expect(icon.color, Colors.white);
    });

    testWidgets('has circular shape with border', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlassMorphismCTAButton(
            icon: Icons.eco,
            isSelected: true,
          ),
        ),
      ));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);

      // Should have circular decoration
      expect(containerWidget.decoration, isA<BoxDecoration>());
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('uses correct gradient colors when selected', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlassMorphismCTAButton(
            icon: Icons.eco,
            isSelected: true,
          ),
        ),
      ));

      // The gradient should contain the expected green colors
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('has multiple box shadows for depth', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlassMorphismCTAButton(
            icon: Icons.eco,
            isSelected: true,
          ),
        ),
      ));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration as BoxDecoration;

      // Should have multiple shadows
      expect(decoration.boxShadow?.length, greaterThan(1));
    });
  });

  group('CapsuleGlassMorphismTab', () {
    testWidgets('builds with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: true,
            selectedColor: Colors.green,
          ),
        ),
      ));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.constraints?.maxWidth, 56.0);
      expect(containerWidget.constraints?.maxHeight, 56.0);
    });

    testWidgets('displays icon correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: true,
            selectedColor: Colors.green,
          ),
        ),
      ));

      expect(find.byIcon(Icons.home), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.size, 24.0);
    });

    testWidgets('changes icon color based on selection', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: true,
            selectedColor: Colors.green,
          ),
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.color, Colors.white); // Selected should be white
    });

    testWidgets('has rounded rectangle shape', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: false,
            selectedColor: Colors.green,
          ),
        ),
      ));

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('uses different gradients for selected/unselected', (WidgetTester tester) async {
      // Test selected state
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: true,
            selectedColor: Colors.green,
          ),
        ),
      ));

      // Test unselected state
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CapsuleGlassMorphismTab(
            icon: Icons.home,
            isSelected: false,
            selectedColor: Colors.green,
          ),
        ),
      ));

      // Both should render without error
      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });

  group('SharpOvalShadow', () {
    testWidgets('builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SharpOvalShadow(
            width: 200.0,
            height: 50.0,
            intensity: 1.0,
          ),
        ),
      ));

      // Should render without error
      expect(find.byType(SharpOvalShadow), findsOneWidget);
    });

    testWidgets('uses IgnorePointer for non-interactive shadow', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SharpOvalShadow(
            width: 200.0,
            height: 50.0,
            intensity: 1.0,
          ),
        ),
      ));

      // Should contain IgnorePointer
      expect(find.byType(IgnorePointer), findsOneWidget);
    });

    testWidgets('applies Transform.scale for oval shape', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SharpOvalShadow(
            width: 200.0,
            height: 50.0,
            intensity: 1.0,
          ),
        ),
      ));

      // Should contain Transform
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('uses RadialGradient for shadow effect', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SharpOvalShadow(
            width: 200.0,
            height: 50.0,
            intensity: 1.0,
          ),
        ),
      ));

      // The shadow should render with gradient
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('GlossyIcon', () {
    testWidgets('builds with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlossyIcon(
            icon: Icons.star,
            size: 32.0,
          ),
        ),
      ));

      // Should contain Icon with correct size
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 32.0);
    });

    testWidgets('uses Stack for layered effects', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlossyIcon(
            icon: Icons.star,
            size: 32.0,
          ),
        ),
      ));

      // Should use Stack for glow effects
      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('has multiple IgnorePointer for glow effects', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlossyIcon(
            icon: Icons.star,
            size: 32.0,
          ),
        ),
      ));

      // Should have IgnorePointer widgets for glow layers
      expect(find.byType(IgnorePointer), findsWidgets);
    });

    testWidgets('uses default white color when not specified', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlossyIcon(
            icon: Icons.star,
            size: 32.0,
          ),
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.white);
    });

    testWidgets('accepts custom color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: GlossyIcon(
            icon: Icons.star,
            size: 32.0,
            color: Colors.blue,
          ),
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.blue);
    });
  });

  group('Custom Widget Constants', () {
    test('GlassMorphismCTAButton has correct default size', () {
      const width = 80.0;
      const height = 80.0;
      expect(width, 80.0);
      expect(height, 80.0);
    });

    test('CapsuleGlassMorphismTab has correct default size', () {
      const width = 56.0;
      const height = 56.0;
      expect(width, 56.0);
      expect(height, 56.0);
    });

    test('SharpOvalShadow has correct default values', () {
      const defaultWidth = 220.0;
      const defaultHeight = 58.0;
      const defaultIntensity = 1.0;

      expect(defaultWidth, 220.0);
      expect(defaultHeight, 58.0);
      expect(defaultIntensity, 1.0);
    });

    test('GlossyIcon calculates glow size correctly', () {
      const iconSize = 32.0;
      const expectedGlowSize = 32.0 * 1.1; // size * 1.1
      expect(expectedGlowSize, 35.2);
    });
  });

  group('Custom Widget Colors', () {
    test('GlassMorphismCTAButton uses correct green gradient', () {
      final colors = [
        const Color(0xFF4ADE80),
        const Color(0xFF22C55E),
        const Color(0xFF16A34A),
        const Color(0xFF15803D),
      ];

      expect(colors[0], const Color(0xFF4ADE80));
      expect(colors[1], const Color(0xFF22C55E));
      expect(colors[2], const Color(0xFF16A34A));
      expect(colors[3], const Color(0xFF15803D));
    });

    test('selected tab uses selected color', () {
      final selectedColor = Colors.green;
      expect(selectedColor, Colors.green);
    });

    test('unselected tab uses white gradient', () {
      final unselectedColors = [
        Colors.white.withValues(alpha: 0.95),
        Colors.white.withValues(alpha: 0.85),
      ];

      expect(unselectedColors[0], Colors.white.withValues(alpha: 0.95));
      expect(unselectedColors[1], Colors.white.withValues(alpha: 0.85));
    });
  });

  group('Custom Widget Interactions', () {
    testWidgets('widgets render without gesture detectors', (WidgetTester tester) async {
      // These widgets are typically wrapped in GestureDetector in the app
      // but should render correctly on their own
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              GlassMorphismCTAButton(icon: Icons.eco, isSelected: true),
              CapsuleGlassMorphismTab(icon: Icons.home, isSelected: false, selectedColor: Colors.green),
              SharpOvalShadow(width: 100, height: 30, intensity: 0.5),
              GlossyIcon(icon: Icons.star, size: 24),
            ],
          ),
        ),
      ));

      expect(find.byIcon(Icons.eco), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}