import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF00B4D8),
    brightness: Brightness.light,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: _colorScheme.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: _colorScheme.onSurface,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: _colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card Theme - Temporarily removed due to API compatibility
      // cardTheme: CardThemeData(
      //   elevation: 4,
      //   shadowColor: _colorScheme.shadow.withValues(alpha: 0.1),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      // ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _colorScheme.primary,
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.inter(
          color: _colorScheme.onSurfaceVariant,
        ),
        hintStyle: GoogleFonts.inter(
          color: _colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: _colorScheme.surfaceContainerHighest,
        circularTrackColor: _colorScheme.surfaceContainerHighest,
      ),
    );
  }

  // App Colors
  static const Color primaryColor = Color(0xFF00B4D8);
  static const Color secondaryColor = Color(0xFF16A34A);
  static const Color accentColor = Color(0xFFF59E0B);

  // Background Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE9FFF4),
      Color(0xFFBFF3D8),
      Color(0xFF77D9AA),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Glass Morphism Colors
  static const Color glassBackground = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF);

  // Status Colors
  static const Color successColor = Color(0xFF16A34A);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF00B4D8);
}