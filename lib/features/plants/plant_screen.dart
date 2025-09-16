import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

// Data model for plant metrics
class PlantMetric {
  final String title;
  final String value;
  final String statusLabel;
  final Color statusColor;
  final IconData bgIcon;
  final Color startColor;
  final Color endColor;
  final double progress;

  const PlantMetric({
    required this.title,
    required this.value,
    required this.statusLabel,
    required this.statusColor,
    required this.bgIcon,
    required this.startColor,
    required this.endColor,
    required this.progress,
  });
}

// Plant growth stages
class PlantStage {
  final int level;
  final String name;
  final IconData currentIcon;
  final IconData nextIcon;
  final Color stageColor;

  const PlantStage({
    required this.level,
    required this.name,
    required this.currentIcon,
    required this.nextIcon,
    required this.stageColor,
  });
}

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  // Available metrics
  late final List<PlantMetric> _metrics;
  PlantMetric? _selectedMetric;

  // Plant growth system
  late final List<PlantStage> _plantStages;
  int _currentStage = 1; // Current plant stage (1-4)
  double _levelProgress = 0.95; // Progress within current stage (0-1) - Set to 95% to trigger two-tone effect

  @override
  void initState() {
    super.initState();
    _metrics = [
      const PlantMetric(
        title: 'Plant Health',
        value: '86%',
        statusLabel: 'Excellent',
        statusColor: Color(0xFF16A34A),
        bgIcon: Icons.local_florist,
        startColor: Color(0xFF80ED99),
        endColor: Color(0xFF57CC99),
        progress: 0.86,
      ),
      const PlantMetric(
        title: 'Water Level',
        value: '72%',
        statusLabel: 'Normal',
        statusColor: Color(0xFF16A34A),
        bgIcon: Icons.water_drop,
        startColor: Color(0xFF00B4D8),
        endColor: Color(0xFF48CAE4),
        progress: 0.72,
      ),
      const PlantMetric(
        title: 'pH Level',
        value: '46%',
        statusLabel: 'Normal',
        statusColor: Color(0xFF16A34A),
        bgIcon: Icons.speed,
        startColor: Color(0xFFFFAFCC),
        endColor: Color(0xFFFFC8DD),
        progress: 0.46,
      ),
      const PlantMetric(
        title: 'Nutrients Level',
        value: '48%',
        statusLabel: 'Normal',
        statusColor: Color(0xFF16A34A),
        bgIcon: Icons.biotech,
        startColor: Color(0xFFFDE68A),
        endColor: Color(0xFFF59E0B),
        progress: 0.48,
      ),
    ];

    _plantStages = [
      const PlantStage(
        level: 1,
        name: 'Seed',
        currentIcon: Icons.grain, // Plant seed icon
        nextIcon: Icons.spa, // Seed with roots (sprout)
        stageColor: Color(0xFF8B5CF6),
      ),
      const PlantStage(
        level: 2,
        name: 'Sprout',
        currentIcon: Icons.spa, // Seed with roots
        nextIcon: Icons.grass, // Small plant
        stageColor: Color(0xFF06B6D4),
      ),
      const PlantStage(
        level: 3,
        name: 'Growth',
        currentIcon: Icons.grass, // Plant
        nextIcon: Icons.local_florist, // Big plant
        stageColor: Color(0xFF10B981),
      ),
      const PlantStage(
        level: 4,
        name: 'Harvest',
        currentIcon: Icons.local_florist, // Big plant ready to harvest
        nextIcon: Icons.celebration, // Harvest celebration
        stageColor: Color(0xFFF59E0B),
      ),
    ];

    // Default to first metric
    _selectedMetric = _metrics[0];
  }

  void _onMetricSelected(PlantMetric metric) {
    setState(() {
      _selectedMetric = metric;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Plant Center', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient to match the app's aesthetic
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
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const double spacing = 16;
                            const int columns = 2;
                            final double tileWidth = (constraints.maxWidth - spacing) / columns;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              alignment: WrapAlignment.center,
                              children: _metrics.map((metric) {
                                return SizedBox(
                                  width: tileWidth,
                                  child: _InfoSquare(
                                    metric: metric,
                                    isSelected: _selectedMetric == metric,
                                    onTap: () => _onMetricSelected(metric),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    // Quick Action Button - Water Level Only
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Center(
                        child: _QuickActionButton(
                          icon: Icons.water_drop,
                          color: const Color(0xFF00B4D8),
                          onTap: () => _onMetricSelected(_metrics[1]), // Water Level
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Enhanced Plant Health Progress Bar with Growth Stages
                    Container(
                      margin: const EdgeInsets.only(bottom: 135), // Easy spacing control
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Enhanced Progress Bar with Plant Stages (no text display)
                          _PlantGrowthProgressBar(
                            selectedMetric: _selectedMetric,
                            currentStage: _plantStages[_currentStage - 1],
                            nextStage: _currentStage < _plantStages.length
                                ? _plantStages[_currentStage]
                                : _plantStages.last,
                            levelProgress: _levelProgress,
                            currentStageLevel: _currentStage,
                          ),
                        ],
                      ),
                    ),
                    // Replace previous divider with glossy divider with center hole
                    const GlossyDivider(height: 125.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSquare extends StatelessWidget {
  const _InfoSquare({
    required this.metric,
    required this.isSelected,
    required this.onTap,
  });

  final PlantMetric metric;
  final bool isSelected;
  final VoidCallback onTap;

  Color _statusToColor(BuildContext context) {
    final String label = metric.statusLabel.toLowerCase().trim();
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

  @override
  Widget build(BuildContext context) {
    final Color computedStatusColor = _statusToColor(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [metric.startColor, metric.endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // Primary color glow
            BoxShadow(
              color: metric.endColor.withValues(alpha: 0.35),
              blurRadius: 22,
              offset: const Offset(0, 10),
              spreadRadius: 1,
            ),
            // Secondary color glow
            BoxShadow(
              color: metric.startColor.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 14),
              spreadRadius: 2,
            ),
            // White highlight shadow
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(-3, -3),
              spreadRadius: 1,
            ),
            // Deep shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 28,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
            // Selection indicator
            if (isSelected)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.6),
                blurRadius: 0,
                spreadRadius: 2,
              ),
          ],
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.6),
            width: isSelected ? 3.0 : 2.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background watermark icon
            Positioned(
              right: -6,
              bottom: -6,
              child: Icon(
                metric.bgIcon,
                size: 84,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
            // Inner radial highlight overlay (premium gloss)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.0,
                      colors: [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.20),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    metric.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              metric.statusLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: computedStatusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            _MiniProgressBar(
                              progress: metric.progress,
                              backgroundColor: Colors.white.withValues(alpha: 0.20),
                              fillColor: computedStatusColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        metric.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: computedStatusColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar({
    required this.progress,
    required this.backgroundColor,
    required this.fillColor,
  });

  final double progress; // 0..1
  final Color backgroundColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(height: 6, color: backgroundColor),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(height: 6, color: fillColor),
          ),
        ],
      ),
    );
  }
}

class GlossyDivider extends StatefulWidget {
  const GlossyDivider({super.key, this.height = 125.0});

  final double height;

  @override
  State<GlossyDivider> createState() => _GlossyDividerState();
}

class _GlossyDividerState extends State<GlossyDivider> with SingleTickerProviderStateMixin {
  ui.Image? _holeImage;
  ui.Image? _lettuceImage;

  late AnimationController _floatController;
  late Animation<double> _float;

  late AnimationController _waveController;
  late Animation<double> _wavePhase;

  // Remove bubble controller, use timer instead
  late Timer _bubbleTimer;
  double _bubbleTime = 0.0; // continuous time in seconds

  @override
  void initState() {
    super.initState();
    _loadHoleImage();
    _loadLettuceImage();

    // Float (up/down) loops forever with reverse
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6)
        .animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    // Waves (phase 0..2π) loop forever
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
    _wavePhase = Tween<double>(begin: 0.0, end: math.pi * 2)
        .animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    // Bubbles: continuous timer (no duration, no reset)
    _bubbleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          _bubbleTime += 0.016; // ~60fps
        });
      }
    });
  }

  Future<void> _loadHoleImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/hole.png');
      final Uint8List bytes = data.buffer.asUint8List();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        if (mounted) setState(() => _holeImage = img);
      });
    } catch (_) {}
  }

  Future<void> _loadLettuceImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/lettuce_pangapat.png');
      final Uint8List bytes = data.buffer.asUint8List();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        if (mounted) setState(() => _lettuceImage = img);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _floatController.dispose();
    _waveController.dispose();
    _bubbleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: CustomPaint(
        painter: _GlossyDividerPainter(
          strokeWidth: 10.0,
          holeImage: _holeImage,
          lettuceImage: _lettuceImage,
          float: _float,
          wave: _wavePhase,
          bubbleTime: _bubbleTime, // Pass continuous time instead of phase
        ),
      ),
    );
  }
}

class _GlossyDividerPainter extends CustomPainter {
  _GlossyDividerPainter({
    required this.strokeWidth,
    required this.holeImage,
    required this.lettuceImage,
    required this.float,
    required this.wave,
    required this.bubbleTime,
  }) : super(repaint: Listenable.merge([float, wave]));

  final double strokeWidth;
  final ui.Image? holeImage;
  final ui.Image? lettuceImage;
  final Animation<double>? float;
  final Animation<double>? wave;
  final double bubbleTime;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Offset.zero & size;

    // Background gradient
    final Paint bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0x80FFFFFF), Color(0x47FFFFFF), Color(0x1AFFFFFF)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // Water with submerged bubbles
    _drawWaterAndBubbles(canvas, size, wave?.value ?? 0.0, bubbleTime);

    // Stroke with center gap
    final double rawGap = size.width * 0.22;
    final double gapWidth = rawGap.clamp(48.0, 180.0);
    final double leftEnd = (size.width - gapWidth) / 2.0;
    final double rightStart = leftEnd + gapWidth;

    final Paint baseTopRectPaint = Paint()..color = const Color(0xCCFFFFFF);
    final Rect topLeftRect = Rect.fromLTWH(0, 0, leftEnd, strokeWidth);
    final Rect topRightRect = Rect.fromLTWH(rightStart, 0, size.width - rightStart, strokeWidth);
    canvas.drawRect(topLeftRect, baseTopRectPaint);
    canvas.drawRect(topRightRect, baseTopRectPaint);

    final double baseY = strokeWidth / 2;

    final Paint blurStroke1 = Paint()
      ..color = const Color(0x55FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), blurStroke1);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), blurStroke1);

    final Paint midRounded = Paint()
      ..color = const Color(0xE6FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), midRounded);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), midRounded);

    final Paint blurStroke2 = Paint()
      ..color = const Color(0x88FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), blurStroke2);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), blurStroke2);

    // Images (hole fixed, lettuce floats in front)
    final double desiredWidth = math.min(360.0, size.width * 0.70);
    final double holeAspect = holeImage != null ? (holeImage!.width / holeImage!.height) : 1.0;
    final double drawWidth = desiredWidth;
    final double drawHeight = drawWidth / holeAspect;

    final Rect dstHole = Rect.fromCenter(
      center: Offset(size.width / 2, baseY),
      width: drawWidth,
      height: drawHeight,
    );

    final double yFloat = baseY + (float?.value ?? 0.0);
    final Rect dstLettuce = Rect.fromCenter(
      center: Offset(size.width / 2, yFloat),
      width: drawWidth,
      height: drawHeight,
    );

    if (holeImage != null) {
      final Rect srcH = Rect.fromLTWH(0, 0, holeImage!.width.toDouble(), holeImage!.height.toDouble());
      canvas.drawImageRect(holeImage!, srcH, dstHole, Paint()..filterQuality = FilterQuality.high);
    }
    if (lettuceImage != null) {
      final Rect srcL = Rect.fromLTWH(0, 0, lettuceImage!.width.toDouble(), lettuceImage!.height.toDouble());
      canvas.drawImageRect(lettuceImage!, srcL, dstLettuce, Paint()..filterQuality = FilterQuality.high);
    }

    // Gleams/bloom
    final Paint gleam1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x2FFFFFFF), Color(0x14FFFFFF), Color(0x00FFFFFF)],
        stops: [0.0, 0.15, 0.45],
      ).createShader(bounds);
    canvas.drawRect(bounds, gleam1);

    final Paint gleam2 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
        stops: [0.0, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, gleam2);

    final Paint bloom = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 0.9,
        colors: [const Color(0x33FFFFFF), const Color(0x00FFFFFF)],
        stops: const [0.0, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, bloom);
  }

  // Water + bubbles + TWO-TONE layers
  void _drawWaterAndBubbles(Canvas canvas, Size size, double wavePhase, double bubbleTimeSec) {
    final double baseY = strokeWidth * 1.8;

    Path _buildWave(double amplitude1, double amplitude2, double wavelength1, double wavelength2, double phaseShift) {
      final double k1 = 2 * math.pi / wavelength1;
      final double k2 = 2 * math.pi / wavelength2;

      final Path path = Path()..moveTo(0, baseY);
      for (double x = 0; x <= size.width; x += 2.0) {
        final double y1 = baseY + amplitude1 * math.sin(k1 * x + wavePhase + phaseShift);
        final double y2 = baseY + amplitude2 * math.sin(k2 * x + wavePhase + math.pi / 2 + phaseShift);
        final double ySurface = math.min(y1, y2);
        path.lineTo(x, ySurface);
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      return path;
    }

    // --- MAIN WAVE (light cyan → cyan → light cyan) ---
    final Path waveMain = _buildWave(6.0, 3.5, size.width * 0.8, size.width * 0.5, 0);
    final Paint mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0077B6).withOpacity(0.7), // deep
          const Color(0xFF00B4D8).withOpacity(0.75), // cyan
          const Color(0xFF90E0EF).withOpacity(0.7), // light cyan
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, baseY, size.width, size.height));
    canvas.drawPath(waveMain, mainPaint);

    // --- SECONDARY WAVE (deep → cyan → light cyan) ---
    final Path waveSecondary = _buildWave(8.0, 4.0, size.width * 0.9, size.width * 0.55, math.pi / 2);
    final Paint secondaryPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00B4D8).withOpacity(0.7), // cyan
          const Color(0xFF00B4D8).withOpacity(0.7), // cyan
          const Color(0xFF90E0EF).withOpacity(0.55), // light cyan
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, baseY, size.width, size.height));
    canvas.drawPath(waveSecondary, secondaryPaint);

    // Clip with main path for bubbles
    canvas.save();
    canvas.clipPath(waveMain);

    final Paint bubblePaint = Paint()..style = PaintingStyle.fill;
    final Paint highlightPaint = Paint()..color = const Color(0x66FFFFFF);

    const int bubbleCount = 18;
    for (int i = 0; i < bubbleCount; i++) {
      final double rColor = _rand01(i, 0.11);
      final bool isPH = rColor < 0.5;
      final bool altTone = _rand01(i, 0.12) < 0.5;
      final Color color = isPH
          ? (altTone ? const Color(0xFFFFC8DD) : const Color(0xFFFFAFCC))
          : (altTone ? const Color(0xFFF59E0B) : const Color(0xFFFDE68A));

      final double radius = 4.0 + 5.0 * _rand01(i, 0.21);
      final double speedPxPerSec = 60.0 + 40.0 * _rand01(i, 0.31);
      final double offsetPx = _rand01(i, 0.41) * size.width;
      final double lane = -20.0 * _rand01(i, 0.51) - 3.0;

      final double xBase = (bubbleTimeSec * speedPxPerSec + offsetPx) % (size.width + 100.0) - 50.0;

      if (xBase >= -radius && xBase <= size.width + radius) {
        final double bob = math.sin((xBase / size.width) * 2 * math.pi + i) * 2.0;
        final double y = baseY + size.height * 0.4 + lane + bob;

        bubblePaint.color = color.withOpacity(0.60);
        canvas.drawCircle(Offset(xBase, y), radius, bubblePaint);
        canvas.drawCircle(Offset(xBase - radius * 0.35, y - radius * 0.35), radius * 0.35, highlightPaint);
      }
    }

    canvas.restore();
  }

  // Helpers
  double _fract(double x) => x - x.floorToDouble();
  double _rand01(int i, double salt) {
    final double v = math.sin((i + 1) * 12.9898 + salt * 78.233) * 43758.5453123;
    return _fract(v.abs());
  }

  @override
  bool shouldRepaint(covariant _GlossyDividerPainter oldDelegate) =>
      oldDelegate.holeImage != holeImage ||
          oldDelegate.lettuceImage != lettuceImage ||
          oldDelegate.float != float ||
          oldDelegate.wave != wave ||
          oldDelegate.bubbleTime != bubbleTime;
}

class _WaterBubbleSpec {
  const _WaterBubbleSpec({
    required this.color,
    required this.radius,
    required this.lane,
    required this.speedPxPerSec,
    required this.offsetPx,
  });

  final Color color;         // pink for pH, orange for nutrients
  final double radius;       // px
  final double lane;         // vertical offset around mid-water
  final double speedPxPerSec;
  final double offsetPx;     // initial pixel offset
}

class _TwoToneBorderPainter extends CustomPainter {
  const _TwoToneBorderPainter({
    required this.progressColor,
    required this.whiteColor,
    required this.borderWidth,
  });

  final Color progressColor;
  final Color whiteColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Define the circular rect
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Paint for the left portion border
    final leftPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc ONLY on the left half (from 90° to 270°)
    // Flutter uses radians: 0 rad = right, π/2 rad = bottom, π rad = left, 3π/2 rad = top
    canvas.drawArc(
      rect,
      3.14159 / 2,   // start at 90° (top → left)
      3.14159,       // sweep 180° (top → left → bottom)
      false,
      leftPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TwoToneBorderPainter oldDelegate) =>
      oldDelegate.progressColor != progressColor ||
      oldDelegate.whiteColor != whiteColor ||
      oldDelegate.borderWidth != borderWidth;
}

class _QuickActionButton extends StatefulWidget {
  const _QuickActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          return Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  widget.color.withValues(alpha: 0.8),
                  widget.color.withValues(alpha: 0.6 * _blinkAnimation.value),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 2,
              ),
              boxShadow: [
                // Primary shadow for depth
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4 * _blinkAnimation.value),
                  blurRadius: 12 + (8 * _blinkAnimation.value),
                  spreadRadius: 1 + (2 * _blinkAnimation.value),
                  offset: const Offset(0, 4),
                ),
                // Secondary shadow for more depth
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.2 * _blinkAnimation.value),
                  blurRadius: 20 + (10 * _blinkAnimation.value),
                  spreadRadius: 2 + (3 * _blinkAnimation.value),
                  offset: const Offset(0, 8),
                ),
                // White highlight for premium look
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(-2, -2),
                ),
                // Animated glow effect
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.6 * _blinkAnimation.value),
                  blurRadius: 25 * _blinkAnimation.value,
                  spreadRadius: 5 * _blinkAnimation.value,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner highlight overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.2,
                          colors: [
                            Colors.white.withValues(alpha: 0.4 * _blinkAnimation.value),
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                // Icon with shadow
                Center(
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlantGrowthProgressBar extends StatelessWidget {
  const _PlantGrowthProgressBar({
    required this.selectedMetric,
    required this.currentStage,
    required this.nextStage,
    required this.levelProgress,
    required this.currentStageLevel,
  });

  final PlantMetric? selectedMetric;
  final PlantStage currentStage;
  final PlantStage nextStage;
  final double levelProgress;
  final int currentStageLevel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            // Combined progress bars container with separate text overlay
            Container(
              height: 80, // Much larger height for the expanded progress bars
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none, // Allow circles to extend outside
                children: [
                  // Background: Progress bars container
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main health progress bar - clean
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7 - 60, // Much longer width
                        height: 24, // Much bigger height for prominence
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), // Adjusted for new height
                          color: Colors.white.withValues(alpha: 0.2),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: selectedMetric?.progress ?? 0.0,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              (selectedMetric?.endColor ?? Colors.green).withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3), // Balanced gap between bars
                      // Level progress bar (yellow) - clean
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7 - 60, // Same longer width as main bar
                        height: 16, // Expanded height to match proportions
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // Adjusted for new height
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: levelProgress,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFF59E0B), // Yellow color for level progress
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Foreground: Percentage text container
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main health percentage text - perfectly centered
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7 - 60,
                        height: 24,
                        child: Center(
                          child: Text(
                            selectedMetric?.value ?? '0%',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3), // Match gap between bars
                      // Level percentage text - perfectly centered
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7 - 60,
                        height: 16,
                        child: Center(
                          child: Text(
                            '${(levelProgress * 100).round()}%',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Start circle with current stage icon - gamified border color
                  Positioned(
                    left: -18 - 22, // More gaps: -18 (circle position) - 22 (gap)
                    child: Container(
                      width: 60, // Even bigger circles
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentStage.stageColor,
                        border: Border.all(
                          color: const Color(0xFFF59E0B), // Yellow color matching level progress bar
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.7), // Yellow shadow matching level progress
                            blurRadius: 20, // Much stronger shadow
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/lvl_${currentStageLevel}.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // End circle with next stage icon - gamified two-tone border
                  Positioned(
                    right: -18 - 22, // More gaps: -18 (circle position) - 22 (gap)
                    child: Container(
                      width: 60, // Even bigger circles
                      height: 60,
                      child: Stack(
                        children: [
                          // Base circle
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: nextStage.stageColor,
                              boxShadow: [
                                BoxShadow(
                                  color: nextStage.stageColor.withValues(alpha: 0.7),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/lvl_${currentStageLevel < 4 ? currentStageLevel + 1 : 4}.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Two-tone border overlay (only when levelProgress >= 0.95)
                          if (levelProgress >= 0.95)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: _TwoToneBorderPainter(
                                    progressColor: const Color(0xFFF59E0B), // Yellow matching level bar
                                    whiteColor: Colors.white,
                                    borderWidth: 5,
                                  ),
                                ),
                              ),
                            )
                          else
                            // White border when progress < 95%
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white, // White border for < 95%
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}