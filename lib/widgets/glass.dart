import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Frosted glass: blur + translucent fill + 1px rim. Only over something rich
/// (the green hero, scrolling content under the nav).
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.radius = TB.rLg,
    this.blur = TB.blurGlass,
    this.fill = TB.glassFill,
    this.rim = TB.glassRim,
    this.padding = EdgeInsets.zero,
    this.shadow = const [],
  });

  final Widget child;
  final double radius;
  final double blur;
  final Color fill;
  final Color rim;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: r, boxShadow: shadow),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: r,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  fill,
                  fill.withValues(alpha: fill.a * 0.55),
                ],
              ),
              border: Border.all(color: rim, width: 1),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
