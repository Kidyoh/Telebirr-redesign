import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/glass.dart';
import '../widgets/pressable.dart';
import '../widgets/qr_sheet.dart';

/// The scanner. Camera access is left to the integrating app; this screen is
/// the frame: breathing corners, a sweeping line, glass controls.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);
  bool _torch = false;

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final side = MediaQuery.sizeOf(context).width * 0.68;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0B),
      body: Stack(
        children: [
          // Stand-in for the camera feed: a dim, warm-to-green glow.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.1,
                  colors: [Color(0xFF26331A), Color(0xFF0A0A0B)],
                ),
              ),
            ),
          ),
          Positioned(
            top: pad.top + TB.s12,
            left: TB.s20,
            right: TB.s20,
            child: Row(
              children: [
                _GlassRound(
                  icon: Icons.close_rounded,
                  label: 'Close',
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text(
                  'SCAN QR',
                  style: TType.labelCaps.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                _GlassRound(
                  icon: _torch
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  label: 'Torch',
                  onTap: () => setState(() => _torch = !_torch),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Point at a code,\n',
                        style: TType.title1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'we do the rest.',
                        style: TType.accentHeadline.copyWith(
                          color: TB.brand,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TB.s28),
                SizedBox(
                  width: side,
                  height: side,
                  child: AnimatedBuilder(
                    animation: _sweep,
                    builder: (context, _) {
                      final t = Motion.easeInOut.transform(_sweep.value);
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _CornersPainter(inset: 4 + 6 * t),
                            ),
                          ),
                          Positioned(
                            left: 18,
                            right: 18,
                            top: 18 + (side - 40) * t,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0x008CC63F),
                                    TB.brand,
                                    Color(0x008CC63F),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x998CC63F),
                                    blurRadius: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: TB.s32,
            right: TB.s32,
            bottom: pad.bottom + TB.s24,
            child: GlassPanel(
              radius: TB.rPill,
              fill: const Color(0x1FFFFFFF),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(
                    child: _BarAction(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: _BarAction(
                      icon: Icons.qr_code_2_rounded,
                      label: 'My QR',
                      filled: true,
                      onTap: () => showQrSheet(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassRound extends StatelessWidget {
  const _GlassRound({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      semanticLabel: label,
      onTap: onTap,
      child: GlassPanel(
        radius: TB.rPill,
        fill: const Color(0x1FFFFFFF),
        child: SizedBox(
          width: 46,
          height: 46,
          child: AnimatedSwitcher(
            duration: Motion.fast,
            child: Icon(
              icon,
              key: ValueKey(icon),
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _BarAction extends StatelessWidget {
  const _BarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? TB.ink : Colors.white;
    return Pressable(
      scale: Motion.pressPill,
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: filled ? TB.onButton : Colors.transparent,
          borderRadius: BorderRadius.circular(TB.rPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(width: TB.s8),
            Text(label, style: TType.bodyStrong.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  _CornersPainter({required this.inset});

  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const len = 34.0;
    const r = 18.0;
    final i = inset;
    final w = size.width;
    final h = size.height;

    void corner(Offset o, double sx, double sy) {
      final path = Path()
        ..moveTo(o.dx, o.dy + sy * len)
        ..lineTo(o.dx, o.dy + sy * r)
        ..arcToPoint(
          Offset(o.dx + sx * r, o.dy),
          radius: const Radius.circular(r),
          clockwise: sx * sy > 0,
        )
        ..lineTo(o.dx + sx * len, o.dy);
      canvas.drawPath(path, p);
    }

    corner(Offset(i, i), 1, 1);
    corner(Offset(w - i, i), -1, 1);
    corner(Offset(i, h - i), 1, -1);
    corner(Offset(w - i, h - i), -1, -1);
  }

  @override
  bool shouldRepaint(covariant _CornersPainter old) => old.inset != inset;
}
