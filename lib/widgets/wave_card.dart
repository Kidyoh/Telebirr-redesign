import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The near-black card with the telebirr green wave across its top, and a
/// second green card peeking out underneath. The wave breathes very slowly.
class WaveCard extends StatefulWidget {
  const WaveCard({
    super.key,
    required this.child,
    this.height = 196,
    this.stacked = true,
    this.waveDepth = 0.62,
  });

  final Widget child;
  final double height;

  /// Show the green card peeking out under this one.
  final bool stacked;

  /// How far down the left side of the wave reaches (0..1 of the height).
  final double waveDepth;

  @override
  State<WaveCard> createState() => _WaveCardState();
}

class _WaveCardState extends State<WaveCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const r = BorderRadius.all(Radius.circular(24));
    final card = ClipRRect(
      borderRadius: r,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: CustomPaint(
          painter: _WavePainter(_c, widget.waveDepth),
          child: widget.child,
        ),
      ),
    );
    if (!widget.stacked) return RepaintBoundary(child: card);
    return RepaintBoundary(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 12,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: r,
                gradient: LinearGradient(colors: [TB.brandBright, TB.brand]),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 9), child: card),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.t, this.depth) : super(repaint: t);

  final Animation<double> t;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = TB.night);

    final s = math.sin(t.value * 2 * math.pi);
    final low = h * depth;
    final high = h * (depth - 0.24);
    final bend = w * (0.5 + 0.03 * s);

    // Green top: deep on the left, rising through an S-curve on the right.
    final wave = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, high + 4 * s)
      ..lineTo(bend + w * 0.16, high + 4 * s)
      ..cubicTo(
        bend + w * 0.02,
        high + 4 * s,
        bend - w * 0.02,
        low,
        bend - w * 0.16,
        low,
      )
      ..lineTo(0, low)
      ..close();

    canvas.drawPath(
      wave,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TB.brandBright, TB.brand, Color(0xFF4F9A1C)],
          stops: [0, 0.45, 1],
        ).createShader(Offset.zero & size),
    );

    // A soft sheen sliding along the wave.
    final sheenX = w * (0.2 + 0.25 * (s + 1));
    canvas.save();
    canvas.clipPath(wave);
    canvas.drawCircle(
      Offset(sheenX, h * 0.05),
      w * 0.45,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.28),
                Colors.white.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(sheenX, h * 0.05),
                radius: w * 0.45,
              ),
            ),
    );
    canvas.restore();

    // A thin shadow just under the wave's edge gives it some lift.
    canvas.drawPath(
      wave,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.depth != depth;
}
