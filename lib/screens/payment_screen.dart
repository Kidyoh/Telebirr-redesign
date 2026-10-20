import 'package:flutter/material.dart';

import '../data/services.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/brand_tile.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';
import '../widgets/tab_header.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _open = <int>{0};
  String _query = '';
  int _chip = 0;
  final _keys = List.generate(paymentCategories.length, (_) => GlobalKey());

  void _jumpTo(int i) {
    setState(() {
      _chip = i;
      _open.add(i);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keys[i].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: Motion.slow,
          curve: Motion.easeExpo,
          alignment: 0.05,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final q = _query.trim().toLowerCase();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: TabHeader(
            eyebrow: 'PAYMENT',
            title: 'Pay every bill,',
            payoff: 'in one place.',
            searchHint: 'Search billers',
            onSearch: (v) => setState(() => _query = v),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(TB.s20, TB.s16, TB.s20, 8),
              itemCount: paymentCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: TB.s8),
              itemBuilder: (context, i) => _CategoryChip(
                category: paymentCategories[i],
                selected: i == _chip,
                onTap: () => _jumpTo(i),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(TB.s20, TB.s12, TB.s20, bottom + TB.s32),
          sliver: SliverList.builder(
            itemCount: paymentCategories.length,
            itemBuilder: (context, i) {
              final cat = paymentCategories[i];
              final items = q.isEmpty
                  ? cat.items
                  : cat.items
                        .where((s) => s.label.toLowerCase().contains(q))
                        .toList();
              if (items.isEmpty) return const SizedBox.shrink();
              final open = q.isNotEmpty || _open.contains(i);
              return Reveal(
                key: _keys[i],
                index: i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: TB.s12),
                  child: _CategoryCard(
                    category: cat,
                    items: items,
                    open: open,
                    onToggle: () => setState(() {
                      _open.contains(i) ? _open.remove(i) : _open.add(i);
                      _chip = i;
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final PaymentCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressPill,
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? TB.button : TB.surfaceRaised,
          borderRadius: BorderRadius.circular(TB.rPill),
        ),
        child: Row(
          children: [
            Icon(
              category.icon,
              size: 16,
              color: selected ? TB.onButton : TB.inkSoft,
            ),
            const SizedBox(width: 6),
            Text(
              category.title,
              style: TType.caption.copyWith(
                color: selected ? TB.onButton : TB.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.items,
    required this.open,
    required this.onToggle,
  });

  final PaymentCategory category;
  final List<Service> items;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Motion.medium,
      curve: Motion.easeExpo,
      decoration: BoxDecoration(
        color: TB.surfaceRaised,
        borderRadius: BorderRadius.circular(TB.rLg),
        boxShadow: open ? TB.shadowSoft : const [],
      ),
      child: Column(
        children: [
          Pressable(
            scale: 0.98,
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(TB.s16, 14, TB.s16, 14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Motion.medium,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: open ? TB.brand : TB.brandMist,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      size: 20,
                      color: open ? Colors.white : TB.brandInk,
                    ),
                  ),
                  const SizedBox(width: TB.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: TType.title2.copyWith(color: TB.ink),
                        ),
                        Text(
                          '${items.length} biller${items.length == 1 ? '' : 's'}',
                          style: TType.caption,
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: Motion.medium,
                    curve: Motion.easeSpring,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: TB.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: TB.ink,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Motion.medium,
            curve: Motion.easeExpo,
            alignment: Alignment.topCenter,
            child: !open
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                      TB.s12,
                      TB.s4,
                      TB.s12,
                      TB.s20,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: TB.s16,
                            crossAxisSpacing: TB.s4,
                            childAspectRatio: 0.74,
                          ),
                      itemCount: items.length,
                      itemBuilder: (context, i) => Reveal(
                        index: i,
                        rise: 10,
                        duration: Motion.medium,
                        child: BrandTile(service: items[i], compact: true),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
