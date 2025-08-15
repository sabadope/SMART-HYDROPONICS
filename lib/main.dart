import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8));
    return MaterialApp(
      title: 'Hydro Monitor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: colorScheme.surface,
      ),
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Metrics available in the dashboard
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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  MetricType selected = MetricType.water;

  MetricConfig configFor(MetricType type) {
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

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final MetricConfig selectedConfig = configFor(selected);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hydro Monitor',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Three modern selectable cards (boxes)
              Row(
                children: [
                  Expanded(
                    child: LevelBox(
                      label: configFor(MetricType.water).label,
                      icon: configFor(MetricType.water).icon,
                      startColor: configFor(MetricType.water).startColor,
                      endColor: configFor(MetricType.water).endColor,
                      isSelected: selected == MetricType.water,
                      onTap: () => setState(() => selected = MetricType.water),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LevelBox(
                      label: configFor(MetricType.nutrients).label,
                      icon: configFor(MetricType.nutrients).icon,
                      startColor: configFor(MetricType.nutrients).startColor,
                      endColor: configFor(MetricType.nutrients).endColor,
                      isSelected: selected == MetricType.nutrients,
                      onTap: () => setState(() => selected = MetricType.nutrients),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LevelBox(
                      label: configFor(MetricType.ph).label,
                      icon: configFor(MetricType.ph).icon,
                      startColor: configFor(MetricType.ph).startColor,
                      endColor: configFor(MetricType.ph).endColor,
                      isSelected: selected == MetricType.ph,
                      onTap: () => setState(() => selected = MetricType.ph),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                'Results',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Emphasized single result for the selected metric
              MetricDetailCard(config: selectedConfig),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const LevelBox({
    super.key,
    required this.label,
    required this.icon,
    required this.startColor,
    required this.endColor,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [startColor, endColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    icon,
                    size: 96,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 28),
                          const SizedBox(width: 8),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check, color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text('Selected', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MetricDetailCard extends StatelessWidget {
  final MetricConfig config;
  const MetricDetailCard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [config.startColor, config.endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.resultLabel,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      config.valueText,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            config.type == MetricType.water
                                ? Icons.opacity
                                : config.type == MetricType.nutrients
                                    ? Icons.science
                                    : Icons.balance,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            config.statusText,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                config.icon,
                color: Colors.white.withValues(alpha: 0.25),
                size: 72,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GradientProgressBar(
            progress: config.progress,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            fillColor: Colors.white,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%'.padLeft(3, ' '),
                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                '100%'.padLeft(5, ' '),
                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double progress; // 0..1
  final Color backgroundColor;
  final Color fillColor;
  const _GradientProgressBar({required this.progress, required this.backgroundColor, required this.fillColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            height: 10,
            color: backgroundColor,
          ),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: fillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const ResultTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
