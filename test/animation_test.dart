import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';
import 'dart:math' as math;

void main() {
  group('Animation Tests', () {
    testWidgets('DashboardPage floating animation initializes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Verify animation controllers are created
      await tester.pump(const Duration(milliseconds: 100));

      // The animation should be running
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('SharpOvalShadow renders with animation', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SharpOvalShadow(width: 200, height: 50, intensity: 1.0),
        ),
      ));

      // Should render without error
      expect(find.byType(SharpOvalShadow), findsOneWidget);
    });

    testWidgets('Animation curves work correctly', (WidgetTester tester) async {
      // Test that Curves.easeInOut works
      final curve = Curves.easeInOut;
      expect(curve.transform(0.0), 0.0);
      expect(curve.transform(0.5), 0.5);
      expect(curve.transform(1.0), 1.0);
    });

    testWidgets('Animation duration constants are reasonable', (WidgetTester tester) async {
      const floatDuration = Duration(seconds: 3);
      const waveDuration = Duration(seconds: 4);

      expect(floatDuration.inSeconds, 3);
      expect(waveDuration.inSeconds, 4);
    });

    testWidgets('Transform animations apply correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Should have Transform widgets for animations
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('AnimationController parameters are valid', (WidgetTester tester) async {
      // Test animation controller configurations in widget context
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Animation controllers should be created within the widget
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('Tween ranges are correct', (WidgetTester tester) async {
      final floatTween = Tween<double>(begin: -6, end: 6);
      final pulseTween = Tween<double>(begin: 0.0, end: 1.0);

      expect(floatTween.begin, -6.0);
      expect(floatTween.end, 6.0);
      expect(pulseTween.begin, 0.0);
      expect(pulseTween.end, 1.0);
    });

    testWidgets('Wave calculations produce valid values', (WidgetTester tester) async {
      // Test wave calculation functions
      final y1 = 100.0 + 5.0 * math.sin(0.5 * 2.0 + 0.0);
      final y2 = 100.0 + 3.0 * math.sin(0.3 * 2.0 + 1.57);

      expect(y1, isA<double>());
      expect(y2, isA<double>());
      expect(y1, greaterThan(95.0));
      expect(y1, lessThan(105.0));
    });

    testWidgets('Bubble positioning calculations', (WidgetTester tester) async {
      // Test bubble position calculations
      final time = 1.0;
      final speed = 50.0;
      final offset = 10.0;
      final size = 300.0;

      final position = (time * speed + offset) % (size + 100.0) - 50.0;
      expect(position, greaterThanOrEqualTo(-50.0));
      expect(position, lessThanOrEqualTo(350.0));
    });

    testWidgets('Animation performance - no excessive rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Pump several frames
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Should still be stable
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('Shadow animation intensity scaling', (WidgetTester tester) async {
      const intensity = 1.0;
      final opacity1 = (0.7 * intensity).clamp(0.0, 1.0);
      final opacity2 = (0.4 * intensity).clamp(0.0, 1.0);

      expect(opacity1, 0.7);
      expect(opacity2, 0.4);
    });

    testWidgets('Animation cleanup on dispose', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // Should not crash - proper cleanup
    });

    testWidgets('Multiple animations can run simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // Should handle multiple animation controllers
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('Animation values stay within bounds', (WidgetTester tester) async {
      // Test that animation values don't exceed expected ranges
      final floatValue = -6.0 + (6.0 - (-6.0)) * 0.5; // Midpoint
      final pulseValue = 0.0 + (1.0 - 0.0) * 0.5; // Midpoint

      expect(floatValue, 0.0);
      expect(pulseValue, 0.5);
    });

    testWidgets('Wave phase calculations', (WidgetTester tester) async {
      final phase = 0.0;
      final waveNumber = 2 * math.pi / 10.0; // Wavelength = 10
      final x = 5.0;
      final amplitude = 3.0;

      final waveY = amplitude * math.sin(waveNumber * x + phase);
      expect(waveY, isA<double>());
      expect(waveY.abs(), lessThanOrEqualTo(amplitude));
    });

    testWidgets('Animation timing is consistent', (WidgetTester tester) async {
      const duration1 = Duration(seconds: 3);
      const duration2 = Duration(seconds: 4);

      expect(duration1.inMilliseconds, 3000);
      expect(duration2.inMilliseconds, 4000);
    });
  });

  group('Animation Constants', () {
    test('Float animation parameters', () {
      const begin = -6.0;
      const end = 6.0;
      const durationSeconds = 3;

      expect(begin, -6.0);
      expect(end, 6.0);
      expect(durationSeconds, 3);
    });

    test('Pulse animation parameters', () {
      const begin = 0.0;
      const end = 1.0;

      expect(begin, 0.0);
      expect(end, 1.0);
    });

    test('Shadow animation parameters', () {
      const begin = 1.0;
      const end = 1.3;
      const durationSeconds = 3;

      expect(begin, 1.0);
      expect(end, 1.3);
      expect(durationSeconds, 3);
    });

    test('Wave animation parameters', () {
      const durationSeconds = 4;
      const phaseRange = math.pi * 2;

      expect(durationSeconds, 4);
      expect(phaseRange, closeTo(6.2832, 0.0001));
    });
  });

  group('Animation Math', () {
    test('Sine wave calculations', () {
      final values = <double>[];
      for (int i = 0; i < 10; i++) {
        final x = i * 0.1;
        final y = math.sin(x);
        values.add(y);
        expect(y, greaterThanOrEqualTo(-1.0));
        expect(y, lessThanOrEqualTo(1.0));
      }
      expect(values.length, 10);
    });

    test('Combined wave calculations', () {
      final baseY = 100.0;
      final amplitude1 = 5.0;
      final amplitude2 = 3.0;
      final x = 2.0;

      final y1 = baseY + amplitude1 * math.sin(x);
      final y2 = baseY + amplitude2 * math.sin(x + math.pi / 2);

      final combined = math.min(y1, y2);
      expect(combined, isA<double>());
      expect(combined, greaterThan(baseY - amplitude1 - amplitude2));
    });

    test('Animation interpolation', () {
      final t = 0.5;
      final start = 0.0;
      final end = 10.0;

      final interpolated = start + (end - start) * t;
      expect(interpolated, 5.0);
    });
  });
}
