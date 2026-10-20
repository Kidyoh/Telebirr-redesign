import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'pressable.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// The flat white tab bar: outlined grey icons, the active one filled green
/// with a small spring pop and a bold label.
class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: Pressable(
                  scale: Motion.pressRound,
                  semanticLabel: items[i].label,
                  onTap: () => onChanged(i),
                  child: _Cell(item: items[i], active: i == index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.item, required this.active});

  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey(active),
          tween: Tween(begin: active ? 0.7 : 1, end: 1),
          duration: Motion.medium,
          curve: Motion.easeBack,
          builder: (context, s, child) =>
              Transform.scale(scale: s, child: child),
          child: AnimatedSwitcher(
            duration: Motion.fast,
            child: Icon(
              active ? item.activeIcon : item.icon,
              key: ValueKey(active),
              size: 24,
              color: active ? TB.brand : TB.inkFaint,
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: Motion.fast,
          style: TType.micro.copyWith(
            color: active ? TB.ink : TB.inkFaint,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(item.label, maxLines: 1),
        ),
      ],
    );
  }
}
