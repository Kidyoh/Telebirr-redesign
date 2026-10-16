import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'glass.dart';
import 'pressable.dart';
import 'reveal.dart';
import 'ripple_backdrop.dart';

/// The home hero: the telebirr green with its rings, the greeting, and the
/// balance as the one giant number on the screen.
class BalanceHero extends StatelessWidget {
  const BalanceHero({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(TB.r3xl),
      ),
      child: RippleBackdrop(
        child: Padding(
          padding: EdgeInsets.fromLTRB(TB.s20, top + TB.s12, TB.s20, TB.s40),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(child: _TopBar()),
              SizedBox(height: TB.s28),
              Reveal(index: 1, child: _Greeting()),
              SizedBox(height: TB.s28),
              Reveal(index: 2, child: _Balance()),
              SizedBox(height: TB.s24),
              Reveal(index: 3, child: _Wallets()),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The real telebirr lockup, on its own white chip.
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TB.rPill),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A1C3A05),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset('assets/brand/telebirr.png', fit: BoxFit.contain),
        ),
        const Spacer(),
        const _HeroIcon(icon: Icons.search_rounded, label: 'Search'),
        const SizedBox(width: TB.s8),
        const _HeroIcon(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          dot: true,
        ),
        const SizedBox(width: TB.s8),
        const _LanguagePill(),
      ],
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon, required this.label, this.dot = false});

  final IconData icon;
  final String label;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      semanticLabel: label,
      onTap: () {},
      child: GlassPanel(
        radius: TB.rPill,
        blur: 12,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              if (dot)
                Positioned(
                  top: 10,
                  right: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: TB.ribbon,
                      shape: BoxShape.circle,
                      border: Border.all(color: TB.brand, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguagePill extends StatefulWidget {
  const _LanguagePill();

  @override
  State<_LanguagePill> createState() => _LanguagePillState();
}

class _LanguagePillState extends State<_LanguagePill> {
  bool _amharic = false;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressPill,
      semanticLabel: 'Language',
      onTap: () => setState(() => _amharic = !_amharic),
      child: GlassPanel(
        radius: TB.rPill,
        blur: 12,
        child: SizedBox(
          height: 42,
          width: 58,
          child: Center(
            child: AnimatedSwitcher(
              duration: Motion.fast,
              transitionBuilder: (c, a) => FadeTransition(
                opacity: a,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(a),
                  child: c,
                ),
              ),
              child: Text(
                _amharic ? 'አማ' : 'EN',
                key: ValueKey(_amharic),
                style: TType.bodyStrong.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Selam, Kidus.\n',
            style: TType.headline.copyWith(color: Colors.white),
          ),
          TextSpan(
            text: 'one app for everything.',
            style: TType.accentHeadline.copyWith(
              color: const Color(0xFFFFF4C9),
            ),
          ),
        ],
      ),
    );
  }
}

class _Balance extends StatefulWidget {
  const _Balance();

  @override
  State<_Balance> createState() => _BalanceState();
}

class _BalanceState extends State<_Balance> {
  bool _visible = true;
  static const _amount = 5.52;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'BALANCE · ETB',
              style: TType.eyebrow.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(width: TB.s8),
            _EyeToggle(
              visible: _visible,
              onTap: () => setState(() => _visible = !_visible),
            ),
          ],
        ),
        const SizedBox(height: TB.s8),
        _MaskedValue(
          visible: _visible,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _amount),
            duration: const Duration(milliseconds: 1100),
            curve: Motion.easeExpo,
            builder: (context, v, _) {
              final parts = v.toStringAsFixed(2).split('.');
              return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: parts[0]),
                    TextSpan(
                      text: '.${parts[1]}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    TextSpan(
                      text: '  ETB',
                      style: TType.bodyStrong.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                style: TType.numeralHero.copyWith(color: Colors.white),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Hides a value behind a soft blur and dots, crossfading both ways.
class _MaskedValue extends StatelessWidget {
  const _MaskedValue({
    required this.visible,
    required this.child,
    this.maskStyle = TType.numeralHero,
  });

  final bool visible;
  final Widget child;
  final TextStyle maskStyle;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: visible ? 0 : 1),
      duration: Motion.medium,
      curve: Motion.easeOut,
      builder: (context, hide, _) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Opacity(
              opacity: 1 - hide,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 14 * hide,
                  sigmaY: 14 * hide,
                ),
                child: child,
              ),
            ),
            if (hide > 0)
              Opacity(
                opacity: hide,
                child: Transform.translate(
                  offset: Offset(0, 8 * (1 - hide)),
                  child: Text(
                    '••••••',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: maskStyle.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
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

class _EyeToggle extends StatelessWidget {
  const _EyeToggle({
    required this.visible,
    required this.onTap,
    this.size = 18,
  });

  final bool visible;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      semanticLabel: visible ? 'Hide' : 'Show',
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AnimatedSwitcher(
          duration: Motion.fast,
          transitionBuilder: (c, a) => RotationTransition(
            turns: Tween(begin: -0.1, end: 0.0).animate(a),
            child: FadeTransition(opacity: a, child: c),
          ),
          child: Icon(
            visible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            key: ValueKey(visible),
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Wallets extends StatelessWidget {
  const _Wallets();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _WalletGlass(
            label: 'ENDEKISE',
            icon: Icons.savings_outlined,
            amount: '1,250.00',
          ),
        ),
        SizedBox(width: TB.s12),
        Expanded(
          child: _WalletGlass(
            label: 'REWARD',
            icon: Icons.stars_outlined,
            amount: '48.30',
          ),
        ),
      ],
    );
  }
}

class _WalletGlass extends StatefulWidget {
  const _WalletGlass({
    required this.label,
    required this.icon,
    required this.amount,
  });

  final String label;
  final IconData icon;
  final String amount;

  @override
  State<_WalletGlass> createState() => _WalletGlassState();
}

class _WalletGlassState extends State<_WalletGlass> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: TB.rLg,
      fill: const Color(0x241C3A05),
      rim: TB.glassRim,
      padding: const EdgeInsets.fromLTRB(TB.s16, TB.s12, TB.s8, TB.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.label,
                  style: TType.eyebrow.copyWith(color: Colors.white),
                ),
              ),
              _EyeToggle(
                visible: _visible,
                size: 16,
                onTap: () => setState(() => _visible = !_visible),
              ),
            ],
          ),
          const SizedBox(height: TB.s8),
          _MaskedValue(
            visible: _visible,
            maskStyle: TType.title1,
            child: Text(
              widget.amount,
              style: TType.title1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
