import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/services.dart';
import '../data/wallet.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/brand_tile.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';
import '../widgets/wave_card.dart';
import 'scan_screen.dart';
import 'send_money_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static void openSend(BuildContext context, {Contact? to}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Motion.slow,
        reverseTransitionDuration: Motion.medium,
        pageBuilder: (_, _, _) => SendMoneyScreen(initial: to),
        transitionsBuilder: (_, a, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Motion.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: TB.ground,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(TB.s20, top + TB.s12, TB.s20, TB.s32),
        children: [
          const Reveal(child: _Header()),
          const SizedBox(height: TB.s20),
          const Reveal(index: 1, child: _BalanceCard()),
          const SizedBox(height: TB.s16),
          const Reveal(index: 2, child: _QuickActions()),
          const SizedBox(height: TB.s24),
          Reveal(
            index: 3,
            child: _SectionTitle(title: 'Recently Sent', onSeeAll: () {}),
          ),
          const SizedBox(height: TB.s12),
          const Reveal(index: 4, child: _RecentlySent()),
          const SizedBox(height: TB.s20),
          Reveal(
            index: 5,
            child: Pressable(
              onTap: () {},
              semanticLabel: 'Zemen Gebeya',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/brand/promo_zemen.png',
                  height: 104,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: TB.s24),
          const Reveal(index: 6, child: _FinancialServices()),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [TB.brandBright, TB.brandDeep],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            Wallet.ownerName[0],
            style: TType.bodyStrong.copyWith(color: Colors.white, fontSize: 17),
          ),
        ),
        const SizedBox(width: TB.s12),
        Text('Welcome back', style: TType.uiLabel.copyWith(color: TB.ink)),
        const Spacer(),
        _IconButton(icon: Icons.search_rounded, label: 'Search', onTap: () {}),
        const SizedBox(width: TB.s8),
        _IconButton(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          dot: true,
          onTap: () {},
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.dot = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressRound,
      semanticLabel: label,
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 24, color: TB.ink),
            if (dot)
              Positioned(
                top: 7,
                right: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: TB.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: TB.ground, width: 1.2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Balance card ──────────────────────────────────────────────────────────

class _BalanceCard extends StatefulWidget {
  const _BalanceCard();

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _hidden = true;

  void _openScan() {
    haptic(HapticKind.medium);
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: Motion.medium,
        reverseTransitionDuration: Motion.fast,
        pageBuilder: (_, _, _) => const ScanScreen(),
        transitionsBuilder: (_, a, _, child) {
          final t = CurvedAnimation(parent: a, curve: Motion.easeExpo);
          return FadeTransition(
            opacity: t,
            child: ScaleTransition(
              scale: Tween(begin: 1.06, end: 1.0).animate(t),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WaveCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CardChip(),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _BalanceValue(hidden: _hidden),
                    const SizedBox(height: 6),
                    Text(
                      'TOTAL BALANCE',
                      style: TType.micro.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUPER APP',
                        style: TType.title2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'One App For All Your Needs',
                        style: TType.micro.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Pressable(
                  scale: Motion.pressRound,
                  haptic: HapticKind.none,
                  semanticLabel: 'Scan QR',
                  onTap: _openScan,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: TB.s12),
                _PrivacySwitch(
                  on: _hidden,
                  onChanged: (v) => setState(() => _hidden = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The two overlapping discs in a frosted pill at the card's top-left.
class _CardChip extends StatelessWidget {
  const _CardChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(TB.rPill),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 3,
            child: _disc(Colors.white.withValues(alpha: 0.45)),
          ),
          Positioned(
            left: 16,
            top: 3,
            child: _disc(Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _disc(Color c) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
}

/// Balance that crossfades through a blur between stars and the figure.
class _BalanceValue extends StatelessWidget {
  const _BalanceValue({required this.hidden});

  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final big = TType.title1.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return ValueListenableBuilder<double>(
      valueListenable: Wallet.balance,
      builder: (context, balance, _) {
        final parts = formatEtb(balance).split('.');
        return TweenAnimationBuilder<double>(
          tween: Tween(end: hidden ? 1 : 0),
          duration: Motion.medium,
          curve: Motion.easeOut,
          builder: (context, h, _) {
            return Stack(
              alignment: Alignment.centerRight,
              children: [
                Opacity(
                  opacity: 1 - h,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 10 * h,
                      sigmaY: 10 * h,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: parts[0]),
                          TextSpan(
                            text: '.${parts[1]}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const TextSpan(
                            text: ' ETB',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      style: big,
                    ),
                  ),
                ),
                if (h > 0)
                  Opacity(
                    opacity: h,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: '******'),
                          TextSpan(
                            text: '***',
                            style: big.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                      style: big,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

/// The white switch on the card: on hides the balance.
class _PrivacySwitch extends StatelessWidget {
  const _PrivacySwitch({required this.on, required this.onChanged});

  final bool on;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressPill,
      semanticLabel: on ? 'Show balance' : 'Hide balance',
      onTap: () => onChanged(!on),
      child: AnimatedContainer(
        duration: Motion.fast,
        width: 40,
        height: 22,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: on
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(TB.rPill),
        ),
        child: AnimatedAlign(
          duration: Motion.medium,
          curve: Motion.easeSpring,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick actions ─────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ActionCard(
              title: 'Send Money',
              subtitle: 'Fast & Easy',
              icon: Icons.north_east_rounded,
              background: TB.night,
              iconFill: TB.brand,
              iconColor: TB.night,
              heroTag: 'send-card',
              onTap: () => HomeScreen.openSend(context),
            ),
          ),
          const SizedBox(width: TB.s12),
          Expanded(
            child: _ActionCard(
              title: 'Airtime/Package',
              subtitle: 'Top Up Now',
              icon: Icons.inventory_2_outlined,
              background: TB.brand,
              iconFill: Colors.white,
              iconColor: TB.brandDeep,
              badge: 'Up to 35%',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.background,
    required this.iconFill,
    required this.iconColor,
    required this.onTap,
    this.badge,
    this.heroTag,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color background;
  final Color iconFill;
  final Color iconColor;
  final VoidCallback onTap;
  final String? badge;

  /// When set, the card's background flies into the next screen's header.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final bg = Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Pressable(
      semanticLabel: title,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: heroTag == null ? bg : Hero(tag: heroTag!, child: bg),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 17, color: iconColor),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TType.bodyStrong.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TType.micro.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w400,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
                if (badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _Pulse(child: RibbonBadge(text: badge!)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A gentle pop every few seconds to draw the eye to an offer.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final v = _c.value < 0.15 ? _c.value / 0.15 : 1.0;
        final s = v >= 1 ? 1.0 : 1 + 0.08 * (1 - (2 * v - 1).abs());
        return Transform.scale(scale: s, child: child);
      },
    );
  }
}

// ── Sections ──────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TType.bodyStrong.copyWith(color: TB.ink, fontSize: 15),
          ),
        ),
        Pressable(
          scale: Motion.pressPill,
          onTap: onSeeAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('see all', style: TType.caption.copyWith(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

class _RecentlySent extends StatelessWidget {
  const _RecentlySent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: OverflowBox(
        maxWidth: MediaQuery.sizeOf(context).width,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: TB.s20),
          itemCount: recentContacts.length,
          separatorBuilder: (_, _) => const SizedBox(width: TB.s12),
          itemBuilder: (context, i) {
            final c = recentContacts[i];
            return Pressable(
              semanticLabel: 'Send to ${c.name}',
              onTap: () => HomeScreen.openSend(context, to: c),
              child: Container(
                width: 178,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TB.rMd),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: TB.ground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: TB.inkFaint,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: TB.s8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TType.caption.copyWith(
                              color: TB.ink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Sent by you • ${c.lastSent}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TType.micro.copyWith(
                              color: TB.inkFaint,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FinancialServices extends StatefulWidget {
  const _FinancialServices();

  @override
  State<_FinancialServices> createState() => _FinancialServicesState();
}

class _FinancialServicesState extends State<_FinancialServices> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final all = <Service>[cashInOut, zemen, ...homeServices];
    final shown = _all ? all : all.take(8).toList();
    return Column(
      children: [
        _SectionTitle(
          title: 'Financial Services',
          onSeeAll: () => setState(() => _all = !_all),
        ),
        const SizedBox(height: TB.s16),
        AnimatedSize(
          duration: Motion.medium,
          curve: Motion.easeExpo,
          alignment: Alignment.topCenter,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: TB.s20,
              crossAxisSpacing: TB.s8,
              childAspectRatio: 0.74,
            ),
            itemCount: shown.length,
            itemBuilder: (context, i) {
              final tile = BrandTile(service: shown[i]);
              return i >= 8
                  ? Reveal(index: i - 8, rise: 12, child: tile)
                  : tile;
            },
          ),
        ),
      ],
    );
  }
}
