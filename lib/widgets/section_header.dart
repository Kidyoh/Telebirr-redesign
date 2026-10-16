import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'pressable.dart';

/// A two-beat section title ("Services *for every day*") with an optional
/// trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.payoff,
    this.action,
    this.onAction,
  });

  final String title;
  final String? payoff;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TType.title1.copyWith(color: TB.ink),
                ),
                if (payoff != null)
                  TextSpan(
                    text: ' $payoff',
                    style: TType.accentHeadline.copyWith(
                      color: TB.brandInk,
                      fontSize: 26,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (action != null)
          Pressable(
            scale: Motion.pressPill,
            onTap: onAction ?? () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: TB.surfaceRaised,
                borderRadius: BorderRadius.circular(TB.rPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    action!,
                    style: TType.caption.copyWith(
                      color: TB.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: TB.ink,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
