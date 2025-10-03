// Metrics available in the dashboard
import 'package:flutter/material.dart';

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
}