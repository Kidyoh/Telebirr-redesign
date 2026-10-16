import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'pressable.dart';

/// My QR: a draggable sheet with the receive code drawing itself in.
Future<void> showQrSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: TB.scrim,
    builder: (_) => const _QrSheet(),
  );
}

class _QrSheet extends StatelessWidget {
  const _QrSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(TB.s24, TB.s12, TB.s24, bottom + TB.s24),
      decoration: const BoxDecoration(
        color: TB.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(TB.r2xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TB.track,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: TB.s24),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: 'Scan to ',
                  style: TType.title1.copyWith(
                    color: TB.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: 'pay Kidus.',
                  style: TType.accentHeadline.copyWith(
                    color: TB.brandInk,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TB.s20),
          Container(
            padding: const EdgeInsets.all(TB.s20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TB.rXl),
              boxShadow: TB.shadowSoft,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Motion.easeOut,
              builder: (context, t, _) => CustomPaint(
                size: const Size.square(220),
                painter: _QrPainter(t),
              ),
            ),
          ),
          const SizedBox(height: TB.s16),
          Text('+251 9•• ••• 916', style: TType.caption),
          const SizedBox(height: TB.s24),
          Row(
            children: [
              Expanded(
                child: _SheetButton(
                  icon: Icons.ios_share_rounded,
                  label: 'Share',
                  filled: false,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: TB.s12),
              Expanded(
                child: _SheetButton(
                  icon: Icons.download_rounded,
                  label: 'Save',
                  filled: true,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? TB.onButton : TB.ink;
    return Pressable(
      scale: Motion.pressPill,
      haptic: HapticKind.light,
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: filled ? TB.button : TB.surfaceRaised,
          borderRadius: BorderRadius.circular(TB.rPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(width: TB.s8),
            Text(label, style: TType.uiLabel.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}

/// A decorative QR-like code (deterministic modules + three finders). Each
/// module fades in along a diagonal sweep driven by [t].
class _QrPainter extends CustomPainter {
  _QrPainter(this.t);

  final double t;
  static const n = 29;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / n;
    final rnd = math.Random(251);
    final ink = Paint()..color = TB.ink;

    bool inFinder(int x, int y) {
      bool f(int ox, int oy) => x >= ox && x < ox + 8 && y >= oy && y < oy + 8;
      return f(0, 0) || f(n - 8, 0) || f(0, n - 8);
    }

    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final on = rnd.nextDouble() < 0.48;
        if (inFinder(x, y) || !on) continue;
        // Leave room for the centre mark.
        if ((x - n / 2).abs() < 4 && (y - n / 2).abs() < 4) continue;
        final d = (x + y) / (2 * n);
        final a = ((t * 1.4 - d) / 0.4).clamp(0.0, 1.0);
        if (a == 0) continue;
        ink.color = TB.ink.withValues(alpha: a);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x * cell + 0.6,
              y * cell + 0.6,
              cell - 1.2,
              cell - 1.2,
            ),
            Radius.circular(cell * 0.3),
          ),
          ink,
        );
      }
    }

    final finder = Paint()..color = TB.ink;
    void drawFinder(double ox, double oy) {
      final s = cell * 7;
      final r = Rect.fromLTWH(ox, oy, s, s);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, Radius.circular(cell * 2)),
        finder
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r.deflate(cell * 2), Radius.circular(cell)),
        finder..style = PaintingStyle.fill,
      );
    }

    final s = Curves.easeOut.transform(t.clamp(0.0, 1.0));
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(0.9 + 0.1 * s);
    canvas.translate(-size.width / 2, -size.height / 2);
    drawFinder(cell * 0.5, cell * 0.5);
    drawFinder(size.width - cell * 7.5, cell * 0.5);
    drawFinder(cell * 0.5, size.height - cell * 7.5);
    canvas.restore();

    // Centre mark: the telebirr green dot.
    final c = size.center(Offset.zero);
    canvas.drawCircle(c, cell * 3.2, Paint()..color = Colors.white);
    canvas.drawCircle(c, cell * 2.6 * s, Paint()..color = TB.brand);
    canvas.drawCircle(c, cell * 1.0 * s, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.t != t;
}
