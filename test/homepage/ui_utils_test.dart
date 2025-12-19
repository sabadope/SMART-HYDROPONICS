import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/utils/ui_utils.dart';
import 'dart:math' as math;

void main() {
  group('UiUtils', () {
    group('calculateTileWidth', () {
      test('calculates tile width correctly', () {
        expect(UiUtils.calculateTileWidth(300, 2, 16), 142); // (300 - 16) / 2 = 142
        expect(UiUtils.calculateTileWidth(400, 3, 20), 120); // (400 - 40) / 3 = 360 / 3 = 120
      });

      test('handles single column correctly', () {
        expect(UiUtils.calculateTileWidth(200, 1, 16), 200);
      });
    });

    group('calculateProgress', () {
      test('calculates progress correctly', () {
        expect(UiUtils.calculateProgress(50, 100), 0.5);
        expect(UiUtils.calculateProgress(25, 200), 0.125);
        expect(UiUtils.calculateProgress(0, 100), 0.0);
        expect(UiUtils.calculateProgress(100, 100), 1.0);
      });

      test('handles zero or negative max values', () {
        expect(UiUtils.calculateProgress(50, 0), 0.0);
        expect(UiUtils.calculateProgress(50, -10), 0.0);
      });

      test('clamps values between 0 and 1', () {
        expect(UiUtils.calculateProgress(150, 100), 1.0);
        expect(UiUtils.calculateProgress(-50, 100), 0.0);
      });
    });

    group('calculateProgressAngle', () {
      test('calculates angle correctly', () {
        expect(UiUtils.calculateProgressAngle(0.5), closeTo(math.pi, 0.001)); // π radians = 180°
        expect(UiUtils.calculateProgressAngle(1.0), closeTo(2 * math.pi, 0.001)); // 2π radians = 360°
        expect(UiUtils.calculateProgressAngle(0.0), 0.0);
      });

      test('clamps progress values', () {
        expect(UiUtils.calculateProgressAngle(1.5), closeTo(2 * math.pi, 0.001));
        expect(UiUtils.calculateProgressAngle(-0.5), 0.0);
      });
    });

    group('calculateCircularPositions', () {
      test('calculates positions for multiple items', () {
        final center = const Offset(100, 100);
        final positions = UiUtils.calculateCircularPositions(4, 50, center);

        expect(positions.length, 4);
        // Check that all positions are at correct distance from center
        for (final pos in positions) {
          final distance = math.sqrt(
            math.pow(pos.dx - center.dx, 2) + math.pow(pos.dy - center.dy, 2),
          );
          expect(distance, closeTo(50.0, 0.1));
        }
      });

      test('handles zero count', () {
        final positions = UiUtils.calculateCircularPositions(0, 50, const Offset(0, 0));
        expect(positions, isEmpty);
      });

      test('handles single item', () {
        final center = const Offset(50, 50);
        final positions = UiUtils.calculateCircularPositions(1, 30, center, startAngle: math.pi / 4);

        expect(positions.length, 1);
        final pos = positions[0];
        final expectedX = 50 + 30 * math.cos(math.pi / 4);
        final expectedY = 50 + 30 * math.sin(math.pi / 4);
        expect(pos.dx, closeTo(expectedX, 0.1));
        expect(pos.dy, closeTo(expectedY, 0.1));
      });
    });

    group('calculateResponsivePadding', () {
      test('calculates padding based on screen size', () {
        final smallScreen = const Size(300, 600);
        final largeScreen = const Size(800, 1200);

        final smallPadding = UiUtils.calculateResponsivePadding(16, smallScreen);
        final largePadding = UiUtils.calculateResponsivePadding(16, largeScreen);

        expect(smallPadding.left, greaterThan(8.0)); // minimum
        expect(largePadding.left, lessThanOrEqualTo(32.0)); // maximum
        expect(largePadding.left, greaterThan(smallPadding.left));
      });

      test('clamps padding within bounds', () {
        final tinyScreen = const Size(100, 100);
        final hugeScreen = const Size(2000, 2000);

        final tinyPadding = UiUtils.calculateResponsivePadding(16, tinyScreen);
        final hugePadding = UiUtils.calculateResponsivePadding(16, hugeScreen);

        expect(tinyPadding.left, 8.0); // minimum
        expect(hugePadding.left, 32.0); // maximum
      });
    });

    group('calculateResponsiveTextScale', () {
      test('calculates text scale based on screen size', () {
        final smallScreen = const Size(320, 568); // iPhone SE
        final largeScreen = const Size(428, 926); // iPhone Pro Max

        final smallScale = UiUtils.calculateResponsiveTextScale(1.0, smallScreen);
        final largeScale = UiUtils.calculateResponsiveTextScale(1.0, largeScreen);

        expect(smallScale, greaterThanOrEqualTo(0.8));
        expect(largeScale, lessThanOrEqualTo(1.5));
      });

      test('clamps scale within bounds', () {
        final tinyScreen = const Size(200, 300);
        final hugeScreen = const Size(1000, 1500);

        final tinyScale = UiUtils.calculateResponsiveTextScale(1.0, tinyScreen);
        final hugeScale = UiUtils.calculateResponsiveTextScale(1.0, hugeScreen);

        expect(tinyScale, 0.8); // minimum
        expect(hugeScale, 1.5); // maximum
      });
    });

    group('calculateAnimationDuration', () {
      test('calculates duration based on distance and speed', () {
        final duration = UiUtils.calculateAnimationDuration(200, 100); // 200px at 100px/s = 2s
        expect(duration.inMilliseconds, 2000);
      });

      test('clamps duration within bounds', () {
        final shortDuration = UiUtils.calculateAnimationDuration(10, 1000); // very fast
        final longDuration = UiUtils.calculateAnimationDuration(10000, 1); // very slow

        expect(shortDuration.inMilliseconds, 100); // minimum
        expect(longDuration.inMilliseconds, 2000); // maximum
      });

      test('handles zero or negative speed', () {
        final duration = UiUtils.calculateAnimationDuration(100, 0);
        expect(duration.inMilliseconds, 300); // default
      });
    });

    group('easeOutCubic', () {
      test('calculates cubic ease-out correctly', () {
        expect(UiUtils.easeOutCubic(0.0), 0.0);
        expect(UiUtils.easeOutCubic(1.0), 1.0);
        expect(UiUtils.easeOutCubic(0.5), closeTo(0.875, 0.001)); // 1 - (1-0.5)^3 = 1 - 0.125 = 0.875
      });

      test('clamps input values', () {
        expect(UiUtils.easeOutCubic(-0.5), 0.0);
        expect(UiUtils.easeOutCubic(1.5), 1.0);
      });
    });

    group('lerpColor', () {
      test('interpolates colors correctly', () {
        final color1 = const Color(0xFF000000); // Black
        final color2 = const Color(0xFFFFFFFF); // White

        final midColor = UiUtils.lerpColor(color1, color2, 0.5);
        expect(midColor.red, closeTo(128, 1)); // Should be around 128 (0.5 * 255 rounded)
        expect(midColor.green, closeTo(128, 1));
        expect(midColor.blue, closeTo(128, 1));
      });

      test('handles edge cases', () {
        final color = const Color(0xFFFF0000); // Red
        expect(UiUtils.lerpColor(color, color, 0.5), color);
        expect(UiUtils.lerpColor(color, color, -1.0), color);
        expect(UiUtils.lerpColor(color, color, 2.0), color);
      });
    });

    group('calculateFadeOpacity', () {
      test('calculates fade in correctly', () {
        expect(UiUtils.calculateFadeOpacity(0.0, true), 0.0);
        expect(UiUtils.calculateFadeOpacity(0.5, true), 0.5);
        expect(UiUtils.calculateFadeOpacity(1.0, true), 1.0);
      });

      test('calculates fade out correctly', () {
        expect(UiUtils.calculateFadeOpacity(0.0, false), 1.0);
        expect(UiUtils.calculateFadeOpacity(0.5, false), 0.5);
        expect(UiUtils.calculateFadeOpacity(1.0, false), 0.0);
      });

      test('clamps values', () {
        expect(UiUtils.calculateFadeOpacity(-0.5, true), 0.0);
        expect(UiUtils.calculateFadeOpacity(1.5, true), 1.0);
      });
    });

    group('calculateBounceScale', () {
      test('calculates bounce scale correctly', () {
        final scale = UiUtils.calculateBounceScale(0.5, 0.2);
        expect(scale, greaterThan(1.0)); // Should be larger than base scale
        expect(scale, lessThan(1.2)); // Should not exceed max bounce
      });

      test('returns 1.0 at start and end', () {
        expect(UiUtils.calculateBounceScale(0.0, 0.5), 1.0);
        expect(UiUtils.calculateBounceScale(1.0, 0.5), 1.0);
      });

      test('handles zero intensity', () {
        expect(UiUtils.calculateBounceScale(0.5, 0.0), 1.0);
      });
    });
  });
}