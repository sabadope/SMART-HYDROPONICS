import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/utils/metric_utils.dart';
import 'dart:math' as math;

void main() {
  group('MetricUtils', () {
    group('configFor', () {
      test('returns correct config for water metric', () {
        final config = MetricUtils.configFor(MetricType.water);

        expect(config.type, MetricType.water);
        expect(config.label, 'Water');
        expect(config.resultLabel, 'Water level');
        expect(config.valueText, '72%');
        expect(config.icon, Icons.water_drop);
        expect(config.startColor, const Color(0xFF00B4D8));
        expect(config.endColor, const Color(0xFF48CAE4));
        expect(config.progress, 0.72);
        expect(config.statusText, 'Optimal');
      });

      test('returns correct config for nutrients metric', () {
        final config = MetricUtils.configFor(MetricType.nutrients);

        expect(config.type, MetricType.nutrients);
        expect(config.label, 'Nutrients');
        expect(config.resultLabel, 'Nutrients level');
        expect(config.valueText, '480 ppm');
        expect(config.icon, Icons.biotech);
        expect(config.startColor, const Color(0xFF80ED99));
        expect(config.endColor, const Color(0xFF57CC99));
        expect(config.progress, 0.48);
        expect(config.statusText, 'Good');
      });

      test('returns correct config for ph metric', () {
        final config = MetricUtils.configFor(MetricType.ph);

        expect(config.type, MetricType.ph);
        expect(config.label, 'pH');
        expect(config.resultLabel, 'pH level');
        expect(config.valueText, '6.5');
        expect(config.icon, Icons.speed);
        expect(config.startColor, const Color(0xFFFFAFCC));
        expect(config.endColor, const Color(0xFFFFC8DD));
        expect(config.progress, 0.46);
        expect(config.statusText, 'Slightly acidic');
      });
    });

    group('statusToColor', () {
      test('returns red for poor/critical/low status', () {
        expect(MetricUtils.statusToColor('Poor'), const Color(0xFFEF4444));
        expect(MetricUtils.statusToColor('Critical'), const Color(0xFFEF4444));
        expect(MetricUtils.statusToColor('Low'), const Color(0xFFEF4444));
        expect(MetricUtils.statusToColor('very low'), const Color(0xFFEF4444));
      });

      test('returns yellow for warn/caution/medium status', () {
        expect(MetricUtils.statusToColor('Warn'), const Color(0xFFF59E0B));
        expect(MetricUtils.statusToColor('Caution'), const Color(0xFFF59E0B));
        expect(MetricUtils.statusToColor('Medium'), const Color(0xFFF59E0B));
        expect(MetricUtils.statusToColor('warning'), const Color(0xFFF59E0B));
      });

      test('returns green for excellent/normal/good/optimal/ok status', () {
        expect(MetricUtils.statusToColor('Excellent'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Normal'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Good'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('Optimal'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('OK'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor('great'), const Color(0xFF16A34A));
      });

      test('returns green for unknown status', () {
        expect(MetricUtils.statusToColor('Unknown'), const Color(0xFF16A34A));
        expect(MetricUtils.statusToColor(''), const Color(0xFF16A34A));
      });
    });

    group('calculateShadowOpacity', () {
      test('calculates opacity correctly with intensity 1.0', () {
        expect(MetricUtils.calculateShadowOpacity(0.5, 1.0), 0.5);
        expect(MetricUtils.calculateShadowOpacity(1.0, 1.0), 1.0);
        expect(MetricUtils.calculateShadowOpacity(0.0, 1.0), 0.0);
      });

      test('calculates opacity correctly with intensity 0.5', () {
        expect(MetricUtils.calculateShadowOpacity(0.5, 0.5), 0.25);
        expect(MetricUtils.calculateShadowOpacity(1.0, 0.5), 0.5);
      });

      test('clamps values between 0.0 and 1.0', () {
        expect(MetricUtils.calculateShadowOpacity(2.0, 1.0), 1.0);
        expect(MetricUtils.calculateShadowOpacity(-1.0, 1.0), 0.0);
        expect(MetricUtils.calculateShadowOpacity(0.5, 3.0), 1.0);
      });
    });

    group('fract', () {
      test('returns fractional part of positive numbers', () {
        expect(MetricUtils.fract(3.7), closeTo(0.7, 0.001));
        expect(MetricUtils.fract(1.0), 0.0);
        expect(MetricUtils.fract(0.5), 0.5);
      });

      test('returns fractional part of negative numbers', () {
        expect(MetricUtils.fract(-3.7), closeTo(0.3, 0.001));
        expect(MetricUtils.fract(-1.0), 0.0);
        expect(MetricUtils.fract(-0.5), 0.5);
      });

      test('handles integers correctly', () {
        expect(MetricUtils.fract(5), 0.0);
        expect(MetricUtils.fract(0), 0.0);
        expect(MetricUtils.fract(-5), 0.0);
      });
    });

    group('rand01', () {
      test('returns values between 0 and 1', () {
        for (int i = 0; i < 100; i++) {
          final result = MetricUtils.rand01(i, 0.1);
          expect(result, greaterThanOrEqualTo(0.0));
          expect(result, lessThanOrEqualTo(1.0));
        }
      });

      test('returns consistent results for same inputs', () {
        expect(MetricUtils.rand01(5, 0.5), MetricUtils.rand01(5, 0.5));
        expect(MetricUtils.rand01(10, 0.2), MetricUtils.rand01(10, 0.2));
      });

      test('returns different results for different inputs', () {
        expect(MetricUtils.rand01(1, 0.1), isNot(MetricUtils.rand01(2, 0.1)));
        expect(MetricUtils.rand01(1, 0.1), isNot(MetricUtils.rand01(1, 0.2)));
      });
    });

    group('calculateWaveAmplitude', () {
      test('calculates amplitude with base and variation', () {
        final result = MetricUtils.calculateWaveAmplitude(10.0, 5.0, 1, 0.1);
        expect(result, greaterThanOrEqualTo(10.0));
        expect(result, lessThanOrEqualTo(15.0));
      });

      test('returns base amplitude when variation is zero', () {
        final result = MetricUtils.calculateWaveAmplitude(8.0, 0.0, 1, 0.1);
        expect(result, 8.0);
      });
    });

    group('calculateBubblePosition', () {
      test('calculates position within expected range', () {
        final result = MetricUtils.calculateBubblePosition(1.0, 50.0, 10.0, 300.0);
        expect(result, greaterThanOrEqualTo(-50.0));
        expect(result, lessThanOrEqualTo(350.0));
      });

      test('handles zero time correctly', () {
        final result = MetricUtils.calculateBubblePosition(0.0, 50.0, 10.0, 300.0);
        expect(result, -40.0);
      });

      test('handles different speeds and offsets', () {
        final result1 = MetricUtils.calculateBubblePosition(2.0, 25.0, 5.0, 200.0);
        final result2 = MetricUtils.calculateBubblePosition(2.0, 50.0, 5.0, 200.0);
        expect(result1, isNot(result2));
      });
    });

    group('calculateWaveNumber', () {
      test('calculates wave number correctly', () {
        final k = MetricUtils.calculateWaveNumber(10.0);
        expect(k, closeTo(2 * 3.14159 / 10.0, 0.001));
      });

      test('returns higher wave number for shorter wavelengths', () {
        final k1 = MetricUtils.calculateWaveNumber(5.0);
        final k2 = MetricUtils.calculateWaveNumber(10.0);
        expect(k1, greaterThan(k2));
      });
    });

    group('calculateWaveY', () {
      test('calculates wave Y position correctly', () {
        final y = MetricUtils.calculateWaveY(100.0, 5.0, 0.5, 2.0, 0.0);
        expect(y, closeTo(100.0 + 5.0 * math.sin(1.0), 0.1)); // sin(0.5 * 2.0 + 0.0) = sin(1.0) ≈ 0.8415
      });

      test('returns base Y when amplitude is zero', () {
        final y = MetricUtils.calculateWaveY(50.0, 0.0, 1.0, 1.0, 0.0);
        expect(y, 50.0);
      });

      test('handles phase shifts correctly', () {
        final y1 = MetricUtils.calculateWaveY(0.0, 1.0, 1.0, 0.0, 0.0);
        final y2 = MetricUtils.calculateWaveY(0.0, 1.0, 1.0, 0.0, 3.14159); // π
        expect(y1, closeTo(0.0, 0.1));
        expect(y2, closeTo(0.0, 0.1)); // sin(π) = 0
      });
    });

    group('calculateCombinedWaveY', () {
      test('returns minimum of two waves', () {
        final y = MetricUtils.calculateCombinedWaveY(100.0, 5.0, 3.0, 0.5, 0.3, 2.0, 0.0, 1.57); // π/2
        final y1 = MetricUtils.calculateWaveY(100.0, 5.0, 0.5, 2.0, 0.0);
        final y2 = MetricUtils.calculateWaveY(100.0, 3.0, 0.3, 2.0, 1.57);
        expect(y, math.min(y1, y2));
      });

      test('handles equal amplitudes correctly', () {
        final y = MetricUtils.calculateCombinedWaveY(50.0, 2.0, 2.0, 1.0, 1.0, 1.0, 0.0, 0.0);
        final expected = MetricUtils.calculateWaveY(50.0, 2.0, 1.0, 1.0, 0.0);
        expect(y, expected);
      });
    });

    group('calculateShadowScaleY', () {
      test('calculates scale Y correctly', () {
        expect(MetricUtils.calculateShadowScaleY(50.0, 100.0), 0.5);
        expect(MetricUtils.calculateShadowScaleY(25.0, 200.0), 0.125);
      });

      test('clamps values between 0.05 and 1.0', () {
        expect(MetricUtils.calculateShadowScaleY(1.0, 100.0), 0.05); // minimum
        expect(MetricUtils.calculateShadowScaleY(200.0, 100.0), 1.0); // maximum
      });

      test('returns 1.0 when height equals base diameter', () {
        expect(MetricUtils.calculateShadowScaleY(100.0, 100.0), 1.0);
      });
    });

    group('calculateOpacityValue', () {
      test('calculates opacity correctly', () {
        expect(MetricUtils.calculateOpacityValue(0.5, 2.0), 1.0); // clamped
        expect(MetricUtils.calculateOpacityValue(0.3, 1.0), 0.3);
        expect(MetricUtils.calculateOpacityValue(1.5, 0.5), 0.75);
      });

      test('clamps values between 0.0 and 1.0', () {
        expect(MetricUtils.calculateOpacityValue(2.0, 1.0), 1.0);
        expect(MetricUtils.calculateOpacityValue(-1.0, 1.0), 0.0);
      });

      test('handles zero intensity correctly', () {
        expect(MetricUtils.calculateOpacityValue(0.8, 0.0), 0.0);
      });
    });
  });
}