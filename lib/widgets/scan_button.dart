import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'pressable.dart';

/// Scan QR: the blue hero pill. It glows instead of casting a shadow, and the
/// glow breathes slowly so the eye finds it.
class ScanButton extends StatefulWidget {
  const ScanButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Pressable(
            scale: Motion.pressPill,
            haptic: HapticKind.none,
            semanticLabel: 'Scan QR',
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _breathe,
              builder: (context, child) {
                final t = Motion.easeInOut.transform(_breathe.value);
                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TB.rPill),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1890E6), TB.accent, TB.accentDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TB.accentGlow.withValues(alpha: 0.25 + 0.2 * t),
                        blurRadius: 18 + 10 * t,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: TB.onAccent,
                    size: 24,
                  ),
                  const SizedBox(width: TB.s12),
                  Text(
                    'Scan QR',
                    style: TType.uiLabel.copyWith(
                      color: TB.onAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: TB.s12),
        Pressable(
          scale: Motion.pressRound,
          semanticLabel: 'Nearby agents',
          onTap: () {},
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: TB.surfaceRaised,
              shape: BoxShape.circle,
              boxShadow: TB.shadowSoft,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: TB.brandDeep,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
