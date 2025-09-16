import 'package:flutter/material.dart';

class PlantStage {
  final int level;
  final String name;
  final Color stageColor;
  final IconData currentIcon;
  final IconData nextIcon;
  final String description;

  const PlantStage({
    required this.level,
    required this.name,
    required this.stageColor,
    required this.currentIcon,
    required this.nextIcon,
    required this.description,
  });
}

class PlantMetrics {
  final double waterLevel;
  final double phLevel;
  final double nutrientLevel;
  final double plantHealth;

  const PlantMetrics({
    required this.waterLevel,
    required this.phLevel,
    required this.nutrientLevel,
    required this.plantHealth,
  });

  double get averageLevel => (waterLevel + phLevel + nutrientLevel + plantHealth) / 4;
}