import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/utils/metric_utils.dart';

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
  });
}