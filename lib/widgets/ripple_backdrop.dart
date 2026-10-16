import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The telebirr green ground: corner glows plus the brand's concentric line
/// rings, drifting very slowly (an ambient loop, the only motion allowed past
/// ~650ms).
class RippleBackdrop extends StatefulWidget {
  const RippleBackdrop({super.key, this.child, this.animate = true});

  final Widget? child;
  final bool animate;

  @override
  State<RippleBackdrop> createState() => _RippleBackdropState();
}

class _RippleBackdropState extends State<RippleBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(painter: _RipplePainter(_c), child: widget.child),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.t) : super(repaint: t);

  final Animation<double> t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base: leaf green, a touch deeper at the bottom.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF93CB45), TB.brand, Color(0xFF7DB834)],
        ).createShader(rect),
    );

    // Corner glows.
    void glow(Offset c, double r, Color color) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    glow(
      Offset(size.width * 0.05, -size.height * 0.05),
      size.width * 0.7,
      const Color(0x55E8F7C8),
    );
    glow(
      Offset(size.width * 1.05, size.height * 0.95),
      size.width * 0.65,
      const Color(0x40467F14),
    );

    // Concentric rings from two off-canvas centres, phase-drifting outward.
    final phase = t.value;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const gap = 9.0;

    void rings(Offset c, double maxR, double alpha) {
      final shift = phase * gap;
      for (var r = shift + gap; r < maxR; r += gap) {
        final fade = (1 - (r / maxR)).clamp(0.0, 1.0);
        ring.color = Colors.white.withValues(alpha: alpha * fade);
        canvas.drawCircle(c, r, ring);
      }
    }

    final drift = math.sin(phase * math.pi * 2) * 6;
    rings(
      Offset(-size.width * 0.12 + drift, size.height * 0.62),
      size.width * 0.95,
      0.22,
    );
    rings(
      Offset(size.width * 1.1 - drift, size.height * 0.2),
      size.width * 0.85,
      0.18,
    );
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) => false;
}
