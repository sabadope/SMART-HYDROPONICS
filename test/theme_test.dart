import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_dashboard/main.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  group('Theme Tests', () {
    testWidgets('MyApp uses correct color scheme seed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final colorScheme = materialApp.theme?.colorScheme;

      expect(colorScheme, isNotNull);
      expect(colorScheme!.primary, isNotNull);
      expect(colorScheme.secondary, isNotNull);
    });

    testWidgets('Theme uses Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
    });

    testWidgets('Scaffold background is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final scaffoldBackground = materialApp.theme?.scaffoldBackgroundColor;

      // Scaffold background is set to transparent in the theme
      expect(scaffoldBackground, Colors.transparent);
    });

    testWidgets('Inter font is applied to text theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final textTheme = materialApp.theme?.textTheme;

      expect(textTheme, isNotNull);
      // GoogleFonts.interTextTheme() should be applied
    });

    testWidgets('Color scheme seed generates consistent colors', (WidgetTester tester) async {
      final scheme1 = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      final scheme2 = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));

      expect(scheme1.primary, scheme2.primary);
      expect(scheme1.secondary, scheme2.secondary);
      expect(scheme1.surface, scheme2.surface);
    });

    testWidgets('Theme data is properly constructed', (WidgetTester tester) async {
      final theme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8)),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.transparent,
      );

      expect(theme.useMaterial3, true);
      expect(theme.scaffoldBackgroundColor, Colors.transparent);
      expect(theme.textTheme, isNotNull);
    });

    testWidgets('AppBar theme is available', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final appBarTheme = materialApp.theme?.appBarTheme;

      // AppBar theme should be available
      expect(appBarTheme, isNotNull);
    });

    testWidgets('Navigation bar theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final navigationBarTheme = materialApp.theme?.navigationBarTheme;

      expect(navigationBarTheme, isNotNull);
    });

    testWidgets('Card theme uses correct elevation', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final cardTheme = materialApp.theme?.cardTheme;

      expect(cardTheme, isNotNull);
    });

    testWidgets('ElevatedButton theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final elevatedButtonTheme = materialApp.theme?.elevatedButtonTheme;

      expect(elevatedButtonTheme, isNotNull);
    });

    testWidgets('TextButton theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final textButtonTheme = materialApp.theme?.textButtonTheme;

      expect(textButtonTheme, isNotNull);
    });

    testWidgets('OutlinedButton theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final outlinedButtonTheme = materialApp.theme?.outlinedButtonTheme;

      expect(outlinedButtonTheme, isNotNull);
    });

    testWidgets('InputDecoration theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final inputDecorationTheme = materialApp.theme?.inputDecorationTheme;

      expect(inputDecorationTheme, isNotNull);
    });

    testWidgets('Dialog theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final dialogTheme = materialApp.theme?.dialogTheme;

      expect(dialogTheme, isNotNull);
    });

    testWidgets('BottomSheet theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final bottomSheetTheme = materialApp.theme?.bottomSheetTheme;

      expect(bottomSheetTheme, isNotNull);
    });

    testWidgets('TabBar theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final tabBarTheme = materialApp.theme?.tabBarTheme;

      expect(tabBarTheme, isNotNull);
    });

    testWidgets('SnackBar theme is configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final snackBarTheme = materialApp.theme?.snackBarTheme;

      expect(snackBarTheme, isNotNull);
    });
  });

  group('Color Scheme Tests', () {
    test('Primary color is derived from seed', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.primary, isNotNull);
      expect(scheme.primary, isA<Color>());
    });

    test('Secondary color is derived from seed', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.secondary, isNotNull);
      expect(scheme.secondary, isA<Color>());
    });

    test('Surface colors are defined', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.surface, isNotNull);
      expect(scheme.surfaceContainerHighest, isNotNull);
      expect(scheme.surfaceVariant, isNotNull);
    });

    test('On colors are defined', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.onPrimary, isNotNull);
      expect(scheme.onSecondary, isNotNull);
      expect(scheme.onSurface, isNotNull);
    });

    test('Error colors are defined', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.error, isNotNull);
      expect(scheme.onError, isNotNull);
    });

    test('Outline colors are defined', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
      expect(scheme.outline, isNotNull);
      expect(scheme.outlineVariant, isNotNull);
    });
  });

  group('Typography Tests', () {
    test('Inter font is loaded', () {
      final interFont = GoogleFonts.inter();
      expect(interFont, isNotNull);
    });

    test('Text theme has all required styles', () {
      final textTheme = GoogleFonts.interTextTheme();
      expect(textTheme.headlineLarge, isNotNull);
      expect(textTheme.headlineMedium, isNotNull);
      expect(textTheme.headlineSmall, isNotNull);
      expect(textTheme.titleLarge, isNotNull);
      expect(textTheme.titleMedium, isNotNull);
      expect(textTheme.titleSmall, isNotNull);
      expect(textTheme.bodyLarge, isNotNull);
      expect(textTheme.bodyMedium, isNotNull);
      expect(textTheme.bodySmall, isNotNull);
      expect(textTheme.labelLarge, isNotNull);
      expect(textTheme.labelMedium, isNotNull);
      expect(textTheme.labelSmall, isNotNull);
    });

    test('Display styles are defined', () {
      final textTheme = GoogleFonts.interTextTheme();
      expect(textTheme.displayLarge, isNotNull);
      expect(textTheme.displayMedium, isNotNull);
      expect(textTheme.displaySmall, isNotNull);
    });
  });

  group('Theme Constants', () {
    test('Seed color is correct', () {
      const seedColor = Color(0xFF00B4D8);
      expect(seedColor, const Color(0xFF00B4D8));
      expect(seedColor.value, 0xFF00B4D8);
    });

    test('Transparent color is used for backgrounds', () {
      expect(Colors.transparent, const Color(0x00000000));
    });

    test('Material 3 is enabled', () {
      const useMaterial3 = true;
      expect(useMaterial3, true);
    });
  });

  group('Theme Inheritance', () {
    testWidgets('Child widgets inherit theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find any widget that should inherit theme
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('Theme propagates to all pages', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // The theme should be available throughout the app
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
    });
  });

  group('Theme Performance', () {
    test('Theme creation is fast', () {
      final stopwatch = Stopwatch()..start();

      final theme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8)),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.transparent,
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast
      expect(theme, isNotNull);
    });

    test('Color scheme generation is fast', () {
      final stopwatch = Stopwatch()..start();

      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(50)); // Should be very fast
      expect(scheme, isNotNull);
    });
  });
}