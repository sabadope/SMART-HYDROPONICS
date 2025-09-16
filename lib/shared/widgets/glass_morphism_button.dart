import 'package:flutter/material.dart';

class GlassMorphismButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback? onTap;

  const GlassMorphismButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isSelected
                ? [selectedColor, selectedColor.withValues(alpha: 0.8)]
                : [Colors.white.withValues(alpha: 0.95), Colors.white.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSelected
                ? selectedColor.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(-3, -3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 0.8,
              colors: [
                Colors.white.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[800],
            size: 24,
          ),
        ),
      ),
    );
  }
}