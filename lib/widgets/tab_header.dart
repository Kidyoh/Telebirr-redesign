import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'reveal.dart';

/// The light header for Payment, Apps and Analytics: a small caps eyebrow,
/// a two-tone bold title, and an optional white search pill.
class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.payoff,
    this.onSearch,
    this.searchHint = 'Search',
  });

  final String eyebrow;
  final String title;
  final String payoff;
  final ValueChanged<String>? onSearch;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(TB.s20, top + TB.s16, TB.s20, TB.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            child: Text(
              eyebrow,
              style: TType.eyebrow.copyWith(color: TB.inkFaint),
            ),
          ),
          const SizedBox(height: 6),
          Reveal(
            index: 1,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$title '),
                  TextSpan(
                    text: payoff,
                    style: const TextStyle(color: TB.brandDeep),
                  ),
                ],
              ),
              style: TType.title1.copyWith(
                color: TB.ink,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          if (onSearch != null) ...[
            const SizedBox(height: TB.s16),
            Reveal(
              index: 2,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: TB.s16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TB.rPill),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: TB.inkSoft,
                      size: 22,
                    ),
                    const SizedBox(width: TB.s8),
                    Expanded(
                      child: TextField(
                        onChanged: onSearch,
                        cursorColor: TB.brandDeep,
                        style: TType.body.copyWith(color: TB.ink),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: searchHint,
                          hintStyle: TType.body.copyWith(color: TB.inkFaint),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
