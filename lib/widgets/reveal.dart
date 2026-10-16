import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Entrance: fade plus a short rise, staggered by [Motion.stagger].
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.index = 0,
    this.rise = 18,
    this.duration = Motion.slow,
    this.baseDelay = Duration.zero,
  });

  final Widget child;
  final int index;
  final double rise;
  final Duration duration;
  final Duration baseDelay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Motion.easeExpo,
  );

  @override
  void initState() {
    super.initState();
    final delay = widget.baseDelay + Motion.stagger * widget.index;
    Future.delayed(delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, widget.rise * (1 - _t.value)),
          child: child,
        ),
      ),
    );
  }
}
