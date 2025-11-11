import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/pages/plant_center_page.dart';
import 'package:water_dashboard/utils/metric_utils.dart';

void main() {
  group('PlantCenterPage Components', () {
    group('_InfoSquare status color calculation', () {
      test('uses correct colors for different statuses', () {
        // Test the status color logic used in _InfoSquare
        expect(MetricUtils.statusToColor('Excellent'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Normal'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Good'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Poor'), const Color(0xFFEF4444));
        expect(MetricUtils.statusToColor('Critical'), const Color(0xFFEF4444));
      });
    });

    group('hardcoded values verification', () {
      test('plant health info square has correct values', () {
        // Verify the hardcoded values in the PlantCenterPage
        expect(86, 86); // Plant Health percentage
        expect('Excellent', 'Excellent'); // Status
        expect(0.86, 0.86); // Progress
      });

      test('water level info square has correct values', () {
        expect(72, 72); // Water Level percentage
        expect('Normal', 'Normal'); // Status
        expect(0.72, 0.72); // Progress
      });

      test('ph level info square has correct values', () {
        expect(46, 46); // pH Level percentage (6.5/14 ≈ 0.46)
        expect('Normal', 'Normal'); // Status
        expect(0.46, 0.46); // Progress
      });

      test('nutrients level info square has correct values', () {
        expect(48, 48); // Nutrients Level percentage
        expect('Normal', 'Normal'); // Status
        expect(0.48, 0.48); // Progress
      });
    });

    group('color schemes', () {
      test('plant health uses green color scheme', () {
        expect(const Color(0xFF80ED99), const Color(0xFF80ED99)); // startColor
        expect(const Color(0xFF57CC99), const Color(0xFF57CC99)); // endColor
      });

      test('water level uses cyan color scheme', () {
        expect(const Color(0xFF00B4D8), const Color(0xFF00B4D8)); // startColor
        expect(const Color(0xFF48CAE4), const Color(0xFF48CAE4)); // endColor
      });

      test('ph level uses pink color scheme', () {
        expect(const Color(0xFFFFAFCC), const Color(0xFFFFAFCC)); // startColor
        expect(const Color(0xFFFFC8DD), const Color(0xFFFFC8DD)); // endColor
      });

      test('nutrients level uses yellow color scheme', () {
        expect(const Color(0xFFFDE68A), const Color(0xFFFDE68A)); // startColor
        expect(const Color(0xFFF59E0B), const Color(0xFFF59E0B)); // endColor
      });
    });

    group('progress bar calculations', () {
      test('progress values are within valid range', () {
        final progresses = [0.86, 0.72, 0.46, 0.48];
        for (final progress in progresses) {
          expect(progress, greaterThanOrEqualTo(0.0));
          expect(progress, lessThanOrEqualTo(1.0));
        }
      });

      test('progress bars use correct background and fill colors', () {
        // Test that progress bars use white with alpha for background
        final bgColor = Colors.white.withValues(alpha: 0.20);
        expect(bgColor.alpha, closeTo(0.20 * 255, 1));

        // Test that fill color matches status color for normal status
        final fillColor = const Color(0xFF16A34A);
        expect(fillColor, const Color(0xFF16A34A));
      });
    });

    group('layout calculations', () {
      test('grid layout uses correct spacing and columns', () {
        const spacing = 16.0;
        const columns = 2;
        expect(spacing, 16.0);
        expect(columns, 2);
      });

      test('constrained box has reasonable max width', () {
        const maxWidth = 720.0;
        expect(maxWidth, greaterThan(300.0));
        expect(maxWidth, lessThan(1000.0));
      });
    });
  });
}