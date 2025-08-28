import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class PlantCenterPage extends StatelessWidget {
  const PlantCenterPage({super.key});

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
                              children: [
                                SizedBox(
                                  width: tileWidth,
                                  child: const _InfoSquare(
                                    title: 'Plant Health',
                                    value: '86%',
                                    statusLabel: 'Excellent',
                                    statusColor: Color(0xFF16A34A),
                                    bgIcon: Icons.local_florist,
                                    startColor: Color(0xFF80ED99),
                                    endColor: Color(0xFF57CC99),
                                    progress: 0.86,
                                  ),
                                ),
                                SizedBox(
                                  width: tileWidth,
                                  child: const _InfoSquare(
                                    title: 'Water Level',
                                    value: '72%',
                                    statusLabel: 'Normal',
                                    statusColor: Color(0xFF16A34A),
                                    bgIcon: Icons.water_drop,
                                    startColor: Color(0xFF00B4D8),
                                    endColor: Color(0xFF48CAE4),
                                    progress: 0.72,
                                  ),
                                ),
                                SizedBox(
                                  width: tileWidth,
                                  child: const _InfoSquare(
                                    title: 'pH Level',
                                    value: '46%',
                                    statusLabel: 'Normal',
                                    statusColor: Color(0xFF16A34A),
                                    bgIcon: Icons.speed,
                                    startColor: Color(0xFFFFAFCC),
                                    endColor: Color(0xFFFFC8DD),
                                    progress: 0.46,
                                  ),
                                ),
                                SizedBox(
                                  width: tileWidth,
                                  child: const _InfoSquare(
                                    title: 'Nutrients Level',
                                    value: '48%',
                                    statusLabel: 'Normal',
                                    statusColor: Color(0xFF16A34A),
                                    bgIcon: Icons.biotech,
                                    startColor: Color(0xFFFDE68A),
                                    endColor: Color(0xFFF59E0B),
                                    progress: 0.48,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
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
    required this.title,
    required this.value,
    required this.statusLabel,
    required this.statusColor,
    required this.bgIcon,
    required this.startColor,
    required this.endColor,
    required this.progress,
  });

  final String title;
  final String value;
  final String statusLabel;
  final Color statusColor;
  final IconData bgIcon;
  final Color startColor;
  final Color endColor;
  final double progress; // 0..1

  Color _statusToColor(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final Color computedStatusColor = _statusToColor(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Primary color glow
          BoxShadow(
            color: endColor.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
            spreadRadius: 1,
          ),
          // Secondary color glow
          BoxShadow(
            color: startColor.withValues(alpha: 0.25),
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
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background watermark icon
          Positioned(
            right: -6,
            bottom: -6,
            child: Icon(
              bgIcon,
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
                  title,
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
                            statusLabel,
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
                            progress: progress,
                            backgroundColor: Colors.white.withValues(alpha: 0.20),
                            fillColor: computedStatusColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      value,
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

  @override
  void initState() {
    super.initState();
    _loadHoleImage();
    _loadLettuceImage();
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatController.dispose();
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
        ),
      ),
    );
  }

  Future<void> _loadHoleImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/hole.png');
      final Uint8List bytes = data.buffer.asUint8List();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        if (mounted) {
          setState(() {
            _holeImage = img;
          });
        }
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadLettuceImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/lettuce_pangalawa.png');
      final Uint8List bytes = data.buffer.asUint8List();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        if (mounted) {
          setState(() {
            _lettuceImage = img;
          });
        }
      });
    } catch (_) {
      // ignore
    }
  }
}

class _GlossyDividerPainter extends CustomPainter {
  _GlossyDividerPainter({
    required this.strokeWidth,
    required this.holeImage,
    required this.lettuceImage,
    required this.float,
  }) : super(repaint: float);

  final double strokeWidth;
  final ui.Image? holeImage;
  final ui.Image? lettuceImage;
  final Animation<double>? float;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Offset.zero & size;

    // Background gradient (continuous, no hole)
    final Paint bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0x80FFFFFF),
          Color(0x47FFFFFF),
          Color(0x1AFFFFFF),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, bgPaint);

    // Compute center gap for strokes only (top stroke)
    final double rawGap = size.width * 0.22;
    final double gapWidth = rawGap.clamp(48.0, 180.0);
    final double leftEnd = (size.width - gapWidth) / 2.0;
    final double rightStart = leftEnd + gapWidth;

    // Base solid stroke rectangles (square ends)
    final Paint baseTopRectPaint = Paint()..color = const Color(0xCCFFFFFF);
    final Rect topLeftRect = Rect.fromLTWH(0, 0, leftEnd, strokeWidth);
    final Rect topRightRect = Rect.fromLTWH(rightStart, 0, size.width - rightStart, strokeWidth);
    canvas.drawRect(topLeftRect, baseTopRectPaint);
    canvas.drawRect(topRightRect, baseTopRectPaint);

    // Fixed Y for stroke line
    final double baseY = strokeWidth / 2;

    // Blur stroke layer 1 (soft glow, rounded ends)
    final Paint blurStroke1 = Paint()
      ..color = const Color(0x55FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), blurStroke1);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), blurStroke1);

    // Mid solid rounded stroke
    final Paint midRounded = Paint()
      ..color = const Color(0xE6FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), midRounded);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), midRounded);

    // Blur stroke layer 2 (inner highlight)
    final Paint blurStroke2 = Paint()
      ..color = const Color(0x88FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawLine(Offset(0, baseY), Offset(leftEnd, baseY), blurStroke2);
    canvas.drawLine(Offset(rightStart, baseY), Offset(size.width, baseY), blurStroke2);

    // Determine target reacts (hole fixed, lettuce animated)
    final double desiredWidth = math.min(360.0, size.width * 0.70);
    final double holeAspect = holeImage != null ? (holeImage!.width / holeImage!.height) : 1.0;
    final double drawWidth = desiredWidth;
    final double drawHeight = drawWidth / holeAspect;

    // Hole: fixed at stroke line
    final Rect dstHole = Rect.fromCenter(
      center: Offset(size.width / 2, baseY),
      width: drawWidth,
      height: drawHeight,
    );

    // Lettuce: animated around the stroke line
    final double yFloat = baseY + (float?.value ?? 0.0);
    final Rect dstLettuce = Rect.fromCenter(
      center: Offset(size.width / 2, yFloat),
      width: drawWidth,
      height: drawHeight,
    );

    // Hole behind (fixed on stroke)
    if (holeImage != null) {
      final Rect srcH = Rect.fromLTWH(
        0, 0,
        holeImage!.width.toDouble(),
        holeImage!.height.toDouble(),
      );
      canvas.drawImageRect(
        holeImage!,
        srcH,
        dstHole, // fixed at baseY
        Paint()..filterQuality = FilterQuality.high,
      );
    }

// Lettuce in front (animated around stroke)
    if (lettuceImage != null) {
      final Rect srcL = Rect.fromLTWH(
        0, 0,
        lettuceImage!.width.toDouble(),
        lettuceImage!.height.toDouble(),
      );
      canvas.drawImageRect(
        lettuceImage!,
        srcL,
        dstLettuce, // at yFloat
        Paint()..filterQuality = FilterQuality.high,
      );
    }

    // Cross highlights for glass shine (continuous, subtle)
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

    // Radial top-center bloom (continuous)
    final Paint bloom = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 0.9,
        colors: [const Color(0x33FFFFFF), const Color(0x00FFFFFF)],
        stops: const [0.0, 1.0],
      ).createShader(bounds);
    canvas.drawRect(bounds, bloom);
  }

  @override
  bool shouldRepaint(covariant _GlossyDividerPainter oldDelegate) =>
      oldDelegate.holeImage != holeImage || oldDelegate.lettuceImage != lettuceImage || oldDelegate.float != float;
}

