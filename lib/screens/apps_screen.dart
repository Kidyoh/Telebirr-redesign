import 'package:flutter/material.dart';

import '../data/services.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/brand_tile.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/tab_header.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final q = _query.trim().toLowerCase();
    final apps = q.isEmpty
        ? miniApps
        : miniApps.where((a) => a.label.toLowerCase().contains(q)).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: TabHeader(
            eyebrow: 'MINI APPS · ${miniApps.length}',
            title: 'Everything you use,',
            payoff: 'inside telebirr.',
            searchHint: 'Search apps',
            onSearch: (v) => setState(() => _query = v),
          ),
        ),
        if (q.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(TB.s20, TB.s24, TB.s20, 0),
            sliver: SliverToBoxAdapter(
              child: Reveal(index: 2, child: _FeaturedApps()),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(TB.s20, TB.s28, TB.s20, 0),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: q.isEmpty ? 'All' : 'Results',
              payoff: q.isEmpty ? 'apps' : null,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(TB.s20, TB.s16, TB.s20, bottom + 120),
          sliver: apps.isEmpty
              ? const SliverToBoxAdapter(child: _NoResults())
              : SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: TB.s12,
                    crossAxisSpacing: TB.s12,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: apps.length,
                  itemBuilder: (context, i) => Reveal(
                    key: ValueKey(apps[i].label),
                    index: i % 9,
                    child: _AppCard(service: apps[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _FeaturedApps extends StatelessWidget {
  const _FeaturedApps();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Featured(
            service: miniApps[3],
            eyebrow: 'TRAVEL',
            line: 'Fly with',
            payoff: 'one tap.',
            color: TB.paperPeach,
            ink: const Color(0xFF6B2A12),
          ),
        ),
        const SizedBox(width: TB.s12),
        Expanded(
          child: _Featured(
            service: miniApps[4],
            eyebrow: 'IDENTITY',
            line: 'Your Fayda,',
            payoff: 'in your pocket.',
            color: TB.paperSky,
            ink: const Color(0xFF0B3F5F),
          ),
        ),
      ],
    );
  }
}

class _Featured extends StatelessWidget {
  const _Featured({
    required this.service,
    required this.eyebrow,
    required this.line,
    required this.payoff,
    required this.color,
    required this.ink,
  });

  final Service service;
  final String eyebrow;
  final String line;
  final String payoff;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {},
      semanticLabel: service.label,
      child: Container(
        height: 176,
        padding: const EdgeInsets.all(TB.s16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(TB.rXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ServiceMark(service: service, size: 40),
            ),
            const Spacer(),
            Text(eyebrow, style: TType.eyebrow.copyWith(color: ink)),
            const SizedBox(height: 2),
            Text(
              line,
              style: TType.bodyStrong.copyWith(color: ink, fontSize: 16),
            ),
            Text(
              payoff,
              style: TType.accentHeadline.copyWith(
                color: ink,
                fontSize: 16,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {},
      semanticLabel: service.label,
      child: Container(
        padding: const EdgeInsets.fromLTRB(TB.s8, TB.s16, TB.s8, TB.s12),
        decoration: BoxDecoration(
          color: TB.surfaceRaised,
          borderRadius: BorderRadius.circular(TB.rLg),
          boxShadow: TB.shadowSoft,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Center(child: ServiceMark(service: service, size: 50)),
            ),
            const Spacer(),
            Text(
              service.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TType.caption.copyWith(
                color: TB.ink,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TB.s40),
      child: Column(
        children: [
          Text(
            'Nothing here yet',
            style: TType.calmTitle.copyWith(color: TB.ink),
          ),
          const SizedBox(height: TB.s8),
          Text(
            'Try another name, or browse all apps.',
            style: TType.body.copyWith(color: TB.inkSoft),
          ),
        ],
      ),
    );
  }
}
