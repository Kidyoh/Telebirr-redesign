import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/services.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen>
    with SingleTickerProviderStateMixin {
  int? _contact = 0;
  String _amount = '';
  bool _shake = false;
  bool _sent = false;

  static const _balance = 5.52;

  double get _value => double.tryParse(_amount) ?? 0;
  bool get _canSend => _contact != null && _value > 0;

  void _key(String k) {
    setState(() {
      if (k == '⌫') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
        return;
      }
      if (k == '.' && _amount.contains('.')) return;
      if (_amount.contains('.') && _amount.split('.')[1].length >= 2) return;
      if (_amount.replaceAll('.', '').length >= 7) return;
      if (_amount == '0' && k != '.') _amount = '';
      _amount = (_amount.isEmpty && k == '.') ? '0.' : _amount + k;
    });
  }

  void _send() {
    if (!_canSend) return;
    if (_value > _balance) {
      haptic(HapticKind.medium);
      setState(() => _shake = !_shake);
      return;
    }
    haptic(HapticKind.heavy);
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final over = _value > _balance;
    return Scaffold(
      backgroundColor: TB.ground,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Recipient card (flies in from the home bento) ──────────
              Hero(
                tag: 'send-card',
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(0, pad.top + TB.s8, 0, TB.s24),
                  decoration: const BoxDecoration(
                    color: TB.featureCard,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(TB.r3xl),
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TB.s12,
                          ),
                          child: Row(
                            children: [
                              Pressable(
                                scale: Motion.pressRound,
                                semanticLabel: 'Back',
                                onTap: () => Navigator.pop(context),
                                child: const SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: TB.onFeature,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'SEND MONEY',
                                style: TType.labelCaps.copyWith(
                                  color: TB.onFeature.withValues(alpha: 0.75),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 44),
                            ],
                          ),
                        ),
                        const SizedBox(height: TB.s16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TB.s20,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Who are you ',
                                  style: TType.title1.copyWith(
                                    color: TB.onFeature,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: 'sending to?',
                                  style: TType.accentHeadline.copyWith(
                                    color: TB.brand,
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: TB.s16),
                        SizedBox(
                          height: 96,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: TB.s20,
                            ),
                            itemCount: recentContacts.length + 1,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: TB.s16),
                            itemBuilder: (context, i) {
                              if (i == 0) return const _NewContact();
                              final idx = i - 1;
                              return Reveal(
                                index: i,
                                baseDelay: Motion.fast,
                                child: _Avatar(
                                  contact: recentContacts[idx],
                                  selected: _contact == idx,
                                  onTap: () => setState(() => _contact = idx),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Amount ─────────────────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: Motion.fast,
                      child: Text(
                        _contact == null
                            ? 'Pick someone'
                            : 'To ${recentContacts[_contact!].name}',
                        key: ValueKey(_contact),
                        style: TType.caption,
                      ),
                    ),
                    const SizedBox(height: TB.s8),
                    _Shake(
                      trigger: _shake,
                      child: _AmountDisplay(amount: _amount, over: over),
                    ),
                    const SizedBox(height: TB.s8),
                    AnimatedSwitcher(
                      duration: Motion.fast,
                      child: Text(
                        over
                            ? 'More than your balance of ${_balance.toStringAsFixed(2)} ETB'
                            : 'Balance ${_balance.toStringAsFixed(2)} ETB',
                        key: ValueKey(over),
                        style: TType.caption.copyWith(
                          color: over ? TB.danger : TB.inkSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Keypad ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TB.s20),
                child: _Keypad(onKey: _key),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  TB.s20,
                  TB.s12,
                  TB.s20,
                  pad.bottom + TB.s16,
                ),
                child: Pressable(
                  scale: Motion.pressPill,
                  haptic: HapticKind.none,
                  onTap: _send,
                  child: AnimatedContainer(
                    duration: Motion.medium,
                    curve: Motion.easeOut,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _canSend ? TB.button : TB.track,
                      borderRadius: BorderRadius.circular(TB.rPill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _canSend
                              ? 'Send ${_value.toStringAsFixed(2)} ETB'
                              : 'Enter an amount',
                          style: TType.uiLabel.copyWith(
                            color: _canSend ? TB.onButton : TB.inkSoft,
                          ),
                        ),
                        if (_canSend) ...[
                          const SizedBox(width: TB.s8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: TB.onButton,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_sent)
            _SuccessOverlay(
              amount: _value,
              name: recentContacts[_contact!].name,
              onDone: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

class _NewContact extends StatelessWidget {
  const _NewContact();

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TB.onFeature.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_rounded, color: TB.onFeature, size: 26),
          ),
          const SizedBox(height: TB.s8),
          Text(
            'New',
            style: TType.micro.copyWith(
              color: TB.onFeature.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  final Contact contact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Motion.medium,
            curve: Motion.easeSpring,
            width: 60,
            height: 60,
            padding: EdgeInsets.all(selected ? 3 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? TB.brand : Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: contact.tint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: TB.featureCard,
                  width: selected ? 2.5 : 0,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                contact.initials,
                style: TType.bodyStrong.copyWith(color: TB.ink),
              ),
            ),
          ),
          const SizedBox(height: TB.s8),
          AnimatedDefaultTextStyle(
            duration: Motion.fast,
            style: TType.micro.copyWith(
              color: selected
                  ? TB.onFeature
                  : TB.onFeature.withValues(alpha: 0.7),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(contact.name.split(' ').first),
          ),
        ],
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({required this.amount, required this.over});

  final String amount;
  final bool over;

  @override
  Widget build(BuildContext context) {
    final text = amount.isEmpty ? '0' : amount;
    final color = over ? TB.danger : (amount.isEmpty ? TB.inkFaint : TB.ink);
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Each character pops in as it is typed.
          for (var i = 0; i < text.length; i++)
            TweenAnimationBuilder<double>(
              key: ValueKey('$i${text[i]}'),
              tween: Tween(begin: 0, end: 1),
              duration: Motion.medium,
              curve: Motion.easeBack,
              builder: (context, t, child) => Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 14 * (1 - t)),
                  child: child,
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: Motion.fast,
                style: TType.numeralHero.copyWith(fontSize: 76, color: color),
                child: Text(text[i]),
              ),
            ),
          const SizedBox(width: TB.s8),
          Text(
            'ETB',
            style: TType.title2.copyWith(
              color: TB.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Shake extends StatelessWidget {
  const _Shake({required this.trigger, required this.child});

  final bool trigger;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(trigger),
      tween: Tween(begin: 0, end: 1),
      duration: Motion.medium,
      builder: (context, t, child) {
        // Damped sine: three quick wiggles that settle.
        final dx = (1 - t) * 10 * math.sin(t * 6 * math.pi);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: child,
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey});

  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      childAspectRatio: 2.1,
      mainAxisSpacing: TB.s8,
      crossAxisSpacing: TB.s8,
      children: [
        for (final k in keys)
          Pressable(
            scale: Motion.pressRound,
            semanticLabel: k == '⌫' ? 'Delete' : k,
            onTap: () => onKey(k),
            child: Container(
              decoration: BoxDecoration(
                color: TB.surfaceRaised.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(TB.rPill),
              ),
              alignment: Alignment.center,
              child: k == '⌫'
                  ? const Icon(
                      Icons.backspace_outlined,
                      color: TB.ink,
                      size: 22,
                    )
                  : Text(
                      k,
                      style: TType.title1.copyWith(
                        color: TB.ink,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}

/// The goal moment: a green bloom fills the screen, a check draws itself,
/// then the receipt rises in.
class _SuccessOverlay extends StatefulWidget {
  const _SuccessOverlay({
    required this.amount,
    required this.name,
    required this.onDone,
  });

  final double amount;
  final String name;
  final VoidCallback onDone;

  @override
  State<_SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<_SuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final _bloom = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.45, curve: Motion.easeExpo),
  );
  late final _check = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.3, 0.65, curve: Motion.easeOut),
  );
  late final _text = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.55, 1, curve: Motion.easeExpo),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = MediaQuery.paddingOf(context);
    final maxR = size.longestSide * 1.2;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned.fill(
              child: ClipPath(
                clipper: _CircleClip(
                  center: Offset(size.width / 2, size.height - pad.bottom - 45),
                  radius: maxR * _bloom.value,
                ),
                child: const ColoredBox(color: TB.brand),
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(TB.s20),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.95 * _bloom.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(
                          painter: _CheckPainter(_check.value),
                        ),
                      ),
                      const SizedBox(height: TB.s32),
                      Opacity(
                        opacity: _text.value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - _text.value)),
                          child: Column(
                            children: [
                              Text(
                                'Sent.',
                                style: TType.display.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${widget.amount.toStringAsFixed(2)} ETB',
                                style: TType.accentHeadline.copyWith(
                                  color: const Color(0xFFFFF4C9),
                                  fontSize: 44,
                                ),
                              ),
                              const SizedBox(height: TB.s8),
                              Text(
                                'to ${widget.name}',
                                style: TType.body.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      Opacity(
                        opacity: _text.value,
                        child: Pressable(
                          scale: Motion.pressPill,
                          haptic: HapticKind.light,
                          onTap: widget.onDone,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: TB.button,
                              borderRadius: BorderRadius.circular(TB.rPill),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Done',
                              style: TType.uiLabel.copyWith(color: TB.onButton),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CircleClip extends CustomClipper<Path> {
  _CircleClip({required this.center, required this.radius});

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) =>
      Path()..addOval(Rect.fromCircle(center: center, radius: radius));

  @override
  bool shouldReclip(covariant _CircleClip old) =>
      old.radius != radius || old.center != center;
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    final w = size.width;
    final path = Path()
      ..moveTo(w * 0.3, w * 0.52)
      ..lineTo(w * 0.45, w * 0.66)
      ..lineTo(w * 0.72, w * 0.38);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * t),
      Paint()
        ..color = TB.brandDeep
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.t != t;
}
