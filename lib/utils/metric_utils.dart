// Metrics available in the dashboard
import 'package:flutter/material.dart';
import 'dart:math' as math;

enum MetricType { water, nutrients, ph }

class MetricConfig {
  final MetricType type;
  final String label;
  final String resultLabel;
  final String valueText;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final double progress; // 0..1 visual emphasis
  final String statusText;

  const MetricConfig({
    required this.type,
    required this.label,
    required this.resultLabel,
    required this.valueText,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.progress,
    required this.statusText,
  });
}

class MetricUtils {
  static MetricConfig configFor(MetricType type) {
    switch (type) {
      case MetricType.water:
        return const MetricConfig(
          type: MetricType.water,
          label: 'Water',
          resultLabel: 'Water level',
          valueText: '72%',
          icon: Icons.water_drop,
          startColor: Color(0xFF00B4D8),
          endColor: Color(0xFF48CAE4),
          progress: 0.72,
          statusText: 'Optimal',
        );
      case MetricType.nutrients:
        return const MetricConfig(
          type: MetricType.nutrients,
          label: 'Nutrients',
          resultLabel: 'Nutrients level',
          valueText: '480 ppm',
          icon: Icons.biotech,
          startColor: Color(0xFF80ED99),
          endColor: Color(0xFF57CC99),
          progress: 0.48,
          statusText: 'Good',
        );
      case MetricType.ph:
        return const MetricConfig(
          type: MetricType.ph,
          label: 'pH',
          resultLabel: 'pH level',
          valueText: '6.5',
          icon: Icons.speed,
          startColor: Color(0xFFFFAFCC),
          endColor: Color(0xFFFFC8DD),
          progress: 0.46, // 6.5/14 approx
          statusText: 'Slightly acidic',
        );
    }
  }

  static Color statusToColor(String statusLabel) {
    final String label = statusLabel.toLowerCase().trim();
    if (label.contains('poor') || label.contains('critical') || label.contains('low')) {
      return const Color(0xFFEF4444); // red
    }
    if (label.contains('warn') || label.contains('caution') || label.contains('medium')) {
      return const Color(0xFFF59E0B); // yellow/amber
    }
    if (label.contains('excellent') || label.contains('normal') || label.contains('good') || label.contains('optimal') || label.contains('ok')) {
      return const Color(0xFF16A34A); // green
    }
    return const Color(0xFF16A34A);
  }

  static double calculateShadowOpacity(double value, double intensity) {
    return (value * intensity).clamp(0.0, 1.0);
  }

  // Math utilities for animations and effects
  static double fract(double x) => x - x.floorToDouble();

  static double rand01(int i, double salt) {
    final double v = math.sin((i + 1) * 12.9898 + salt * 78.233) * 43758.5453123;
    return fract(v.abs());
  }

  // Wave calculation utilities
  static double calculateWaveAmplitude(double baseAmplitude, double variation, int index, double salt) {
    return baseAmplitude + variation * rand01(index, salt);
  }

  static double calculateBubblePosition(double time, double speed, double offset, double size) {
    return (time * speed + offset) % (size + 100.0) - 50.0;
  }

  // Wave calculation utilities
  static double calculateWaveNumber(double wavelength) {
    return 2 * math.pi / wavelength;
  }

  static double calculateWaveY(double baseY, double amplitude, double waveNumber, double x, double phase) {
    return baseY + amplitude * math.sin(waveNumber * x + phase);
  }

  static double calculateCombinedWaveY(double baseY, double amplitude1, double amplitude2,
      double waveNumber1, double waveNumber2, double x, double phase1, double phase2) {
    final y1 = calculateWaveY(baseY, amplitude1, waveNumber1, x, phase1);
    final y2 = calculateWaveY(baseY, amplitude2, waveNumber2, x, phase2);
    return math.min(y1, y2);
  }

  // Shadow scaling utilities
  static double calculateShadowScaleY(double height, double baseDiameter) {
    final scaleY = (height / baseDiameter).clamp(0.05, 1.0);
    return scaleY;
  }

  static double calculateOpacityValue(double value, double intensity) {
    return (value * intensity).clamp(0.0, 1.0);
  }
}