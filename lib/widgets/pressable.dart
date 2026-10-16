import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// The house press: a squish in on [Motion.press], a spring back out on
/// [Motion.release]. Replaces ink ripples everywhere.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = Motion.pressCard,
    this.haptic = HapticKind.selection,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final HapticKind haptic;
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

enum HapticKind { none, selection, light, medium, heavy }

void haptic(HapticKind kind) {
  switch (kind) {
    case HapticKind.none:
      break;
    case HapticKind.selection:
      HapticFeedback.selectionClick();
    case HapticKind.light:
      HapticFeedback.lightImpact();
    case HapticKind.medium:
      HapticFeedback.mediumImpact();
    case HapticKind.heavy:
      HapticFeedback.heavyImpact();
  }
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Motion.press,
    reverseDuration: Motion.release,
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: widget.scale)
      .animate(
        CurvedAnimation(
          parent: _c,
          curve: Motion.easeOut,
          reverseCurve: Motion.easeSpring.flipped,
        ),
      );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down(_) => _c.forward();
  void _up(_) => _c.reverse();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _down,
        onTapUp: _up,
        onTapCancel: () => _c.reverse(),
        onTap: widget.onTap == null
            ? null
            : () {
                haptic(widget.haptic);
                widget.onTap!();
              },
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
