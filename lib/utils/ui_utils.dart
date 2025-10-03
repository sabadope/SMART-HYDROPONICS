import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Utility class for UI-related calculations and helpers
class UiUtils {
  /// Calculate tile width for responsive grid layout
  static double calculateTileWidth(double maxWidth, int columns, double spacing) {
    return (maxWidth - spacing * (columns - 1)) / columns;
  }

  /// Calculate progress percentage from value and max
  static double calculateProgress(double value, double maxValue) {
    if (maxValue <= 0) return 0.0;
    return (value / maxValue).clamp(0.0, 1.0);
  }

  /// Calculate circular progress angle in radians
  static double calculateProgressAngle(double progress) {
    return 2 * math.pi * progress.clamp(0.0, 1.0);
  }

  /// Generate evenly spaced positions for items in a circle
  static List<Offset> calculateCircularPositions(
    int count,
    double radius,
    Offset center, {
    double startAngle = 0.0,
  }) {
    if (count <= 0) return [];

    final positions = <Offset>[];
    final angleStep = 2 * math.pi / count;

    for (int i = 0; i < count; i++) {
      final angle = startAngle + i * angleStep;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      positions.add(Offset(x, y));
    }

    return positions;
  }

  /// Calculate responsive padding based on screen size
  static EdgeInsets calculateResponsivePadding(
    double basePadding,
    Size screenSize, {
    double minPadding = 8.0,
    double maxPadding = 32.0,
  }) {
    final scale = math.min(screenSize.width / 400, screenSize.height / 800);
    final padding = basePadding * scale;
    final clamped = padding.clamp(minPadding, maxPadding);
    return EdgeInsets.all(clamped);
  }

  /// Calculate text scale factor for responsive text
  static double calculateResponsiveTextScale(
    double baseScale,
    Size screenSize, {
    double minScale = 0.8,
    double maxScale = 1.5,
  }) {
    final scale = math.min(screenSize.width / 375, screenSize.height / 667);
    final textScale = baseScale * scale;
    return textScale.clamp(minScale, maxScale);
  }

  /// Calculate animation duration based on distance
  static Duration calculateAnimationDuration(double distance, double speed) {
    if (speed <= 0) return const Duration(milliseconds: 300);
    final durationMs = (distance / speed * 1000).round();
    return Duration(milliseconds: durationMs.clamp(100, 2000));
  }

  /// Calculate eased value using cubic ease-out
  static double easeOutCubic(double t) {
    t = t.clamp(0.0, 1.0);
    return 1 - math.pow(1 - t, 3).toDouble();
  }

  /// Calculate color interpolation
  static Color lerpColor(Color a, Color b, double t) {
    t = t.clamp(0.0, 1.0);
    return Color.lerp(a, b, t) ?? a;
  }

  /// Calculate opacity for fade animations
  static double calculateFadeOpacity(double progress, bool fadeIn) {
    if (fadeIn) {
      return progress.clamp(0.0, 1.0);
    } else {
      return (1.0 - progress).clamp(0.0, 1.0);
    }
  }

  /// Calculate scale for bounce animations
  static double calculateBounceScale(double progress, double intensity) {
    progress = progress.clamp(0.0, 1.0);
    final bounce = math.sin(progress * math.pi) * intensity;
    return 1.0 + bounce * (1.0 - progress);
  }
}