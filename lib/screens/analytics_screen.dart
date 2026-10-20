import 'package:flutter/material.dart';

import '../data/wallet.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';
import '../widgets/tab_header.dart';
import '../widgets/wave_card.dart';

/// Where the money went this month (made-up sample data).
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _Category {
  const _Category(this.name, this.icon, this.amount);

  final String name;
  final IconData icon;
  final double amount;
}

const _weeks = <String, double>{
  'W1': 640.0,
  'W2': 1120.0,
  'W3': 860.0,
  'W4': 862.4,
};

const _categories = <_Category>[
  _Category('Transfers', Icons.north_east_rounded, 1450.00),
  _Category('Utilities', Icons.bolt_rounded, 912.40),
  _Category('Airtime & packages', Icons.inventory_2_outlined, 520.00),
  _Category('Merchants', Icons.storefront_outlined, 410.00),
  _Category('Transport', Icons.directions_bus_rounded, 190.00),
];

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _range = 1;

  @override
  Widget build(BuildContext context) {
    final total = _weeks.values.fold<double>(0, (a, b) => a + b);
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const TabHeader(
          eyebrow: 'ANALYTICS',
          title: 'Your spending,',
          payoff: 'at a glance.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(TB.s20, 0, TB.s20, TB.s32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                index: 2,
                child: _RangeToggle(
                  index: _range,
                  onChanged: (i) => setState(() => _range = i),
                ),
              ),
              const SizedBox(height: TB.s16),
              Reveal(
                index: 3,
                child: WaveCard(
                  height: 150,
                  waveDepth: 0.55,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SPENT THIS MONTH',
                          style: TType.micro.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: total),
                          duration: const Duration(milliseconds: 1100),
                          curve: Motion.easeExpo,
                          builder: (context, v, _) => Text(
                            '${formatEtb(v)} ETB',
                            style: TType.title1.copyWith(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '12% more than last month',
                          style: TType.micro.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TB.s20),
              const Reveal(index: 4, child: _WeekBars()),
              const SizedBox(height: TB.s24),
              Reveal(
                index: 5,
                child: Text(
                  'By category',
                  style: TType.bodyStrong.copyWith(color: TB.ink),
                ),
              ),
              const SizedBox(height: TB.s12),
              for (var i = 0; i < _categories.length; i++)
                Reveal(
                  index: 6 + i,
                  child: _CategoryRow(
                    category: _categories[i],
                    share: _categories[i].amount / _categories.first.amount,
                    delay: Motion.stagger * (6 + i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RangeToggle extends StatelessWidget {
  const _RangeToggle({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Week', 'Month', 'Year'];
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TB.rPill),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: Motion.medium,
                curve: Motion.easeSpring,
                left: w * index,
                width: w,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: TB.night,
                    borderRadius: BorderRadius.circular(TB.rPill),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Pressable(
                        scale: Motion.pressPill,
                        onTap: () => onChanged(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Motion.fast,
                            style: TType.caption.copyWith(
                              color: i == index ? Colors.white : TB.inkSoft,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(labels[i]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Weekly bars that grow from the baseline, the busiest week in green.
class _WeekBars extends StatelessWidget {
  const _WeekBars();

  @override
  Widget build(BuildContext context) {
    final max = _weeks.values.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TB.rLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly',
            style: TType.bodyStrong.copyWith(color: TB.ink, fontSize: 14),
          ),
          const SizedBox(height: TB.s16),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, e) in _weeks.entries.indexed)
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: e.value / max),
                      duration: Duration(milliseconds: 700 + 90 * i),
                      curve: Motion.easeExpo,
                      builder: (context, f, _) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Opacity(
                            opacity: f.clamp(0.0, 1.0),
                            child: Text(
                              formatEtb(e.value, decimals: false),
                              style: TType.micro.copyWith(
                                color: TB.inkSoft,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 34,
                            height: 96 * f,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: e.value == max ? TB.brand : TB.brandMist,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            e.key,
                            style: TType.micro.copyWith(color: TB.inkFaint),
                          ),
                        ],
                      ),
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

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.share,
    required this.delay,
  });

  final _Category category;
  final double share;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TB.s8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TB.rMd),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: TB.brandMist,
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, size: 18, color: TB.brandInk),
          ),
          const SizedBox(width: TB.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        style: TType.caption.copyWith(
                          color: TB.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      formatEtb(category.amount),
                      style: TType.caption.copyWith(
                        color: TB.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(TB.rPill),
                  child: Stack(
                    children: [
                      Container(height: 6, color: TB.track),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: share),
                        duration: Motion.slow + delay,
                        curve: Motion.easeExpo,
                        builder: (context, f, _) => FractionallySizedBox(
                          widthFactor: f,
                          child: Container(height: 6, color: TB.brand),
                        ),
                      ),
                    ],
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
