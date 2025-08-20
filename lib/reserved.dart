import 'dart:ui';
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
      home: const RootScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selectedIndex = 0;
  bool _isFirstTimeUser = true; // Track first-time user experience

  List<Widget> get _pages => const [
    DashboardPage(),
    PlantsPage(),
    InsightsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Richer green background with subtle glows
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE9FFF4), Color(0xFFBFF3D8), Color(0xFF77D9AA)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Soft radial glows for depth (not animations)
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.22), Colors.transparent],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFF57CC99).withValues(alpha: 0.24), Colors.transparent],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ],
      ),

      bottomNavigationBar: Container(
        height: 120,
        color: Colors.transparent,
        child: Stack(
          children: [
            // Left capsule tab - Home with glass morphism
            Positioned(
              bottom: 25,
              left: 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                    _isFirstTimeUser = false; // User has interacted, no longer first-time
                  });
                },
                child: CapsuleGlassMorphismTab(
                  icon: Icons.home,
                  isSelected: _isFirstTimeUser ? false : _selectedIndex == 0,
                  selectedColor: const Color(0xFF4ADE80),
                ),
              ),
            ),
            // Right capsule tab - Bar Chart with glass morphism
            Positioned(
              bottom: 25,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                    _isFirstTimeUser = false; // User has interacted, no longer first-time
                  });
                },
                child: CapsuleGlassMorphismTab(
                  icon: Icons.bar_chart,
                  isSelected: _isFirstTimeUser ? false : _selectedIndex == 2,
                  selectedColor: const Color(0xFF4ADE80),
                ),
              ),
            ),
            // Enhanced 3D glass morphism CTA button with plant icon
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _isFirstTimeUser = false; // User has interacted, no longer first-time
                    });
                  },
                  child: GlassMorphismCTAButton(
                    icon: Icons.eco,
                    isSelected: _isFirstTimeUser ? true : _selectedIndex == 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class GlossyIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  const GlossyIcon({super.key, required this.icon, required this.size, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    final double glowSize = size * 1.1;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        IgnorePointer(
          child: Container(
            width: glowSize,
            height: glowSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x66FFFFFF), blurRadius: 10, spreadRadius: 2),
                BoxShadow(color: Color(0x33FFFFFF), blurRadius: 20, spreadRadius: 6),
              ],
            ),
          ),
        ),
        // Icon
        Icon(icon, size: size, color: color),
        // Inner glow highlight
        IgnorePointer(
          child: Container(
            width: glowSize,
            height: glowSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withValues(alpha: 0.22), Colors.transparent],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
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

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  MetricType selected = MetricType.water;
  late final AnimationController _floatController;
  late final Animation<double> _float;
  late final Animation<double> _pulse;

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
    final MetricConfig selectedConfig = configFor(selected);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Hydro Monitor',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _float.value),
                child: Transform.scale(
                  scale: 1.0 + (_pulse.value * 0.02),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // soft drop shadow ellipse under the image


                      // new sharp oval gradient shadow (pure Dart)
                      Positioned(
                        bottom: -10, // tweak to sit just beneath the image
                        child: SharpOvalShadow(
                          width: 200,  // match your lettuce width visually
                          height: 52,  // slim oval; increase for thicker shadow
                          intensity: 1.0,
                        ),
                      ),
                      Image.asset('assets/images/lettuce_una.png'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    _pulse = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
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

class PlantsPage extends StatelessWidget {
  const PlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Plants', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF80ED99), Color(0xFF57CC99)],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlossyIcon(icon: Icons.eco, size: 48, color: Colors.white),
              const SizedBox(height: 10),
              Text('Your plants overview', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              Text('Coming soon', style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
        ),
      ),
    );
  }
}

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Insights', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9775FA), Color(0xFF5C7CFA)],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bar_chart, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              Text('Analytics & trends', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              Text('Coming soon', style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
        ),
      ),
    );
  }
}

class NotchedNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Draw bottom line
    path.lineTo(size.width, size.height);

    // Draw right side curve
    path.lineTo(size.width, 32);
    path.quadraticBezierTo(size.width, 0, size.width - 32, 0);

    // Draw top line with notch
    path.lineTo(size.width / 2 + 30, 0);

    // Draw notch (concave curve)
    path.quadraticBezierTo(size.width / 2, -8, size.width / 2 - 30, 0);

    // Draw left side curve
    path.lineTo(32, 0);
    path.quadraticBezierTo(0, 0, 0, 32);

    // Close the path
    path.close();

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawPath(path, shadowPaint);

    // Draw main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassMorphismNotchedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create the main glass morphism effect with enhanced depth
    final Paint glassPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.98),
          Colors.white.withValues(alpha: 0.92),
          Colors.white.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.78),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path();

    // Start from bottom left with rounded corner
    path.moveTo(0, size.height - 8);
    path.quadraticBezierTo(0, size.height, 8, size.height);

    // Draw bottom line
    path.lineTo(size.width - 8, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 8);

    // Draw right side curve
    path.lineTo(size.width, 32);
    path.quadraticBezierTo(size.width, 0, size.width - 32, 0);

    // Draw top line with enhanced notch
    path.lineTo(size.width / 2 + 35, 0);

    // Draw enhanced notch (deeper concave curve)
    path.quadraticBezierTo(size.width / 2, -12, size.width / 2 - 35, 0);

    // Draw left side curve
    path.lineTo(32, 0);
    path.quadraticBezierTo(0, 0, 0, 32);

    // Close the path
    path.close();

    // Draw multiple shadow layers for enhanced depth
    final Paint shadowPaint1 = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    final Paint shadowPaint2 = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final Paint shadowPaint3 = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Draw shadows in order (farthest to closest)
    canvas.drawPath(path, shadowPaint1);
    canvas.drawPath(path, shadowPaint2);
    canvas.drawPath(path, shadowPaint3);

    // Draw main glass shape
    canvas.drawPath(path, glassPaint);

    // Draw subtle border
    canvas.drawPath(path, borderPaint);

    // Add sophisticated inner highlights for premium glass effect
    final Paint highlightPaint1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.center,
        colors: [
          Colors.white.withValues(alpha: 0.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint highlightPaint2 = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 0.6,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw highlights
    canvas.drawPath(path, highlightPaint1);
    canvas.drawPath(path, highlightPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class GlassMorphismCTAButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const GlassMorphismCTAButton({
    super.key,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4ADE80).withValues(alpha: 0.98), // Bright joyful green
            const Color(0xFF22C55E).withValues(alpha: 0.95), // Medium green
            const Color(0xFF16A34A).withValues(alpha: 0.90), // Darker green
            const Color(0xFF15803D).withValues(alpha: 0.85), // Deepest green
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 3,
        ),
        boxShadow: [
          // Primary green glow
          BoxShadow(
            color: const Color(0xFF4ADE80).withValues(alpha: 0.5),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 3,
          ),
          // Secondary green glow
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: 5,
          ),
          // White highlight shadow
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(-4, -4),
            spreadRadius: 2,
          ),
          // Deep shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 0.7,
            colors: [
              Colors.white.withValues(alpha: 0.5),
              Colors.white.withValues(alpha: 0.2),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main icon
            Icon(
              icon,
              color: Colors.white,
              size: 36,
            ),
            // Subtle inner glow
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    const Color(0xFF4ADE80).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CapsuleGlassMorphismTab extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;

  const CapsuleGlassMorphismTab({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
            selectedColor.withValues(alpha: 0.95),
            selectedColor.withValues(alpha: 0.85),
          ]
              : [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.85),
          ],
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
          borderRadius: BorderRadius.circular(28),
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
    );
  }
}


/// A pure-Dart sharp oval gradient shadow (no image assets).
/// Place beneath a floating object to simulate a crisp product-shot shadow.

class SharpOvalShadow extends StatelessWidget {
  const SharpOvalShadow({
    super.key,
    this.width = 220,
    this.height = 58,
    this.intensity = 1.0,
  });

  final double width;
  final double height;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final double baseDiameter = width;
    final double scaleY = (height / baseDiameter).clamp(0.05, 1.0);

    // Opacity ramp scaled by intensity, clamped to [0,1].
    double _o(double v) => (v * intensity).clamp(0.0, 1.0);

    return IgnorePointer(
      child: Transform.scale(
        scaleY: scaleY,
        child: Container(
          width: baseDiameter,
          height: baseDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(0.15, 0.05),
              colors: [
                Colors.black.withOpacity(_o(0.70)), // inner core
                Colors.black.withOpacity(_o(0.40)),
                Colors.black.withOpacity(_o(0.12)),
                Colors.black.withOpacity(0.0),      // edge
              ],
              stops: const [0.30, 0.60, 0.85, 1.00],
            ),
          ),
        ),
      ),
    );
  }
}

