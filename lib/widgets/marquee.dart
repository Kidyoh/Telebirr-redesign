import 'package:flutter/material.dart';

/// A single line of text scrolling slowly and seamlessly (ambient loop).
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.text,
    required this.style,
    this.separator = '   ·   ',
    this.pixelsPerSecond = 28,
  });

  final String text;
  final TextStyle style;
  final String separator;
  final double pixelsPerSecond;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);
  double _unit = 0;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitText = '${widget.text}${widget.separator}';
    final tp = TextPainter(
      text: TextSpan(text: unitText, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    if (tp.width != _unit) {
      _unit = tp.width;
      _c
        ..duration = Duration(
          milliseconds: (_unit / widget.pixelsPerSecond * 1000).round(),
        )
        ..repeat();
    }
    return LayoutBuilder(
      builder: (context, c) {
        final copies = (c.maxWidth / _unit).ceil() + 1;
        return ClipRect(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_unit * _c.value, 0),
              child: child,
            ),
            child: OverflowBox(
              alignment: Alignment.centerLeft,
              maxWidth: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < copies; i++)
                    Text(unitText, style: widget.style, maxLines: 1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
