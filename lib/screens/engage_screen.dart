import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';

class EngageScreen extends StatelessWidget {
  const EngageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.55),
          radius: 0.9,
          colors: [Color(0xFFFFF4D6), TB.ground],
        ),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          TB.s20,
          pad.top + TB.s12,
          TB.s20,
          pad.bottom + 120,
        ),
        children: [
          Row(
            children: [
              _RoundIcon(icon: Icons.menu_rounded, label: 'Menu'),
              const Spacer(),
              Text('ENGAGE', style: TType.labelCaps),
              const Spacer(),
              _RoundIcon(icon: Icons.search_rounded, label: 'Search'),
            ],
          ),
          const SizedBox(height: TB.s24),
          const Reveal(child: _FloatingLogo()),
          const SizedBox(height: TB.s24),
          Reveal(
            index: 1,
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Talk with your people,\n',
                    style: TType.headline.copyWith(color: TB.ink),
                  ),
                  TextSpan(
                    text: 'money included.',
                    style: TType.accentHeadline.copyWith(color: TB.accentDeep),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: TB.s12),
          Reveal(
            index: 2,
            child: Text(
              'Engage with friends and family and feel the power of telebirr in every chat.',
              textAlign: TextAlign.center,
              style: TType.body.copyWith(color: TB.inkSoft),
            ),
          ),
          const SizedBox(height: TB.s28),
          const Reveal(
            index: 3,
            child: _Feature(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chat',
              body: 'Messages and groups, right next to your wallet.',
              tint: TB.paperButter,
              ink: TB.pastelAmberInk,
            ),
          ),
          const SizedBox(height: TB.s12),
          const Reveal(
            index: 4,
            child: _Feature(
              icon: Icons.send_rounded,
              title: 'Send in a chat',
              body: 'Pay a friend without leaving the conversation.',
              tint: TB.paperSky,
              ink: Color(0xFF0B3F5F),
            ),
          ),
          const SizedBox(height: TB.s12),
          const Reveal(
            index: 5,
            child: _Feature(
              icon: Icons.call_split_rounded,
              title: 'Split the bill',
              body: 'Share a cost with a group and see who has paid.',
              tint: TB.brandMist,
              ink: TB.brandShade,
            ),
          ),
          const SizedBox(height: TB.s28),
          Reveal(
            index: 6,
            child: Pressable(
              scale: Motion.pressPill,
              haptic: HapticKind.light,
              onTap: () {},
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: TB.button,
                  borderRadius: BorderRadius.circular(TB.rPill),
                  boxShadow: TB.shadowSoft,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start engaging',
                      style: TType.uiLabel.copyWith(color: TB.onButton),
                    ),
                    const SizedBox(width: TB.s8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: TB.onButton,
                      size: 20,
                    ),
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

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      semanticLabel: label,
      onTap: () {},
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: TB.surfaceRaised,
          shape: BoxShape.circle,
          boxShadow: TB.shadowSoft,
        ),
        child: Icon(icon, color: TB.ink, size: 22),
      ),
    );
  }
}

/// The Engage mark floating gently, with two dots orbiting on its ring.
class _FloatingLogo extends StatefulWidget {
  const _FloatingLogo();

  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = _c.value * 2 * math.pi;
          return CustomPaint(
            painter: _OrbitPainter(t),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, math.sin(t * 2) * 6),
                child: child,
              ),
            ),
          );
        },
        child: Container(
          width: 168,
          height: 168,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(48),
            boxShadow: TB.shadowCard,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.asset('assets/brand/engage.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const r = 112.0;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = TB.hairline,
    );
    void dot(double a, Color color, double rad) {
      canvas.drawCircle(
        c + Offset(math.cos(a) * r, math.sin(a) * r),
        rad,
        Paint()..color = color,
      );
    }

    dot(t, const Color(0xFFF7B731), 7);
    dot(t + math.pi, TB.accent, 6);
    dot(-t * 0.6 + 1, TB.brand, 4);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old.t != t;
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.title,
    required this.body,
    required this.tint,
    required this.ink,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color tint;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TB.s16),
      decoration: BoxDecoration(
        color: TB.surfaceRaised,
        borderRadius: BorderRadius.circular(TB.rLg),
        boxShadow: TB.shadowSoft,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: Icon(icon, color: ink, size: 22),
          ),
          const SizedBox(width: TB.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TType.bodyStrong.copyWith(color: TB.ink)),
                Text(body, style: TType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
