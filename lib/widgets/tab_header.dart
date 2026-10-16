import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'glass.dart';
import 'reveal.dart';
import 'ripple_backdrop.dart';

/// The green header used by every tab but Home: the ripple ground, a
/// two-beat title, and an optional frosted search field.
class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.payoff,
    this.onSearch,
    this.searchHint = 'Search',
    this.leading,
  });

  final String eyebrow;
  final String title;
  final String payoff;
  final ValueChanged<String>? onSearch;
  final String searchHint;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(TB.r3xl),
      ),
      child: RippleBackdrop(
        child: Padding(
          padding: EdgeInsets.fromLTRB(TB.s20, top + TB.s20, TB.s20, TB.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: TB.s12),
                    ],
                    Text(
                      eyebrow,
                      style: TType.eyebrow.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TB.s8),
              Reveal(
                index: 1,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$title ',
                        style: TType.headline.copyWith(color: Colors.white),
                      ),
                      TextSpan(
                        text: payoff,
                        style: TType.accentHeadline.copyWith(
                          color: const Color(0xFFFFF4C9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (onSearch != null) ...[
                const SizedBox(height: TB.s20),
                Reveal(
                  index: 2,
                  child: GlassPanel(
                    radius: TB.rPill,
                    fill: const Color(0x33FFFFFF),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(width: TB.s16),
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: TB.s8),
                          Expanded(
                            child: TextField(
                              onChanged: onSearch,
                              cursorColor: Colors.white,
                              style: TType.body.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: searchHint,
                                hintStyle: TType.body.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: TB.s16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
