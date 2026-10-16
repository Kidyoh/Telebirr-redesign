import 'dart:async';

import 'package:flutter/material.dart';

import '../data/services.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/balance_hero.dart';
import '../widgets/brand_tile.dart';
import '../widgets/marquee.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import 'send_money_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Hero and ribbon share one sliver so the ribbon can tuck over the
        // hero's rounded edge (earlier slivers paint on top of later ones).
        const SliverToBoxAdapter(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 17),
                child: BalanceHero(),
              ),
              Positioned(left: 0, right: 0, bottom: 0, child: _Ribbon()),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(TB.s20, TB.s24, TB.s20, 0),
          sliver: SliverList.list(
            children: [
              const Reveal(index: 2, child: _QuickBento()),
              const SizedBox(height: TB.s32),
              const Reveal(index: 4, child: _PromoCarousel()),
              const SizedBox(height: TB.s32),
              const Reveal(index: 5, child: _ServicesGrid()),
              const SizedBox(height: TB.s32),
              const Reveal(index: 6, child: _RecentActivity()),
              SizedBox(height: bottom + 180),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Ribbon ────────────────────────────────────────────────────────────────

class _Ribbon extends StatelessWidget {
  const _Ribbon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TB.s40),
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: TB.ribbon,
          borderRadius: BorderRadius.circular(TB.rPill),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4DF7B731),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Marquee(
          text: 'ONE APP FOR ALL YOUR NEEDS',
          style: TType.eyebrow.copyWith(
            color: TB.ribbonInk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Quick actions bento ───────────────────────────────────────────────────

class _QuickBento extends StatelessWidget {
  const _QuickBento();

  void _openSend(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Motion.slow,
        reverseTransitionDuration: Motion.medium,
        pageBuilder: (_, _, _) => const SendMoneyScreen(),
        transitionsBuilder: (_, a, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Motion.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: Pressable(
              semanticLabel: 'Send Money',
              onTap: () => _openSend(context),
              child: Hero(
                tag: 'send-card',
                child: Container(
                  padding: const EdgeInsets.all(TB.s20),
                  decoration: BoxDecoration(
                    color: TB.featureCard,
                    borderRadius: BorderRadius.circular(TB.rXl),
                    boxShadow: TB.shadowSoft,
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: TB.brand,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.north_east_rounded,
                            color: TB.featureCard,
                            size: 22,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Send',
                          style: TType.title1.copyWith(
                            color: TB.onFeature,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'money',
                          style: TType.accentHeadline.copyWith(
                            color: TB.brand,
                            fontSize: 22,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: TB.s8),
                        Text(
                          'To anyone, in seconds',
                          style: TType.caption.copyWith(
                            color: TB.onFeature.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: TB.s12),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Expanded(
                  child: _MiniCard(
                    service: cashInOut,
                    color: TB.brandMist,
                    ink: TB.brandShade,
                  ),
                ),
                const SizedBox(height: TB.s12),
                Expanded(
                  child: _MiniCard(
                    service: airtime,
                    color: TB.paperButter,
                    ink: TB.pastelAmberInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.service,
    required this.color,
    required this.ink,
  });

  final Service service;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      semanticLabel: service.label,
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(TB.s16, TB.s12, TB.s12, TB.s12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(TB.rLg),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(service.icon, color: ink, size: 24),
                const Spacer(),
                Text(
                  service.label,
                  style: TType.bodyStrong.copyWith(color: ink, height: 1.15),
                ),
              ],
            ),
            if (service.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: _Pulse(child: RibbonBadge(text: service.badge!)),
              ),
          ],
        ),
      ),
    );
  }
}

/// A gentle pop that repeats every few seconds to draw the eye to an offer.
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
        // Pop only in the first ~15% of each cycle, rest is still.
        final v = _c.value < 0.15 ? _c.value / 0.15 : 1.0;
        final s = v >= 1 ? 1.0 : 1 + 0.08 * (1 - (2 * v - 1).abs());
        return Transform.scale(scale: s, child: child);
      },
    );
  }
}

// ── Promo carousel ────────────────────────────────────────────────────────

class _PromoCarousel extends StatefulWidget {
  const _PromoCarousel();

  @override
  State<_PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<_PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _page = 0;
  static const _count = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;
      final next = (_page + 1) % _count;
      _controller.animateToPage(
        next,
        duration: Motion.slow,
        curve: Motion.easeExpo,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: OverflowBox(
            maxWidth: MediaQuery.sizeOf(context).width,
            child: PageView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _promoFrame(
                  0,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(TB.rLg),
                    child: Image.asset(
                      'assets/brand/promo_zemen.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                _promoFrame(
                  1,
                  const _TextPromo(
                    eyebrow: 'UTILITY · NO QUEUES',
                    first: 'Pay every bill',
                    payoff: 'from your couch.',
                    color: TB.paperSky,
                    ink: Color(0xFF0B3F5F),
                    icon: Icons.bolt_rounded,
                  ),
                ),
                _promoFrame(
                  2,
                  const _TextPromo(
                    eyebrow: 'AIRTIME · PACKAGES',
                    first: 'Top up and save',
                    payoff: 'up to 35%.',
                    color: TB.paperButter,
                    ink: TB.pastelAmberInk,
                    icon: Icons.celebration_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TB.s12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _count; i++)
              AnimatedContainer(
                duration: Motion.medium,
                curve: Motion.easeSpring,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _page ? TB.brandDeep : TB.track,
                  borderRadius: BorderRadius.circular(TB.rPill),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Parallax-ish depth: the off-centre pages shrink slightly.
  Widget _promoFrame(int i, Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Pressable(onTap: () {}, child: child),
      ),
      builder: (context, child) {
        var d = 0.0;
        if (_controller.hasClients && _controller.position.haveDimensions) {
          d = ((_controller.page ?? 0) - i).abs().clamp(0.0, 1.0);
        } else {
          d = i == 0 ? 0 : 1;
        }
        return Transform.scale(scale: 1 - 0.06 * d, child: child);
      },
    );
  }
}

class _TextPromo extends StatelessWidget {
  const _TextPromo({
    required this.eyebrow,
    required this.first,
    required this.payoff,
    required this.color,
    required this.ink,
    required this.icon,
  });

  final String eyebrow;
  final String first;
  final String payoff;
  final Color color;
  final Color ink;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TB.s20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TB.rLg),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -26,
            child: Icon(icon, size: 140, color: ink.withValues(alpha: 0.08)),
          ),
          // Scale down rather than overflow at large text sizes.
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(eyebrow, style: TType.eyebrow.copyWith(color: ink)),
                  const SizedBox(height: TB.s8),
                  Text(
                    first,
                    style: TType.title1.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    payoff,
                    style: TType.accentHeadline.copyWith(
                      color: ink,
                      fontSize: 22,
                      height: 1.15,
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

// ── Services grid ─────────────────────────────────────────────────────────

class _ServicesGrid extends StatefulWidget {
  const _ServicesGrid();

  @override
  State<_ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<_ServicesGrid> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final all = <Service>[zemen, ...homeServices];
    final shown = _expanded ? all : all.take(7).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Services', payoff: 'for every day'),
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
            itemCount: shown.length + 1,
            itemBuilder: (context, i) {
              if (i == shown.length) {
                return BrandTile(
                  service: Service(
                    _expanded ? 'Less' : 'More',
                    icon: _expanded
                        ? Icons.expand_less_rounded
                        : Icons.add_circle_outline_rounded,
                  ),
                  onTap: () => setState(() => _expanded = !_expanded),
                );
              }
              final tile = BrandTile(service: shown[i]);
              // Newly revealed tiles rise in, staggered.
              return i >= 7
                  ? Reveal(index: i - 7, rise: 12, child: tile)
                  : tile;
            },
          ),
        ),
      ],
    );
  }
}

// ── Recent activity ───────────────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent',
          payoff: 'activity',
          action: 'Transaction details',
          onAction: () {},
        ),
        const SizedBox(height: TB.s12),
        Container(
          decoration: BoxDecoration(
            color: TB.surfaceRaised,
            borderRadius: BorderRadius.circular(TB.rLg),
            boxShadow: TB.shadowSoft,
          ),
          child: Column(
            children: [
              for (var i = 0; i < recentTxns.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                    color: TB.hairline,
                  ),
                _TxnRow(txn: recentTxns[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.txn});

  final Txn txn;

  @override
  Widget build(BuildContext context) {
    final incoming = txn.amount > 0;
    return Pressable(
      scale: 0.98,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TB.s16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: incoming ? TB.brandMist : TB.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                txn.icon,
                size: 20,
                color: incoming ? TB.brandInk : TB.inkSoft,
              ),
            ),
            const SizedBox(width: TB.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.title,
                    style: TType.bodyStrong.copyWith(color: TB.ink),
                  ),
                  Text(txn.subtitle, style: TType.caption),
                ],
              ),
            ),
            Text(
              '${incoming ? '+' : '−'}${txn.amount.abs().toStringAsFixed(2)}',
              style: TType.bodyStrong.copyWith(
                color: incoming ? TB.brandInk : TB.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
